//
//  Created by Peter Gammelgaard on 09/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import "FolderPreferencesViewModel.h"
#import "BackupModel.h"


@implementation FolderPreferencesViewModel {

}

- (id)init {
    self = [super init];
    if (self) {
        RAC(self, folders) = RACObserve([BackupModel sharedInstance], folders);
    }

    return self;
}


@end