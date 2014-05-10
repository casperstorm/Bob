//
//  Created by Peter Gammelgaard on 10/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import "SettingsModel.h"


@implementation SettingsModel {

}

+ (SettingsModel *)sharedInstance {
    static SettingsModel *sharedInstance = nil;
    static dispatch_once_t pred;

    if (sharedInstance) return sharedInstance;

    dispatch_once(&pred, ^{
        sharedInstance = [SettingsModel alloc];
        sharedInstance = [sharedInstance init];
    });

    return sharedInstance;
}

-(void)addAppAsLoginItem{
    NSString * appPath = [[NSBundle mainBundle] bundlePath];
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:appPath];

    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
            kLSSharedFileListSessionLoginItems, NULL);
    if (loginItems) {
        LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems,
                kLSSharedFileListItemLast, NULL, NULL,
                url, NULL, NULL);
        if (item){
            CFRelease(item);
        }
    }

    CFRelease(loginItems);
}

-(void)deleteAppFromLoginItem{
    NSString * appPath = [[NSBundle mainBundle] bundlePath];

    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:appPath];

    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL,
            kLSSharedFileListSessionLoginItems, NULL);

    if (loginItems) {
        UInt32 seedValue;
        NSArray  *loginItemsArray = (__bridge NSArray *)LSSharedFileListCopySnapshot(loginItems, &seedValue);
        int i = 0;
        for(i ; i< [loginItemsArray count]; i++){
            LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)[loginItemsArray
                    objectAtIndex:i];

            if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &url, NULL) == noErr) {
                NSString * urlPath = [(__bridge NSURL*)url path];
                if ([urlPath compare:appPath] == NSOrderedSame){
                    LSSharedFileListItemRemove(loginItems,itemRef);
                }
            }
        }
    }
}

@end