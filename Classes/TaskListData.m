//
//  TaskListData.m
//  MComm
//
//  Created by Marc Schweikert on 4/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TaskListData.h"
#import "Patient.h"
#import "SiteUser.h"
#import "Task.h"


@implementation TaskListData

@synthesize patient;
@synthesize assignedToUser;
@synthesize task;

- (id)init {
	if(self = [super init]) {
		assignedToUser = [[SiteUser alloc] init];
		patient = [[Patient alloc] init];
		task = [[Task alloc] init];
	}
	return self;
}

- (void)dealloc {
	[assignedToUser release];
	[patient release];
	[task release];

	[super dealloc];
}

@end
