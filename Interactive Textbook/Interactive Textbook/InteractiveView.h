//
//  InteractiveView.h
//  Interactive Textbook
//
//  Created by Pete Willemsen on 11/6/12.
//  Copyright (c) 2012 Pete Willemsen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIWebView.h>

@interface InteractiveView : UIView {
    int currentIdx;
    
    NSArray *bookImages;
    NSArray *bookText;
    
    UIWebView *annotatedText;
}

@property(nonatomic,strong) UIWebView *annotatedText;
@property(nonatomic,strong) NSArray* bookImages;
@property(nonatomic,strong) NSArray* bookText;

@end
