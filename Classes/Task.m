//
//  Task.m
//  MComm
//
//  Created by Marc Schweikert on 1/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Task.h"


@implementation Task

@synthesize taskPK;
@synthesize patientFK;
@synthesize messageText;
@synthesize isHighPriority;
@synthesize assignedTo;
@synthesize latestActionFK;
@synthesize latestResponseFK;

- (void)dealloc {
	[messageText release];
	[super dealloc];
}

- (Boolean)isComplete {
	return (latestActionFK == 4);
}

@end
