//
//  ElementHandler.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 3/19/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ElementHandler <NSObject>

-(void) handleElementStart:(NSDictionary*) attributes;

-(void) handleElementEnd;

@end
