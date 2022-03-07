/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import <CleverTap-iOS-SDK/CleverTap.h>
#import <clevertap-react-native/CleverTapReactManager.h>
#import <React/RCTLinkingManager.h>
#import <Firebase.h>


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  
  RCTBridge *bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:launchOptions];
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:bridge
                                                   moduleName:@"ReactNativeExampleiOS"
                                            initialProperties:launchOptions];

  rootView.backgroundColor = [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1];
  
  [self registerForPush];
  // integrate CleverTap SDK using the autoIntegrate option
  [CleverTap autoIntegrate];
  [CleverTap setDebugLevel:CleverTapLogDebug];
  [[CleverTapReactManager sharedInstance] applicationDidLaunchWithOptions:launchOptions];
  
  [FIRApp configure]; //Add This Line
  //[RNFirebaseNotifications configure];  //Add This Line
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  UIViewController *rootViewController = [UIViewController new];
  rootViewController.view = rootView;
  self.window.rootViewController = rootViewController;
  [self.window makeKeyAndVisible];
  return YES;
}
-(void) registerForPush {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
    if(!error){
      dispatch_async(dispatch_get_main_queue(), ^{
         [[UIApplication sharedApplication] registerForRemoteNotifications];
      });
    }
    }];

}
//Device Token
-(void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
  NSLog(@"Device Token : %@",deviceToken);

}
-(void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
  NSLog(@"Error %@",error.description);
}

//Handle Deeplink
-(BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [RCTLinkingManager application:app openURL:url options:options];
    
}
-(BOOL) application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
  
  
  NSLog(@"%@",userActivity.webpageURL);
  
  return TRUE;
  
}

-(BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType{
  
  return TRUE;
}
//PN Delgates
-(void) userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler{
    
  self.resp = response.notification.request.content.userInfo;
  completionHandler();
}
-(void) userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    completionHandler(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound);
}


- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
#if DEBUG
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:nil];
#else
  return [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"jsbundle"];
#endif
}

@end
