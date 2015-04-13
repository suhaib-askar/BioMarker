//
//  PointAttribute.m
//  bioMarker Test
//
//  Created by Bradley Cutshall on 2/24/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "PointAttribute.h"

@implementation PointAttribute


-(id)initWithAttribute:(NSValue*)pointValue {
    attribute = pointValue;
    return self;
}

-(NSString*)writeAttribute{
    NSMutableString* orderedPair = [[NSMutableString alloc] init];
    [orderedPair appendString:[NSString stringWithFormat:@"%f",[attribute CGPointValue].x]];
    [orderedPair appendString:@","];
    [orderedPair appendString:[NSString stringWithFormat:@"%f",[attribute CGPointValue].y]];
    
    return [NSString stringWithString:orderedPair];
}
                                    
@end
