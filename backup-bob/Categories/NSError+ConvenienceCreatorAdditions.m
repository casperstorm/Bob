//
//  Created by Peter Gammelgaard on 08/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import "NSError+ConvenienceCreatorAdditions.h"


@implementation NSError (ConvenienceCreatorAdditions)

+ (NSError *)errorWithDescription:(NSString *)localizedDescription code:(NSInteger)code {
    NSString *domain = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    NSError *error = [NSError errorWithDomain:domain code:code userInfo:[NSDictionary dictionaryWithObject:localizedDescription forKey:NSLocalizedDescriptionKey]];
    return error;
}

@end