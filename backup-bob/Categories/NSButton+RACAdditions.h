//
//  Created by Peter Gammelgaard on 09/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSButton (RACAdditions)
@property (assign, nonatomic, getter = isEnabled, setter = setEnabled:) BOOL enabled;
@property (assign, nonatomic, getter = state, setter = setState:) NSInteger state;

@end