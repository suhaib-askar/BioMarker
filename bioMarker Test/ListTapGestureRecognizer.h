//
//  ListTapGestureRecognizer.h
//  bioMarker Test
//
//  Created by Dylan on 3/23/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListTapGestureRecognizer : UITapGestureRecognizer {
    int elementIndex;
}

-(id)initWithTarget:(id)target action:(SEL)action andIndex:(int)index;

-(int) getElementIndex;

@end
