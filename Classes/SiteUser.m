//
//  SiteUser.m
//  MComm
//
//  Created by Marc Schweikert on 1/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SiteUser.h"


@implementation SiteUser

@synthesize siteUserPk;
@synthesize userName;
@synthesize fullname;
@synthesize userType;
@synthesize password;
@synthesize isOnDuty;

- (void)dealloc {
	[userName release];
	[fullname release];
	[password release];
	[super dealloc];
}

+ (NSString*)getUserTypeDescriptionForUserType:(NSInteger)userTypeIn {
	switch(userTypeIn) {
		case 0:
			return @"Invalid User";
			
		case 1:
			return @"Medical Doctor";
			
		case 2:
			return @"Physician Assistant";
			
		case 3:
			return @"Resident";
			
		case 4:
			return @"Nurse";
			
		default:
			return @"Unknown User Type!";
	}
}

@end
