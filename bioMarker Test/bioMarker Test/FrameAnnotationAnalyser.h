//
//  FrameAnnotationAnalyser.h
//  bioMarker Test
//
//  Created by Dylan on 1/12/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FrameAnnotationAnalyser <NSObject>

-(NSString *) getLabel;

-(NSArray *) listIdentifiers;

-(NSNumber *)getXPlotValue:(NSString*) identifierLabel: (float) videoTime;

-(NSNumber *)getYPlotValue:(NSString*) identifierLabel: (float) videoTime;

@end

