//
//  VideoSelectionListElementWrapper.m
//  bioMarker Test
//
//  Created by Dylan on 3/23/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "VideoSelectionListElementWrapper.h"


@implementation VideoSelectionListElementWrapper

-(id)initWithBool:(bool)a {
    annotated = a;
    return self;
}

-(bool) isAnnotated {
    return annotated;
}

@end
