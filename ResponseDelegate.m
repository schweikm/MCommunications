//
//  ResponseDelegate.m
//  MComm
//
//  Created by Marc Schweikert on 3/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ResponseDelegate.h"
#import "Response.h"


@implementation ResponseDelegate

@synthesize responseList;

- (id)init {
    if(self = [super init]) {
		soapResults = [[NSMutableString alloc] init];
		responseList = [[NSMutableArray alloc] init];
    } 
    return self; 
}

- (void)dealloc {
	[soapResults release];
	[responseList release];
	[super dealloc];
}

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName 
		namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName
		attributes:(NSDictionary*)attributeDict {
	
	// store the current XML element
	xmlElementName = elementName;
	
	if([elementName isEqualToString:@"Response"]) {
		newResponse = [[Response alloc] init];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	[soapResults setString:@""];
	[soapResults appendString:string];
	
	if([xmlElementName isEqualToString:@"responsePK"]) {
		newResponse.responsePK = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"taskFK"]) {
		newResponse.taskFK = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"actionFK"]) {
		newResponse.actionFK = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"dateAdded"]) {
		newResponse.dateAdded = [NSString stringWithString:soapResults];
	}
	
	else if([xmlElementName isEqualToString:@"addedBy"]) {
		newResponse.addedBy = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"assignmentUserFK"]) {
		newResponse.assignmentUserFK = [soapResults integerValue];
	}
}

- (void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName 
		namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName {
	if([elementName isEqualToString:@"Response"]) {
		[responseList addObject:newResponse];
		[newResponse release];
	}
}

@end
