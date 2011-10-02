//
//  Task.h
//  MComm
//
//  Created by Marc Schweikert on 1/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * This class holds information related to tasks.
 */
@interface Task : NSObject {
@private 
	NSInteger taskPK;
	NSInteger patientFK;
	NSString* messageText;
	Boolean isHighPriority;
	NSInteger assignedTo;
	NSInteger latestActionFK;
	NSInteger latestResponseFK;
}

@property (nonatomic, assign) NSInteger taskPK;
@property (nonatomic, assign) NSInteger patientFK;
@property (nonatomic, retain) NSString* messageText;
@property (nonatomic, assign) Boolean isHighPriority;
@property (nonatomic, assign) NSInteger assignedTo;
@property (nonatomic, assign) NSInteger latestActionFK;
@property (nonatomic, assign) NSInteger latestResponseFK;

- (Boolean)isComplete;

@end
