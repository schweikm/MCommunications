//
//  WebServiceFunctions.h
//  MComm
//
//  Created by Marc Schweikert on 1/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Patient;
@class Response;
@class SiteUser;
@class Task;

/*
 * This class provides SOAP 1.2 web service functionality.  All requests are sent
 * synchronously, so they block the program while the request is being serviced.
 */
@interface WebService : NSObject {
@private 
	NSXMLParser* xmlParser;
	NSInteger theSiteUserPK;
	NSString* servicePath;
	NSString* serviceRoot;
}

- (Boolean) addTask:(Task*) task;
- (NSInteger) changePasswordFrom:(NSString*) oldPassword to:(NSString*) newPassword;
- (NSMutableArray*) getActiveCareTakersForPatientPK:(NSInteger) patientPK;
- (NSMutableArray*) getAlertsTaskList;
- (NSMutableArray*) getAllCareTakersForPatientPK:(NSInteger) patientPK;
- (NSMutableArray*) getMyTasks;
- (NSMutableArray*) getPatientList;
- (NSMutableArray*) getPatientTaskListForPatientPK:(NSInteger) patientPK;
- (SiteUser*) getSiteUserForSiteUserPK:(NSInteger) siteUserPK;
- (NSMutableArray*) getTaskResponsesForTaskPK:(NSInteger) taskPK;
- (NSInteger) loginWithUserName:(NSString*) userName password:(NSString*) password;
- (void) logout;
- (Boolean) respondToTaskWithResponse:(Response*) response;

// private helper functions
- (void) openConnectionWithSoapXML:(NSString*) soapXML andParseXMLWithDelegate:(id) delegate;

@end
