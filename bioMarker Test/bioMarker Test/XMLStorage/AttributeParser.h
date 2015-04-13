//
//  AttributeParser.h
//  bioMarker Test
//
//  Created by Bradley Cutshall on 3/5/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AttributeParser <NSObject>

-(void)parseAttribute:(NSDictionary*)attributes;

@end
