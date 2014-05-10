//
//  Created by Peter Gammelgaard on 10/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (NotificationSignal)

- (RACSignal *)rac_notifyUntilDealloc:(NSString *)notificationName;

@end