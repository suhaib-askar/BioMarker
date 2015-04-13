//
//  InteractiveView.m
//  Interactive Textbook
//
//  Created by Pete Willemsen on 11/6/12.
//  Copyright (c) 2012 Pete Willemsen. All rights reserved.
//

#import "InteractiveView.h"

@implementation InteractiveView

@synthesize annotatedText = _annotatedText;
@synthesize bookImages = _bookImages;
@synthesize bookText = _bookText;

- (void)setup {
    annotatedText = [[UIWebView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    annotatedText.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    annotatedText.backgroundColor = [UIColor clearColor];
    annotatedText.opaque = FALSE;
    [self addSubview:annotatedText];
    
    // Image array
    bookImages = [[NSArray alloc] initWithObjects:
                  [UIImage imageNamed:@"SejourenFrance1"],
                  [UIImage imageNamed:@"SejourenFrance2"],
                  [UIImage imageNamed:@"SejourenFrance3"],
                  [UIImage imageNamed:@"SejourenFrance45"], nil];
    
    // Text array
    bookText = [[NSArray alloc] initWithObjects:
                @"<div><p><span style='font-size:12.0pt;font-family:Helvetica'>Robert est content. Il sourit. Son rêve se réalise: découvrir la France. L'avion vient d'atterrir. Robert descend le premier. Près de l'avion, l'hotesse de l'air surveille le débarquement des passagers - des touristes riches, des hommes d'affaires. Un autre avion vient de décoller: il s'envole dans le ciel. Des gens, sur la terrasse de l'aéroport, disent au revoir a leurs amis. Robert se dirige vers le car qui le conduira de l'aéroport jusqu'au centre de Paris : l'aventure commence.</span></p></div>",
                @"<div><p><span style='font-size:12.0pt;font-family:Helvetica'>Robert est mal.</span></p></div>",
                @"<div><p><span style='font-size:12.0pt;font-family:Helvetica'>Robert est tres mal.</span></p></div>",
                @"<div><p><span style='font-size:12.0pt;font-family:Helvetica'>Robert est fatique.</span></p></div>",
                nil];
    
    currentIdx = 0;
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    [self setup];
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    // Valid context are only available in drawRect!!!
    
    CGRect currentBounds = self.bounds;
    
    // Query Image Size and aspect ratio to fit on screen
    UIImage* currImage = [bookImages objectAtIndex:currentIdx];
    
    float aspectRatio = currImage.size.height / (float)currImage.size.width;
    
    float imageWidth = 1;
    float imageHeight = currentBounds.size.width * aspectRatio;
    
    [currImage drawInRect:CGRectMake(0,
                                     CGRectGetMidY(currentBounds) - imageHeight/2,
                                     currentBounds.size.width, imageHeight) ];
    
    [annotatedText setFrame:CGRectMake(currentBounds.size.width * 0.10,
                                       CGRectGetMidY(currentBounds) + imageHeight/2 + 5,
                                       0.80 * currentBounds.size.width,
                                       imageHeight / 2.0)];
    [annotatedText loadHTMLString:[bookText objectAtIndex:currentIdx] baseURL:nil];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSUInteger touchCount = [touches count];
    NSUInteger tapCount = [[touches anyObject] tapCount];
    
    UITouch *touch = [touches anyObject];
    
    currentIdx = (currentIdx + 1) % 4;
    
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchedMoved");
}

@end
