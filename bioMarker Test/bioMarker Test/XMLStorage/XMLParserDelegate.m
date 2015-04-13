//
//  XMLParserDelegate.m
//  bioMarker Test
//
//  Created by Bradley Cutshall on 3/5/14.
//  Copyright (c) 2014 Pete Willemsen. All rights reserved.
//

#import "XMLParserDelegate.h"
#import "FrameElementHandler.h"
#import "LimbElementHandler.h"
#import "PointElementHandler.h"
#import "NoOpHandler.h"

@implementation XMLParserDelegate

-(id)initWithParserContext:(ParserContext *)framebuilder {
    parserContext = framebuilder;
    elementHandlerMap = [[NSMutableDictionary alloc] init];
    
    //add new element handlers to this map
    [elementHandlerMap setValue:[[FrameElementHandler alloc] initWithParserContext: parserContext] forKey:@"frame"];
    [elementHandlerMap setValue:[[LimbElementHandler alloc] initWithParserContext: parserContext] forKey:@"limb"];
    [elementHandlerMap setValue:[[PointElementHandler alloc] initWithParserContext: parserContext] forKey:@"point"];
    [elementHandlerMap setValue:[[NoOpHandler alloc] init] forKey:@"video"];
    
    return self;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    
    NSLog(@"Did start element");
    

    id<ElementHandler> elementHandler = [elementHandlerMap objectForKey:elementName];
    
    if (elementHandler != nil) {
        [elementHandler handleElementStart:attributeDict];
    }
    
    else {
        NSLog(@"Unhandled Element!");
    }
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    NSLog(@"Did end element");
    id<ElementHandler> elementHandler = [elementHandlerMap objectForKey:elementName];
    
    if (elementHandler != nil) {
        [elementHandler handleElementEnd];
    }
    
    else {
        NSLog(@"Unhandled Element!");
    }

}

/*
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSString *tagName = @"column";
    if([tagName isEqualToString:@"column"])
    {
        NSMutableString * tempstring = [[NSMutableString alloc] initWithString:@"Value: "];
        NSLog([tempstring stringByAppendingString:string]);
    }
}
*/
/*
- (void)parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName forElement:(NSString *)elementName type:(NSString *)type defaultValue:(NSString *)defaultValue
{
    NSString *name = @"name";
    if([name isEqualToString:attributeName]) {
        NSMutableString * tempstring = [[NSMutableString alloc] initWithString:@"Attribute: "];
        NSLog([tempstring stringByAppendingString:attributeName]);
    }

}

*/
@end