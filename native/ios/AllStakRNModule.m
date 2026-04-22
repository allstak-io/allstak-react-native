// RCTBridgeModule bridging AllStakCrashHandler to JS.
//
// SCAFFOLDED: requires React Native iOS project with CocoaPods autolinking
// to verify end-to-end.

#import <React/RCTBridgeModule.h>
#import "AllStakCrashHandler.h"

@interface AllStakRNModule : NSObject <RCTBridgeModule>
@end

@implementation AllStakRNModule

RCT_EXPORT_MODULE(AllStakNative);

RCT_EXPORT_METHOD(install:(NSString *)release
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    [AllStakCrashHandler installWithRelease:release];
    resolve(@YES);
}

RCT_EXPORT_METHOD(drainPendingCrash:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    NSString *json = [AllStakCrashHandler drainPendingCrash];
    resolve(json ?: [NSNull null]);
}

@end
