//
//  XMLParserDelegate.h
//  bioMarker Test
//
//  Created by Bradley Cutshall on 3/5/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParserContext.h"

@interface XMLParserDelegate : NSObject <NSXMLParserDelegate> {
    NSMutableArray * storageCache;
    NSMutableDictionary* elementDictionary;
    ParserContext* parserContext;
    NSMutableDictionary* elementHandlerMap;
    
}

-(id)initWithParserContext:(ParserContext*)builder;



@end
