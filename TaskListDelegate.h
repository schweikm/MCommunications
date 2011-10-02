//
//  TaskListDelegate.h
//  MComm
//
//  Created by Marc Schweikert on 3/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TaskListData;

/*
 * This delegate is used to get the various task lists.  The web service returns
 * the Task, the associated Patient, and the SiteUser who the task is assigned 
 * to.  It returns an array of TaskListData objects.
 */
@interface TaskListDelegate : NSObject {
@private 
	NSMutableString* soapResults;
	NSString* xmlElementName;
	TaskListData* data;
	NSMutableArray* taskList;
}

@property (nonatomic, retain) NSMutableArray* taskList;

@end
