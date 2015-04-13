//
//  PointAttribute.h
//  bioMarker Test
//
//  Created by Bradley Cutshall on 2/24/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributeWriter.h"

@interface PointAttribute : NSObject <AttributeWriter> {
    NSValue* attribute;
}

-(id)initWithAttribute:(NSValue*)pointValue;

@end
