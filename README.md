# @allstak-io/react-native

AllStak React Native SDK — `ErrorUtils` + Hermes rejection tracking + Platform device tags.  
Includes native Android (Kotlin) and iOS (Swift) crash capture modules under `./native/`.

## Install

> **Auth required:** GitHub Packages requires a token with `read:packages` scope.

### 1. Configure `.npmrc`

```ini
@allstak-io:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=YOUR_GITHUB_PAT
```

### 2. Install

```bash
npm install @allstak-io/react-native@0.1.1 @allstak-io/core@0.1.1
# react-native >=0.70 is an optional peer dep
```

## Usage

```ts
import { AllStak } from '@allstak-io/core';
import { installReactNative } from '@allstak-io/react-native';

// Initialize the base SDK
AllStak.init({
  apiKey: process.env.ALLSTAK_API_KEY!,
  environment: 'production',
  release: 'v1.0.0',
  // ingest: 'https://api.allstak.sa'  ← default
});

// Install RN-specific instrumentation
installReactNative({
  // Hooks ErrorUtils for uncaught JS errors
  // Installs Hermes rejection tracking
  // Tags every event with Platform.OS and Platform.Version
});
```

## What's captured automatically after `installReactNative()`

| Capability | Notes |
|-----------|-------|
| Uncaught JS errors | Via `ErrorUtils.setGlobalHandler` |
| Unhandled promise rejections | Via Hermes rejection tracking |
| `Platform.OS` / `Platform.Version` tags | Attached to every event |

## Native crash capture (Android/iOS)

Native modules for Java/Kotlin (Android) and Obj-C/Swift (iOS) crash capture are in `./native/`. See [`native/README.md`](./native/README.md) for platform-specific setup.

## API

| Export | Description |
|--------|-------------|
| `AllStak` | Re-exported from `@allstak-io/core` |
| `installReactNative(opts?)` | Hooks ErrorUtils + Hermes + device tags |
| `ReactNativeInstallOptions` | Options type for `installReactNative` |

## GitHub Packages

- **Package:** `@allstak-io/react-native`
- **Registry:** `https://npm.pkg.github.com`
- **Repo:** [github.com/allstak-io/allstak-react-native](https://github.com/allstak-io/allstak-react-native)
- **Releases:** [github.com/allstak-io/allstak-react-native/releases](https://github.com/allstak-io/allstak-react-native/releases)

## Versioning

Tags must match `package.json` version exactly (e.g. `v0.1.1`). The release workflow fails if there's a mismatch.
