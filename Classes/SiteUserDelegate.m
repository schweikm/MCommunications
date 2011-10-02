//
//  SiteUserDelegate.m
//  MComm
//
//  Created by Marc Schweikert on 2/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SiteUserDelegate.h"
#import "SiteUser.h"


@implementation SiteUserDelegate

@synthesize siteUserList;
@synthesize xmlSearchToken;

- (id)init {
    if(self = [super init]) { 
		soapResults = [[NSMutableString alloc] init];
		siteUserList = [[NSMutableArray alloc] init];
		xmlSearchToken = @"SiteUser";
    } 
    return self; 
}

- (void)dealloc {
	[soapResults release];
	[siteUserList release];
	[super dealloc];
}

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName 
		namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName
		attributes:(NSDictionary*)attributeDict {
	
	// store the current XML element
	xmlElementName = elementName;
	
	if([elementName isEqualToString:xmlSearchToken]) {
		newUser = [[SiteUser alloc] init];
	}
}

- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string {
	[soapResults setString:@""];
	[soapResults appendString: string];
	
	if([xmlElementName isEqualToString:@"userPK"]) {
		newUser.siteUserPk = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"username"]) {
		newUser.userName = [NSString stringWithString:soapResults];
	}
	
	else if([xmlElementName isEqualToString:@"fullname"]) {
		newUser.fullname = [NSString stringWithString:soapResults];		
	}
	
	else if([xmlElementName isEqualToString:@"userType"]) {
		newUser.userType = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"password"]) {
		newUser.password = [NSString stringWithString:soapResults];
	}
	
	else if([xmlElementName isEqualToString:@"onDuty"]) {
		newUser.isOnDuty = [soapResults boolValue];
	}
}

- (void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName 
		namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName {
	if([elementName isEqualToString:[self xmlSearchToken]]) {
		[siteUserList addObject:newUser];
		[newUser release];
	}
}

@end
