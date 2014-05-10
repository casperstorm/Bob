//
//  Created by Peter Gammelgaard on 10/05/14.
//  Copyright (c) 2013 SHAPE A/S. All rights reserved.
//

#import "NSComboBox+RACAdditions.h"


@implementation NSComboBox (RACAdditions)

- (NSInteger)selectedIndex {
    return [self indexOfSelectedItem];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    [self willChangeValueForKey:@"selectedIndex"];
    [self selectItemAtIndex:selectedIndex];
    [self didChangeValueForKey:@"selectedIndex"];
}

@end