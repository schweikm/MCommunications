//
//  TaskListData.h
//  MComm
//
//  Created by Marc Schweikert on 4/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Patient;
@class SiteUser;
@class Task;

/*
 * This class holds the info returned from the web service calls for task lists.
 */
@interface TaskListData : NSObject {
@private
	Patient*  patient;
	SiteUser* assignedToUser;
	Task*     task;
}

@property (nonatomic, retain) Patient* patient;
@property (nonatomic, retain) SiteUser* assignedToUser;
@property (nonatomic, retain) Task* task;

@end
