//
//  ChangeNotifier.m
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/7/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "ChangeNotifier.h"

@implementation ChangeNotifier


-(id) init {
    listeners = [[NSMutableArray alloc] init];
    return self;
}

-(void)registerListener:(id<ChangeListener>) changeListener {
    [listeners addObject:changeListener];
}

-(void)deregisterListener:(id<ChangeListener>) changeListener {
    [listeners removeObject:changeListener];
}

-(void)notify {
    for (id<ChangeListener> listener in listeners) {
        [listener changeOccured];
    }
}

@end
