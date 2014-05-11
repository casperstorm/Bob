//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import <Foundation/Foundation.h>


@interface TarsnapClient : NSObject

- (RACSignal *)makeWithDeltas:(NSArray *)deltas folders:(NSArray *)folders;
- (RACSignal *)sleep;

- (void)terminate;
@end