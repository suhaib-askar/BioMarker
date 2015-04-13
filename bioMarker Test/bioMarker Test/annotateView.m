//
//  annotateView.m
//  bioMarker Test
//
//  Created by Pete Willemsen on 9/25/12.
//  Copyright (c) 2012 Pete Willemsen. All rights reserved.
//

#import "annotateView.h"
#import "AnnotationModelUtil.h"
#import "AttributeKey.h"
#import "TouchType.h"

@interface annotateView()
@end

@implementation annotateView
@synthesize currentLimb;
@synthesize currentFrameImage;
@synthesize currentFrameData;
@synthesize gestureController;
@synthesize currentPoint;
@synthesize changeNotifier;
// This is what synthesize will do for nonatomic properties
- (NSMutableArray *)drawnPoints
{
    // lazy instantiation
    /*
    if (_drawnPoints == nil) _drawnPoints = [[NSMutableDictionary alloc] init];
    return _drawnPoints;
    */
    return nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder     //CHANGE: Changed because initwithframe isn't always called
{                                           //(http://stackoverflow.com/questions/1600248/uiviews-initwithframe-not-working)
    // Initialization code
    self = [super initWithCoder:aDecoder];
    if (self) {
        offset = 0;
        prevPointSet = false;
       // self.connectionSets = [[NSMutableDictionary alloc] init];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // Any time you do custom drawing, you need to access
    // the current context.
    
    // Valid context are only available in drawRect!!!
    //
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect currentBounds = self.bounds;
    CGSize imageSize = [currentFrameImage size];
    float canvasX = self.bounds.size.width;
    float canvasY = self.bounds.size.height;
    float imageX = imageSize.width;
    float imageY = imageSize.height;
    
    // Mathy function to scale the image.  The image will always fit on the X axis but crop the Y.
    float scaledImageYValue = canvasY / (imageX / imageY);
    // This will use the scaled image Y value to figure out where the center of the image is.  This will draw
    // the image at its vertical middle.
    //float yCoordCenterAdjustment = (canvasX - scaledImageYValue)/2;
    
    
    CGContextDrawImage(context,
                       CGRectMake(0, 0, canvasX, scaledImageYValue),
                       [currentFrameImage CGImage]);
    
    
    //draw points
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
         */
    }

}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    if(currentFrameImage == 0){
        return;
    }
    
    UITouch *touch = [touches anyObject];
    
    [changeNotifier notify];
    
    
    if ([gestureController runGestureActions:touch: TOUCHES_DOWN]) {
        [self setNeedsDisplay];
    }
    
    NSLog(@"touchesBegan: added currentPoint: %f, %f", currentPoint.x, currentPoint.y);

}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    if(currentFrameImage == 0){
        return;
    }

    UITouch *touch = [touches anyObject];
    
    if ([gestureController runGestureActions:touch :TOUCHES_MOVED]) {
        [self setNeedsDisplay];
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(currentFrameImage == 0){
        return;
    }
    
    [changeNotifier notify];
    UITouch *touch = [touches anyObject];
    if ([gestureController runGestureActions:touch: TOUCHES_UP]) {
        [self setNeedsDisplay];
    }

    NSLog(@"touchesEnd:");
    
}


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


- (UIImage*) flipImage:(UIImage *) image{
    
    //CGSize cgsize = CGSizeMake(image.size.width, image.size.width);
    CGSize cgsize = CGSizeMake(1, 1);
    
    UIGraphicsBeginImageContext(cgsize);
 
    CGContextRef imageContext = UIGraphicsGetCurrentContext();

    
    CGContextScaleCTM(imageContext, 1, -1);
    CGContextDrawImage(imageContext, CGRectMake(0, 0, image.size.width, image.size.height), [image CGImage]);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



- (void)imageRotatedByDegrees:(UIImage*)im
{
    // calculate the size of the rotated view's containing box for our drawing space
    // UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,im.size.width, im.size.height)];
    //CGAffineTransform t = CGAffineTransformMakeRotation((50 * 3.1415926/180));
    // CATransform3D t = CATransform3DScale(CATransform3DMakeRotation(M_PI / 2.0f, 0, 0, 1),
    //      -1, 1, 1);
    //rotatedViewBox.transform = t;
    //CGSize rotatedSize = rotatedViewBox.frame.size;

    // Create the bitmap context
    //UIGraphicsBeginImageContext(rotatedSize);

    NSLog(@"Rotated");
    CGContextRef bitmap = UIGraphicsGetCurrentContext();

    // Move the origin to the middle of the image so we will rotate and scale around the center.
   // CGContextTranslateCTM(bitmap, im.size.width, im.size.height);


    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1, -1);
    CGContextDrawImage(bitmap, CGRectMake(-im.size.width / 2, -im.size.height / 2, im.size.width, im.size.height), [im CGImage]);
    UIGraphicsEndImageContext();

}


-(UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    //CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, 1, 0, newSize.height);
    //CGAffineTransform flipVertical = CGAffineTransformMakeScale(1, -1);
    //CGContextConcatCTM(context, flipVertical);
    //CGContextScaleCTM(context, 1, -1);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 * Takes true for protrait, false for landscape.
 */
- (void)viewChangedOrientation:(bool)isPortrait {
    [self setNeedsDisplay];
    if (isPortrait) {

    }
    else {

    }
    
}




@end
