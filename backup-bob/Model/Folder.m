//
//  Created by Peter Gammelgaard on 09/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import "Folder.h"


@implementation Folder {

}

- (instancetype)initWithPath:(NSString *)path active:(BOOL)active {
    self = [super init];
    if (self) {
        self.path = path;
        self.active = active;
    }

    return self;
}

+ (instancetype)folderWithPath:(NSString *)path active:(BOOL)active {
    return [[self alloc] initWithPath:path active:active];
}


@end
