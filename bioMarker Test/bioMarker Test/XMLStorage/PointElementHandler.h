//
//  PointElementHandler.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 3/19/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElementHandler.h"
#import "ParserContext.h"

@interface PointElementHandler : NSObject<ElementHandler> {
    ParserContext* parserContext;
}

-(id) initWithParserContext:(ParserContext*) context;

@end
