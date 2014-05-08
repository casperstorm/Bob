//
//  Created by Peter Gammelgaard on 08/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (ConvenienceCreatorAdditions)
+ (NSError *)errorWithDescription:(NSString *)localizedDescription code:(NSInteger)code;
@end