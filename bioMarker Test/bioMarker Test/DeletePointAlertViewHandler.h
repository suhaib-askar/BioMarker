//
//  DeletePointAlertViewHandler.h
//  bioMarker Test
//
//  Created by Dylan on 3/22/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlertViewHandler.h"
#import "annotateView.h"

@interface DeletePointAlertViewHandler : NSObject<AlertViewHandler> {
    annotateView* view;
    NSArray* eventStack;
}

-(id) initWithAnnotateView:(annotateView*)annotationView andEventStack:(NSArray*) stack;

@end
