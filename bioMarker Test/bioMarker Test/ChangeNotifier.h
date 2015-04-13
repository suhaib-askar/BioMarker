//
//  ChangeNotifier.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/7/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChangeListener.h"

//This is to notify objects that maintain a cache of some sort to clear them

@interface ChangeNotifier : NSObject {
    
    NSMutableArray* listeners;
    
}

-(void)registerListener:(id<ChangeListener>) changeListener;

-(void)deregisterListener:(id<ChangeListener>) changeListener;

-(void)notify;

@end
