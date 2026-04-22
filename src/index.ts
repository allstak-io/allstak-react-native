/**
 * @allstak/react-native — React Native public API.
 *
 * Re-exports the RN integration from allstak-js/react-native:
 *   - installReactNative({...}) — hooks ErrorUtils + Hermes rejection tracking
 *     + Platform.OS tags
 *
 * Native-layer crash capture (Java/Kotlin on Android, Obj-C/Swift on iOS)
 * lives under the `native/` directory inside this package. See README.
 */
export { installReactNative, type ReactNativeInstallOptions, AllStak } from 'allstak-js/react-native';
