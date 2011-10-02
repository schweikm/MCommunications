//
//  Response.m
//  MComm
//
//  Created by Marc Schweikert on 1/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Response.h"


@implementation Response

@synthesize responsePK;
@synthesize taskFK;
@synthesize actionFK;
@synthesize dateAdded;
@synthesize addedBy;
@synthesize assignmentUserFK;

- (void)dealloc {
	[dateAdded release];
	[super dealloc];
}

+ (NSString*)getResponseDescriptionByActionFK:(NSInteger)anActionFK {
	switch(anActionFK) {
		case 1:
			return @"Created";
			
		case 2:
			return @"Delegated";
			
		case 3:
			return @"Acknowledged";
			
		case 4:
			return @"Complete";
			
		default:
			return @"Unknown Action Type!";
	}
}

@end
