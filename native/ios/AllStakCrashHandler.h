// AllStakCrashHandler — iOS native crash capture for React Native.
//
// SCAFFOLDED: compiles against UIKit; requires an Xcode project + real
// device/simulator to verify end-to-end.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AllStakCrashHandler : NSObject

/// Install the NSUncaughtExceptionHandler. Idempotent.
+ (void)installWithRelease:(nullable NSString *)release;

/// Returns the JSON payload stashed by the previous crash (or nil), and
/// clears it from NSUserDefaults.
+ (nullable NSString *)drainPendingCrash;

@end

NS_ASSUME_NONNULL_END
