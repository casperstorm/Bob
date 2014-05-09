//
// Created by Casper Storm Larsen on 08/05/14.
// SHAPE A/S
//


#import <Foundation/Foundation.h>


@interface TarsnapClient : NSObject
- (RACSignal *)start;
- (RACSignal *)sleep;
@end