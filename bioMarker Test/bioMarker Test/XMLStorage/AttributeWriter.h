//
//  AttributeWriter.h
//  bioMarker Test
//
//  Created by Bradley Cutshall on 2/24/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Extendable class for writing attributes
 **/
@protocol AttributeWriter <NSObject>

-(NSString*)writeAttribute;

@end
