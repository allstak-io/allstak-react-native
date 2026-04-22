// AllStakCrashHandler.m — iOS uncaught exception capture.
//
// SCAFFOLDED: requires Xcode compile + real iOS simulator/device for
// end-to-end verification. Obj-C / UIKit imports are standard; no
// third-party dependencies.

#import "AllStakCrashHandler.h"
#import <UIKit/UIKit.h>

static NSString * const kAllStakPendingCrashKey = @"io.allstak.rn.pending_crash";
static NSString *gAllStakRelease = nil;
static NSUncaughtExceptionHandler *gAllStakPreviousHandler = NULL;

static void AllStakHandleUncaughtException(NSException *exception) {
    @try {
        NSMutableArray<NSString *> *stack = [NSMutableArray array];
        for (NSString *line in [exception callStackSymbols]) {
            NSString *trimmed = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (trimmed.length > 0) [stack addObject:trimmed];
        }

        UIDevice *dev = [UIDevice currentDevice];
        NSDictionary *metadata = @{
            @"platform": @"react-native",
            @"device.os": @"ios",
            @"device.osVersion": dev.systemVersion ?: @"",
            @"device.model": dev.model ?: @"",
            @"device.name": dev.name ?: @"",
            @"fatal": @"true",
            @"source": @"ios-NSUncaughtExceptionHandler"
        };

        NSMutableDictionary *payload = [@{
            @"exceptionClass": exception.name ?: @"NSException",
            @"message": exception.reason ?: @"(no reason)",
            @"stackTrace": stack,
            @"level": @"fatal",
            @"metadata": metadata,
        } mutableCopy];
        if (gAllStakRelease) payload[@"release"] = gAllStakRelease;

        NSError *err = nil;
        NSData *json = [NSJSONSerialization dataWithJSONObject:payload options:0 error:&err];
        if (json && !err) {
            NSString *str = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:kAllStakPendingCrashKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } @catch (NSException *ignored) {
        // never re-raise from within the crash handler
    }

    if (gAllStakPreviousHandler) {
        gAllStakPreviousHandler(exception);
    }
}

@implementation AllStakCrashHandler

+ (void)installWithRelease:(NSString *)release {
    @synchronized(self) {
        if (release) gAllStakRelease = [release copy];
        gAllStakPreviousHandler = NSGetUncaughtExceptionHandler();
        NSSetUncaughtExceptionHandler(&AllStakHandleUncaughtException);
    }
}

+ (NSString *)drainPendingCrash {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *json = [defaults stringForKey:kAllStakPendingCrashKey];
    [defaults removeObjectForKey:kAllStakPendingCrashKey];
    [defaults synchronize];
    return json;
}

@end
