//
// Created by Casper Storm Larsen on 10/05/14.
// SHAPE A/S
//


#import "PaddingTextView.h"


@implementation PaddingTextView

- (NSPoint)textContainerOrigin {
    NSPoint origin = [super textContainerOrigin];
    NSPoint newOrigin = NSMakePoint(origin.x + 5.0f, origin.y + 7.0f);
    return newOrigin;
}

@end