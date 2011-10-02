//
//  Patient.h
//  MComm
//
//  Created by Marc Schweikert on 1/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * Contains all of the information related to a specific patient.
 */
@interface Patient : NSObject {
@private 
	NSInteger patientPK;
	NSInteger regNumber;
	NSString* fullName;
	NSDate* dateOfBirth;
	NSDate* dateAdded;
	NSInteger teamFK;
	NSInteger floorFK;
	NSString* floorName;
	Boolean isDeleted;
	NSDate* dateDeleted;
	NSInteger numLowPriorityTasks;
	NSInteger numHighPriorityTasks;
}

@property (nonatomic, assign) NSInteger patientPK;
@property (nonatomic, assign) NSInteger regNumber;
@property (nonatomic, retain) NSString* fullName;
@property (nonatomic, retain) NSDate* dateOfBirth;
@property (nonatomic, retain) NSDate* dateAdded;
@property (nonatomic, assign) NSInteger teamFK;
@property (nonatomic, assign) NSInteger floorFK;
@property (nonatomic, retain) NSString* floorName;
@property (nonatomic, assign) Boolean isDeleted;
@property (nonatomic, retain) NSDate* dateDeleted;
@property (nonatomic, assign) NSInteger numLowPriorityTasks;
@property (nonatomic, assign) NSInteger numHighPriorityTasks;

@end
