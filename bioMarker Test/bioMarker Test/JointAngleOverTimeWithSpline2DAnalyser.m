//
//  JointAngleOverTimeWithSpline2DAnalyser.m
//  bioMarker Test
//
//  Created by Dylan on 1/14/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "JointAngleOverTimeWithSpline2DAnalyser.h"
#import "AnalysisUtil.h"

@implementation JointAngleOverTimeWithSpline2DAnalyser

-(id)initWithAnnotatedVideoModel:(AnnotatedVideoModel *)annotationModel {
    annotatedVideoModel = annotationModel;
    
    //Construct spline polynomial here
    
    NSString* testLimb = @"arm";
    NSString* testJoint = @"b";
    
    NSDictionary* orderedPairs = [AnalysisUtil getOrderPairsForJoint:testJoint :testLimb :annotatedVideoModel];
    
    
    
   // NSMutableArray
    
    /*
     
     function ToReducedRowEchelonForm(Matrix M) is
        lead := 0
        rowCount := the number of rows in M
        columnCount := the number of columns in M
        for 0 ≤ r < rowCount do
            if columnCount ≤ lead then
                stop
            end if
            i = r
            while M[i, lead] = 0 do
                i = i + 1
                if rowCount = i then
                    i = r
                    lead = lead + 1
                    if columnCount = lead then
                        stop
                    end if
                end if
        end while
        Swap rows i and r
        If M[r, lead] is not 0 divide row r by M[r, lead]
        for 0 ≤ i < rowCount do
            if i ≠ r do
                Subtract M[i, lead] multiplied by row r from row i
            end if
        end for
        lead = lead + 1
        end for
     end function
     
     */
    
    return self;
    
}


-(NSArray*) listIdentifiers {
    return nil;
}


-(NSNumber*) getXPlotValue:(NSString *)identifierLabel: (float) videoTime {
    NSDecimalNumber *x = [[NSDecimalNumber alloc] initWithFloat:videoTime];
    return x;
}


-(NSNumber*) getYPlotValue:(NSString *)identifierLabel: (float) videoTime {
    
    //Return y values using spline
    
    return [[NSDecimalNumber alloc] initWithFloat:1.0];
}

@end
