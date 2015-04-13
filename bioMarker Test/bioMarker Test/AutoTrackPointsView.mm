//
//  AutoTrackPointsView.m
//  bioMarker Test
//
//  Created by Bradley Cutshall on 2/10/15.
//  Copyright (c) 2015 Pete Willemsen. All rights reserved.
//

#import "AutoTrackPointsView.h"

@implementation AutoTrackPointsView

//- (void)paintViewWithPoints: (vector<Point2f>)points {
- (void)paintViewWithPointsAndScalar:(vector<Point2f>)points :(float)X :(float)Y {
    pointsVector = points;
    xScalar = X;
    yScalar = Y;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    bool thingy = false;
    
    
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 4.0);
    CGContextSetRGBStrokeColor(context, 1, 1, 0, 1);
    
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 4.0);
    CGContextSetRGBStrokeColor(context, 1, 1, 0, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);

    
    //draw points
    //vector<Point2f> points = [autoTrackLogic getGoodPoints][1];
    Point2f point;
    for (int i =0; i < pointsVector.size(); i++) {
        Point2f point = pointsVector[i];
        float x = (point.x) * xScalar;
        float y = (point.y) * yScalar;
        CGRect boundingRect = CGRectMake(x - 5.0, y - 5.0, 10.0, 10.0);
        CGContextAddEllipseInRect(context, boundingRect);
        CGRect textRect = CGRectMake(x+5, y+5, 20, 12);
        CGContextStrokePath(context);
        
    }
    
    
    /*
     UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
     
     CGContextSetLineCap(context, kCGLineCapRound);
     CGContextSetLineWidth(context, 4.0);
     CGContextSetRGBStrokeColor(context, 1, 1, 0, 1);
     
     CGContextSetLineCap(context, kCGLineCapRound);
     CGContextSetLineWidth(context, 4.0);
     CGContextSetRGBStrokeColor(context, 1, 1, 0, 1);
     CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
     
     for (ContentNode * limbNode in [AnnotationModelUtil getLimbNodes:currentFrameData]) {
     ContentNode * prevNode = nil;
     NSString * limbName = (NSString*)[limbNode getAttribute: NAME_ATTRIBUTE];
     ContentNode * firstPointNode = nil;
     for (ContentNode * pointNode in [limbNode getChildren]) {
     
     if (firstPointNode == nil) {
     firstPointNode = pointNode;
     }
     
     CGPoint point = [((NSValue*)[pointNode getAttribute:POINT_ATTRIBUTE]) CGPointValue];
     if (prevNode != nil) {
     CGPoint point2 = [((NSValue*)[prevNode getAttribute:POINT_ATTRIBUTE]) CGPointValue];
     CGContextBeginPath(context);
     CGContextMoveToPoint(context, point.x, point.y);
     CGContextAddLineToPoint(context, point2.x, point2.y);
     CGContextStrokePath(context);
     }
     prevNode = pointNode;
     if ([limbName isEqualToString: currentLimb]) {
     CGContextSetStrokeColorWithColor(context, [UIColor cyanColor].CGColor);
     CGRect selectedRect = CGRectMake(point.x - 6, point.y - 6, 12.0, 12.0);
     CGContextAddEllipseInRect(context, selectedRect);
     CGContextStrokePath(context);
     }
     CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
     CGRect boundingRect = CGRectMake(point.x - 5.0, point.y - 5.0, 10.0, 10.0);
     CGContextAddEllipseInRect(context, boundingRect);
     CGRect textRect = CGRectMake(point.x+5, point.y+5, 20, 12);
     CGContextStrokePath(context);
     NSString* pointName = (NSString*)[pointNode getAttribute:NAME_ATTRIBUTE];
     [pointName drawInRect:textRect withFont:[UIFont fontWithName:@"Georgia" size:12]];
     CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
     }
     /*
     CGPoint point = [((NSValue*)[firstPointNode getAttribute:POINT_ATTRIBUTE]) CGPointValue];
     CGContextSetLineWidth(context, 2);
     CGContextSetTextDrawingMode(context, kCGTextStroke);
     CGContextSetStrokeColorWithColor(context, [[UIColor redColor] CGColor]);
     [limbName drawAtPoint:point withFont:font];
     CGContextSetTextDrawingMode(context, kCGTextFill);
     CGContextSetFillColorWithColor(context, [[UIColor blueColor] CGColor]);
     [limbName drawAtPoint:point withFont:font];
     *
     }*/
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if (!hasNewPoint) {
    
        //if(currentFrameImage == 0){
        //    return;
        //}
    
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        newCGPoint = [touch locationInView:self];
        
    
        hasNewPoint = true;
    
        NSLog(@"touchesBegan: added currentPoint: %f, %f", point.x, point.y);
    }
    
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    //if(currentFrameImage == 0){
    //    return;
    //}
    
    UITouch *touch = [touches anyObject];
    
    //if ([gestureController runGestureActions:touch :TOUCHES_MOVED]) {
    //    [self setNeedsDisplay];
    //}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //if(currentFrameImage == 0){
    //    return;
    //}
    
    NSLog(@"touchesEnd:");
    
}

/**
 * Returns (-1, -1) if no new point
 */
-(CGPoint)getNewPoint {
    CGPoint p = CGPoint {-1, -1};
    if (hasNewPoint) {
        p = newCGPoint;
        hasNewPoint = false;
    }
    return p;
}

/*
- (void) setAlertViewHandler:(id<AlertViewHandler>)handler {
    alertViewHandler = handler;
}

- (void)alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertViewHandler handleAlertViewButtonClick: alert: buttonIndex];
    [self setNeedsDisplay];
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    NSMutableDictionary* args = [[NSMutableDictionary alloc] init];
    [args setObject:inputText forKey:@"entered_text"];
    [args setObject:[AnnotationModelUtil getLimbNodeWithName:currentFrameData: currentLimb] forKey:@"parent_node"];
    NSArray* validationFalures = [_validationService runValidations:args];
    if( [validationFalures count] == 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
*/

@end
