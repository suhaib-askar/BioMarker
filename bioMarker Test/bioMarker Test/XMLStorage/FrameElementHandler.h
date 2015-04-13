//
//  FrameElementHandler.h
//  bioMarker Test
//
//  Created by Dylan T Mcguire on 3/19/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParserContext.h"
#import "ElementHandler.h"

@interface FrameElementHandler : NSObject<ElementHandler> {
    ParserContext* parserContext;
}

-(id) initWithParserContext:(ParserContext*) context;

@end
