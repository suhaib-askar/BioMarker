//
//  AddPointAlertViewHandler.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/7/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlertViewHandler.h"
#import "annotateView.h"

@interface AddPointAlertViewHandler : NSObject<AlertViewHandler> {
    
    annotateView* view;
    
}

-(id) initWithAnnotationView:(annotateView*)annotateView;

@end
