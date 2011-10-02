//
//  TaskListDelegate.m
//  MComm
//
//  Created by Marc Schweikert on 3/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TaskListDelegate.h"
#import "Patient.h"
#import "SiteUser.h"
#import "Task.h"
#import "TaskListData.h"


@implementation TaskListDelegate

@synthesize taskList;

- (id)init {
    if(self = [super init]) { 
		soapResults = [[NSMutableString alloc] init];
		taskList = [[NSMutableArray alloc] init];
    } 
    return self; 
}

- (void)dealloc {
	[soapResults release];
	[taskList release];
	[super dealloc];
}

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName 
		namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName
		attributes:(NSDictionary*)attributeDict {
	
	// store the current XML element
	xmlElementName = elementName;
	
	if([elementName isEqualToString:@"Task"]) {
		data = [[TaskListData alloc] init];
	}
}

- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string {
	[soapResults setString:@""];
	[soapResults appendString:string];
	
				/*** TASK ***/
	
	if([xmlElementName isEqualToString:@"taskPK"]) {
		data.task.taskPK = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"patientFK"]) {
		data.task.patientFK = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"text"]) {
		data.task.messageText = [NSString stringWithString:soapResults];
	}
	
	else if([xmlElementName isEqualToString:@"highPriority"]) {
		data.task.isHighPriority = [soapResults boolValue];
	}
	
	else if([xmlElementName isEqualToString:@"assignedTo"]) {
		data.task.assignedTo = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"latestActionFK"]) {
		data.task.latestActionFK = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"latestResponseFK"]) {
		data.task.latestResponseFK = [soapResults integerValue];
	}
	
				/*** PATIENT ***/
	
	else if([xmlElementName isEqualToString:@"patientPK"]) {
		data.patient.patientPK = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"cpi"]) {
		data.patient.regNumber = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"name"]) {
		data.patient.fullName = [NSString stringWithString:soapResults];
	}
	
	else if([xmlElementName isEqualToString:@"dateOfBirth"]) {
		data.patient.dateOfBirth = [NSString stringWithString:soapResults];
	}
	
	else if([xmlElementName isEqualToString:@"dateAdded"]) {
		data.patient.dateAdded = [NSString stringWithString:soapResults];
	}
	
	else if([xmlElementName isEqualToString:@"teamFK"]) {
		data.patient.teamFK = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"floorFK"]) {
		data.patient.floorFK = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"floorName"]) {
		data.patient.floorName = [NSString stringWithString:soapResults];
	}
	
	else if([xmlElementName isEqualToString:@"deleted"]) {
		data.patient.isDeleted = [soapResults boolValue];
	}
	
	else if([xmlElementName isEqualToString:@"dateDeleted"]) {
		data.patient.dateAdded = [NSString stringWithString:soapResults];
	}
	
				/*** SITEUSER ***/	
	
	else if([xmlElementName isEqualToString:@"userPK"]) {
		data.assignedToUser.siteUserPk = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"username"]) {
		data.assignedToUser.userName = [NSString stringWithString:soapResults];
	}
	
	else if([xmlElementName isEqualToString:@"fullname"]) {
		data.assignedToUser.fullname = [NSString stringWithString:soapResults];		
	}
	
	else if([xmlElementName isEqualToString:@"userType"]) {
		data.assignedToUser.userType = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"password"]) {
		data.assignedToUser.password = [NSString stringWithString:soapResults];
	}
	
	else if([xmlElementName isEqualToString:@"onDuty"]) {
		data.assignedToUser.isOnDuty = [soapResults boolValue];
	}
}

- (void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName 
		namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName {
	if([elementName isEqualToString:@"Task"]) {
		[taskList addObject:data];
		[data release];
	}
}

@end
