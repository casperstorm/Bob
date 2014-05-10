//
//  Created by Peter Gammelgaard on 09/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Folder : NSObject <NSCoding>

@property (nonatomic, strong) NSString *path;
@property (nonatomic, getter=isActive) BOOL active;

- (instancetype)initWithPath:(NSString *)path active:(BOOL)active;

+ (instancetype)folderWithPath:(NSString *)path active:(BOOL)active;


@end