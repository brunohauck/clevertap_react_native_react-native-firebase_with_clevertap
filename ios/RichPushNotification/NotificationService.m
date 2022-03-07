//
//  NotificationService.m
//  RichPushNotification
//
//  Created by Jay Mehta on 07/03/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "NotificationService.h"
#import <CleverTap-iOS-SDK/CleverTap.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
//    self.contentHandler = contentHandler;
//    self.bestAttemptContent = [request.content mutableCopy];
//
//    // Modify the notification content here...
//    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
//
//    self.contentHandler(self.bestAttemptContent);
  
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];

 // While running the Application add CleverTap Account ID and Account token in your .plist file

 // call to record the Notification viewed
     [[CleverTap sharedInstance] recordNotificationViewedEventWithData:request.content.userInfo];
  
  [super didReceiveNotificationRequest:request withContentHandler:contentHandler];
  
}

//- (void)serviceExtensionTimeWillExpire {
//    // Called just before the extension will be terminated by the system.
//    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
//    self.contentHandler(self.bestAttemptContent);
//}

@end
