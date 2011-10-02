//
//  SingleResultDelegate.m
//  MComm
//
//  Created by Marc Schweikert on 2/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SingleResultDelegate.h"


@implementation SingleResultDelegate

@synthesize xmlSearchToken;
@synthesize xmlResult;

- (id)init {
    if(self = [super init]) {
		soapResults = [[NSMutableString alloc] init];
    } 
    return self; 
}

- (void)dealloc {
	[soapResults release];
	[xmlResult release];
	[super dealloc];
}

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName 
		namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName
		attributes:(NSDictionary*)attributeDict {
	
	// store the current XML element
	xmlElementName = elementName;
}

- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string {
	if([xmlElementName isEqualToString: xmlSearchToken]) {
		[soapResults appendString: string];
		xmlResult = [[NSString alloc] initWithString:soapResults];
	}
}

@end
