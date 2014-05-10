//
//  Created by Peter Gammelgaard on 10/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import "NSObject+NotificationSignal.h"


@implementation NSObject (NotificationSignal)

- (RACSignal *)rac_notifyUntilDealloc:(NSString *)notificationName {
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    return [[notificationCenter rac_addObserverForName:notificationName object:nil] takeUntil:[self rac_willDeallocSignal]];
}



@end