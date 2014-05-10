//
//  Created by Peter Gammelgaard on 09/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MASPreferences/MASPreferencesViewController.h>


static NSString *const ColumnActiveIdentifier = @"ActiveIdentifier";
static NSString *const ColumnPathIdentifier = @"PathIdentfier";
@interface FolderPreferencesViewController : NSViewController <MASPreferencesViewController, NSTableViewDataSource, NSTableViewDelegate>
@end