//
//  PatientListDelegate.h
//  MComm
//
//  Created by Marc Schweikert on 2/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Patient;

/*
 * This delegate is used to parse Patient objects from XML
 */
@interface PatientListDelegate : NSObject {
@private 
	NSMutableString* soapResults;
	NSString* xmlElementName;
	Patient* newPatient;
	NSMutableArray* patientList;
}

@property (nonatomic, retain) NSMutableArray* patientList;

@end
