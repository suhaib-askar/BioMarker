//
//  ListTapGestureRecognizer.m
//  bioMarker Test
//
//  Created by Dylan on 3/23/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "ListTapGestureRecognizer.h"

@implementation ListTapGestureRecognizer

-(id)initWithTarget:(id)target action:(SEL)action andIndex:(int)index {
    self = [super initWithTarget:target action:action];
    elementIndex = index;
    return self;
}


-(int)getElementIndex {
    return elementIndex;
}

@end
