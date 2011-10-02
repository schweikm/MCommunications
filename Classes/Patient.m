//
//  Patient.m
//  MComm
//
//  Created by Marc Schweikert on 1/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Patient.h"


@implementation Patient

@synthesize patientPK;
@synthesize regNumber;
@synthesize fullName;
@synthesize dateOfBirth;
@synthesize dateAdded;
@synthesize teamFK;
@synthesize floorFK;
@synthesize floorName;
@synthesize isDeleted;
@synthesize dateDeleted;
@synthesize numLowPriorityTasks;
@synthesize numHighPriorityTasks;

- (void)dealloc {
	[fullName release];
	[dateOfBirth release];
	[dateAdded release];
	[floorName release];
	[dateDeleted release];
	[super dealloc];
}

@end
