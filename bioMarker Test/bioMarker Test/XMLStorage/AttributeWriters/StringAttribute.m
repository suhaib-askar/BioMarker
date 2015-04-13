//
//  StringAttribute.m
//  bioMarker Test
//
//  Created by Bradley Cutshall on 2/24/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "StringAttribute.h"

@implementation StringAttribute

-(id)initWithAttribute:(NSString*)string {
    attribute = string;
    return self;
}

-(NSString*)writeAttribute {
    return attribute;
}

@end
