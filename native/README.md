# @allstak/react-native — native crash capture

**Status: SCAFFOLDED, requires real device/emulator verification.**

This directory contains the Android (Java) and iOS (Obj-C) native modules
that intercept uncaught platform-level crashes — the ones that can't be
caught from the JS layer via `ErrorUtils`.

## Files

| File | Purpose |
|---|---|
| `android/src/main/java/io/allstak/rn/AllStakCrashHandler.java` | Installs `Thread.setDefaultUncaughtExceptionHandler`, serialises the crash to `SharedPreferences`, survives process death. |
| `android/src/main/java/io/allstak/rn/AllStakRNModule.java` | `ReactContextBaseJavaModule` exposing `install(release)` + `drainPendingCrash()` to JS. |
| `ios/AllStakCrashHandler.{h,m}` | `NSSetUncaughtExceptionHandler` → `NSUserDefaults`. |
| `ios/AllStakRNModule.m` | `RCTBridgeModule` exposing the same API. |

## JS-side drain

The `@allstak/react-native` package exports `drainPendingNativeCrashes(release?)`
which calls `NativeModules.AllStakNative.drainPendingCrash()`, parses the JSON
payload (already DTO-compatible with `/ingest/v1/errors`), and re-submits it via
`AllStak.captureException` so the crash appears as a regular error group tagged
`native.crash=true` + `device.os=android|ios` + `fatal=true`.

Call it once early in your app init (inside a `try/catch`), *after* `AllStak.init()`:

```ts
import { AllStak, installReactNative, drainPendingNativeCrashes } from '@allstak/react-native';

AllStak.init({ apiKey: '...', release: 'my-app@1.2.3' });
installReactNative();
drainPendingNativeCrashes('my-app@1.2.3');
```

## How to finish the integration (per-app, one-time)

### Bare React Native — Android

1. Copy `native/android/src/main/java/io/allstak/rn/*.java` into your app's
   `android/app/src/main/java/...` (or a local autolinked module).
2. Create a `ReactPackage` that registers `AllStakRNModule` — add to
   `getPackages()` in `MainApplication.java`.
3. In `MainApplication.onCreate`, call
   `AllStakCrashHandler.install(this, BuildConfig.VERSION_NAME)` BEFORE
   `SoLoader.init(...)` so the handler is armed before any RN code runs.

### Bare React Native — iOS

1. Drag `native/ios/AllStakCrashHandler.{h,m}` + `AllStakRNModule.m` into the
   Xcode project.
2. Add `#import "AllStakCrashHandler.h"` to `AppDelegate.m` and call
   `[AllStakCrashHandler installWithRelease:@"<release>"]` at the top of
   `application:didFinishLaunchingWithOptions:` (before RCTBridge is built).
3. CocoaPods autolinking will wire the `RCTBridgeModule` automatically.

### Expo

Bare workflow only for now — Expo Go cannot load custom native modules.
Config-plugin wrapper is a planned follow-up.

## Verification checklist (device/emulator required)

- [ ] Android Java crash (throw from MainActivity.onResume) → app dies →
      relaunch → dashboard shows error group with
      `exceptionClass=RuntimeException`, `device.os=android`, `fatal=true`,
      `stackTrace` visible.
- [ ] iOS Obj-C exception (`@throw [NSException exceptionWithName:...]`) →
      same flow, `device.os=ios`.

None of the above can be verified from a browser Chrome MCP session.
Flag this in the report as *scaffolded, verification blocked on physical
build env*.
