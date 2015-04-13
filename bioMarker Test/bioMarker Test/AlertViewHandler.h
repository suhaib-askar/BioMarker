//
//  AlertViewHandler.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 2/7/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol AlertViewHandler <NSObject>

-(void) handleAlertViewButtonClick:(UIAlertView *)alert: (NSInteger)buttonIndex;

@end
