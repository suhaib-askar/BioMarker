//
//  sivelabDrawingView.m
//  simpleDraw
//
//  Created by Pete Willemsen on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "sivelabDrawingView.h"
#import "MATCGlossyButton.h"

@implementation sivelabDrawingView

@synthesize touchStatus, methodStatus, tapStatus, currentPointStatus;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
    
    CGContextSetLineWidth(context, 3.0f);
    
    // quick way to change color
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    
    // draw a line starting a mid Y value
    CGContextMoveToPoint(context, 0.0f, CGRectGetMidY(currentBounds));
    CGContextAddLineToPoint(context, CGRectGetMaxX(currentBounds), CGRectGetMidY(currentBounds));
    
    // Now, need to actually render the path
    CGContextDrawPath(context, kCGPathStroke);

    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    
    int count = [drawnPoints count];
    NSLog(@"drawnPointCount = %d", count);
    CGPoint point = [[drawnPoints objectAtIndex:0] CGPointValue];
    CGContextMoveToPoint(context, point.x, point.y);
    for(int i = 1; i < count; i++) {
        point = [[drawnPoints objectAtIndex:i] CGPointValue];
        CGContextAddLineToPoint(context, point.x, point.y);
    }
    CGContextDrawPath(context, kCGPathStroke);

    // Image stuff
    NSArray* imagesArray = [NSArray arrayWithObjects:
                            [UIImage imageNamed:@"im00"], 
                            [UIImage imageNamed:@"im01"], 
                            [UIImage imageNamed:@"im02"], 
                            [UIImage imageNamed:@"im03"], 
                            [UIImage imageNamed:@"im04"], 
                            [UIImage imageNamed:@"im05"], 
                             nil];
    
    CGSize sz = [[imagesArray objectAtIndex:0] size];
    //    UIGraphicsBeginImageContextWithOptions(CGSizeMake(sz.width*1.5, sz.height), NO, 0);
    CGContextDrawImage(context, CGRectMake(10.5, CGRectGetMidY(currentBounds) + 10.5, sz.width,sz.height), [[imagesArray objectAtIndex:0] CGImage]);
    CGContextDrawImage(context, CGRectMake(10.5 + sz.width + 5.5, CGRectGetMidY(currentBounds) + 10.5, sz.width,sz.height), [[imagesArray objectAtIndex:1] CGImage]);
    
    CGContextDrawImage(context, CGRectMake(10.5, CGRectGetMidY(currentBounds) + 10.5 + sz.height + 5.5, sz.width,sz.height), [[imagesArray objectAtIndex:2] CGImage]);
    CGContextDrawImage(context, CGRectMake(10.5 + sz.width + 5.5, CGRectGetMidY(currentBounds) + 10.5 + sz.height + 5.5, sz.width,sz.height), [[imagesArray objectAtIndex:3] CGImage]);
    
    CGContextDrawImage(context, CGRectMake(10.5, CGRectGetMidY(currentBounds) + 10.5 + 2.0f * (sz.height + 5.5), sz.width,sz.height), [[imagesArray objectAtIndex:4] CGImage]);
    CGContextDrawImage(context, CGRectMake(10.5 + sz.width + 5.5, CGRectGetMidY(currentBounds) + 10.5 + 2.0f * (sz.height + 5.5), sz.width,sz.height), [[imagesArray objectAtIndex:5] CGImage]);

        // UIGraphicsEndImageContext();
    

    int perm[6];
    for (int i=0; i<6; i++)
    {
        perm[i] = i;
    }
    for (int i=0; i<6; i++)
    {
        int rval = arc4random() % 6;
        int tmp = perm[i];
        perm[i] = perm[rval];
        perm[rval] = tmp;
    }

    CGContextDrawImage(context, CGRectMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds) + 10.5, sz.width, sz.height), [[imagesArray objectAtIndex:perm[0]] CGImage]);
    CGContextDrawImage(context, CGRectMake(CGRectGetMidX(currentBounds), CGRectGetMidY(currentBounds) + 10.5 + 1.5 + sz.width, sz.width, sz.height), [[imagesArray objectAtIndex:perm[1]] CGImage]);
    CGContextDrawImage(context, CGRectMake(CGRectGetMidX(currentBounds) + 1.5 + sz.width, CGRectGetMidY(currentBounds) + 10.5, sz.width, sz.height), [[imagesArray objectAtIndex:perm[2]] CGImage]);
    CGContextDrawImage(context, CGRectMake(CGRectGetMidX(currentBounds) + 1.5 + sz.width, CGRectGetMidY(currentBounds) + 10.5 + 1.5 + sz.width, sz.width, sz.height), [[imagesArray objectAtIndex:perm[3]] CGImage]);
    
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    glossyBlueButton.cornerRadius = 10.0f;
    glossyBlueButton.buttonColor = [UIColor colorWithRed:0.0f green:0.0f blue:(150.0f / 255.0f) alpha:1.0f];

    
    NSUInteger touchCount = [touches count];
    NSUInteger tapCount = [[touches anyObject] tapCount];
    
    UITouch *touch = [touches anyObject];
    currentPoint = [touch locationInView:self];
    
    // record touch points to use as input to our line smoothing algorithm
    drawnPoints = [NSMutableArray arrayWithObject:[NSValue valueWithCGPoint:currentPoint]];
    
    previousPoint = currentPoint;
    
    methodStatus.text = @"touchesBegan";
    touchStatus.text = [NSString stringWithFormat:@"%d touches", touchCount];
    tapStatus.text = [NSString stringWithFormat:@"%d taps", tapCount];
    currentPointStatus.text = [NSString stringWithFormat:@"%@", NSStringFromCGPoint(currentPoint)];
    
    [self setNeedsDisplay];
} 

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
    NSUInteger touchCount = [touches count];
    NSUInteger tapCount = [[touches anyObject] tapCount];
    
    UITouch *touch = [touches anyObject];
    currentPoint = [touch locationInView:self];
    
    [drawnPoints addObject:[NSValue valueWithCGPoint:currentPoint]];
    int count = [drawnPoints count];
    NSLog(@"drawnPointCount = %d", count);
    
    previousPoint = currentPoint;
    
    methodStatus.text = @"touchesMoved";
    touchStatus.text = [NSString stringWithFormat:@"%d touches", touchCount];
    tapStatus.text = [NSString stringWithFormat:@"%d taps", tapCount];
    currentPointStatus.text = [NSString stringWithFormat:@"%@", NSStringFromCGPoint(currentPoint)];
    
    [self setNeedsDisplay];
}

- (void) touchesEnd:(NSSet *)touches withEvent:(UIEvent *)event 
{
    NSUInteger touchCount = [touches count];
    NSUInteger tapCount = [[touches anyObject] tapCount];
    
    methodStatus.text = @"touchesEnd";
    touchStatus.text = [NSString stringWithFormat:@"%d touches", touchCount];
    
    tapStatus.text = [NSString stringWithFormat:@"%d taps", tapCount];
    
    // imageView_.image = [self drawPathWithPoints:generalizedPoints image:cleanImage];
    // [drawnPoints release];
} 

@end
