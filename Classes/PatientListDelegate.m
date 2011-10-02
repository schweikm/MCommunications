//
//  PatientListDelegate.m
//  MComm
//
//  Created by Marc Schweikert on 2/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PatientListDelegate.h"
#import "Patient.h"


@implementation PatientListDelegate

@synthesize patientList;

- (id)init {
    if(self = [super init]) { 
		soapResults = [[NSMutableString alloc] init];
		patientList = [[NSMutableArray alloc] init];
    } 
    return self; 
}

- (void)dealloc {
	[soapResults release];
	[patientList release];
	[super dealloc];
}

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName 
		namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName
		attributes:(NSDictionary*)attributeDict {
	
	// store the current XML element
	xmlElementName = elementName;
	
	// make a new Patient if we start a new Patient in the XML
	if([elementName isEqualToString:@"patient"]) {
		newPatient = [[Patient alloc] init];
	}
}

- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string {
	[soapResults setString:@""];
	[soapResults appendString:string];

	if([xmlElementName isEqualToString:@"patientPK"]) {
		newPatient.patientPK = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"cpi"]) {
		newPatient.regNumber = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"name"]) {
		newPatient.fullName = [NSString stringWithString:soapResults];
	}
	
	else if([xmlElementName isEqualToString:@"dateOfBirth"]) {
		newPatient.dateOfBirth = [NSString stringWithString:soapResults];
	}
	
	else if([xmlElementName isEqualToString:@"dateAdded"]) {
		newPatient.dateAdded = [NSString stringWithString:soapResults];
	}
	
	else if([xmlElementName isEqualToString:@"teamFK"]) {
		newPatient.teamFK = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"floorFK"]) {
		newPatient.floorFK = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"floorName"]) {
		newPatient.floorName = [NSString stringWithString:soapResults];
	}
	
	else if([xmlElementName isEqualToString:@"deleted"]) {
		newPatient.isDeleted = [soapResults boolValue];
	}
	
	else if([xmlElementName isEqualToString:@"dateDeleted"]) {
		newPatient.dateAdded = [NSString stringWithString:soapResults];
	}
	
	else if([xmlElementName isEqualToString:@"lowPriorityTaskCount"]) {
		newPatient.numLowPriorityTasks = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"highPriotyTaskCount"]) {
		newPatient.numHighPriorityTasks = [soapResults integerValue];
	}
}

- (void)parser:(NSXMLParser*)parser didEndElement:(NSString*)elementName 
		namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName {
	// if we found the end tag for the patient, add it to the list
	if([elementName isEqualToString:@"patient"]) {
		[patientList addObject:newPatient];
		[newPatient release];
	}
}

@end
