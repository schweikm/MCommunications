//
//  WebServiceFunctions.m
//  MComm
//
//  Created by Marc Schweikert on 1/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "WebService.h"
#import "CachedData.h"
#import "PatientListDelegate.h"
#import "Response.h"
#import "ResponseDelegate.h"
#import "SingleResultDelegate.h"
#import "SiteUser.h"
#import "SiteUserDelegate.h"
#import "Task.h"
#import "TaskListDelegate.h"

#define ENABLE_LOGGING


@implementation WebService

- (id)init {
    if(self = [super init]) { 
		xmlParser = [NSXMLParser alloc];
		theSiteUserPK = [CachedData get_instance].currentUser.siteUserPk;
		servicePath = [CachedData get_instance].webServicePath;
		serviceRoot = [CachedData get_instance].webServiceRoot;
    } 
    return self; 
}

- (void)dealloc {
	[xmlParser release];
	[super dealloc];
}

// Adds a task 
- (Boolean)addTask:(Task*)task {
	NSString *soapXML = [NSString stringWithFormat:
						 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
						 "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
											"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
											"xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
							"<soap12:Body>\n"
								"<addTask xmlns=\"%@\">\n"
									"<newTask>\n"
										"<taskPK>%ld</taskPK>\n"
										"<patientFK>%ld</patientFK>\n"
										"<text>%@</text>\n"
										"<highPriority>%ld</highPriority>\n"
										"<assignedTo>%ld</assignedTo>\n"
										"<latestActionFK>%ld</latestActionFK>\n"
										"<latestResponseFK>%ld</latestResponseFK>\n"
									"</newTask>\n"
									"<siteUserPK>%ld</siteUserPK>\n"
								"</addTask>\n"
							"</soap12:Body>\n"
						 "</soap12:Envelope>", serviceRoot, 
											   task.taskPK, task.patientFK, task.messageText, task.isHighPriority, 
											   task.assignedTo, task.latestActionFK, task.latestResponseFK,
											   theSiteUserPK];
	
	SingleResultDelegate* addTaskDelegate = [[SingleResultDelegate alloc] init];
	addTaskDelegate.xmlSearchToken = @"addTaskResult";
	
	[self openConnectionWithSoapXML:soapXML andParseXMLWithDelegate:addTaskDelegate];
	Boolean result = [addTaskDelegate.xmlResult boolValue];
	
	[addTaskDelegate release];
	
	return result;
}

// Changes the current user's password.  We must verify that the old password
// is correct to ensure that the change is valid
- (NSInteger)changePasswordFrom:(NSString*)oldPassword to:(NSString*)newPassword {
	NSString *soapXML = [NSString stringWithFormat:
						 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
						 "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
											"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
											"xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
							"<soap12:Body>\n"
								"<changePassword xmlns=\"%@\">\n"
									"<siteUserPK>%ld</siteUserPK>\n"
									"<oldPassword>%@</oldPassword>\n"
									"<newPassword>%@</newPassword>\n"
								"</changePassword>\n"
							"</soap12:Body>\n"
						 "</soap12:Envelope>", serviceRoot, theSiteUserPK];
	
	SingleResultDelegate* changePasswordDelegate = [[SingleResultDelegate alloc] init];
	changePasswordDelegate.xmlSearchToken = @"changePasswordResult";
	
	[self openConnectionWithSoapXML:soapXML andParseXMLWithDelegate:changePasswordDelegate];
	NSInteger result = [changePasswordDelegate.xmlResult integerValue];
	
	[changePasswordDelegate release];
	
	return result;
}

// Gets all caretakers who are currently on duty
- (NSMutableArray*)getActiveCareTakersForPatientPK:(NSInteger)patientPK {
	NSString *soapXML = [NSString stringWithFormat:
						 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
						 "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
											"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
											"xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
							"<soap12:Body>\n"
								"<getActiveCaretakers xmlns=\"%@\">\n"
									"<patientPK>%ld</patientPK>\n"
									"<siteUserPK>%ld</siteUserPK>\n"
								"</getActiveCaretakers>\n"
							"</soap12:Body>\n"
						 "</soap12:Envelope>", serviceRoot, patientPK, theSiteUserPK];
	
	SiteUserDelegate* userDelegate = [[SiteUserDelegate alloc] init];
	[self openConnectionWithSoapXML:soapXML andParseXMLWithDelegate:userDelegate];
	NSMutableArray* siteUserList = [userDelegate.siteUserList retain];
	
	[userDelegate release];
	
	return siteUserList;
}

// Gets the alerts task list 
- (NSMutableArray*)getAlertsTaskList {
	NSString *soapXML = [NSString stringWithFormat:
						 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
						 "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
											"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
											"xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
							"<soap12:Body>\n"
								"<getAlertsTaskList xmlns=\"%@\">\n"
									"<siteUserPK>%ld</siteUserPK>\n"
								"</getAlertsTaskList>\n"
							"</soap12:Body>\n"
						 "</soap12:Envelope>", serviceRoot, theSiteUserPK];
	
	TaskListDelegate* taskListDelegate = [[TaskListDelegate alloc] init];
	[self openConnectionWithSoapXML:soapXML andParseXMLWithDelegate:taskListDelegate];
	NSMutableArray* taskList = [taskListDelegate.taskList retain];
	
	[taskListDelegate release];
	
	return taskList;
	
}

// Gets all caretakers for the patient regardless if they are on duty or not
- (NSMutableArray*)getAllCareTakersForPatientPK:(NSInteger)patientPK {
	NSString *soapXML = [NSString stringWithFormat:
						 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
						 "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
											"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
											"xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
							"<soap12:Body>\n"
								"<getCaretakers xmlns=\"%@\">\n"
									"<patientPK>%ld</patientPK>\n"
									"<siteUserPK>%ld</siteUserPK>\n"
								"</getCaretakers>\n"
							"</soap12:Body>\n"
						 "</soap12:Envelope>", serviceRoot, patientPK, theSiteUserPK];
	
	SiteUserDelegate* userDelegate = [[SiteUserDelegate alloc] init];
	[self openConnectionWithSoapXML:soapXML andParseXMLWithDelegate:userDelegate];
	NSMutableArray* siteUserList = [userDelegate.siteUserList retain];
	
	[userDelegate release];
	
	return siteUserList;
}

// Gets my tasks
- (NSMutableArray*)getMyTasks {
	NSString *soapXML = [NSString stringWithFormat:
						 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
						 "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
											"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
											"xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
							"<soap12:Body>\n"
								"<getMyTaskList xmlns=\"%@\">\n"
									"<siteUserPK>%ld</siteUserPK>\n"
								"</getMyTaskList>\n"
							"</soap12:Body>\n"
						 "</soap12:Envelope>", serviceRoot, theSiteUserPK];
	
	TaskListDelegate* taskListDelegate = [[TaskListDelegate alloc] init];
	[self openConnectionWithSoapXML:soapXML andParseXMLWithDelegate:taskListDelegate];
	NSMutableArray* taskList = [taskListDelegate.taskList retain];
	
	[taskListDelegate release];
	
	return taskList;
}

// Gets the patient list for the specified user
- (NSMutableArray*)getPatientList {
	NSString *soapXML = [NSString stringWithFormat:
						 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
						 "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
											"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
											"xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
							"<soap12:Body>\n"
								"<getPatientList xmlns=\"%@\">\n"
									"<siteUserPK>%ld</siteUserPK>\n"
								"</getPatientList>\n"
							"</soap12:Body>\n"
						 "</soap12:Envelope>", serviceRoot, theSiteUserPK];
	
	PatientListDelegate* patientDelegate = [[PatientListDelegate alloc] init];
	[self openConnectionWithSoapXML:soapXML andParseXMLWithDelegate:patientDelegate];
	NSMutableArray* patientList = [patientDelegate.patientList retain];
	
	[patientDelegate release];
	
	return patientList;
}

// Returns the task list for a given patient
- (NSMutableArray*)getPatientTaskListForPatientPK:(NSInteger)patientPK {
	NSString *soapXML = [NSString stringWithFormat:
						 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
						 "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
											"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
											"xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
							"<soap12:Body>\n"
								"<getPatientTaskList xmlns=\"%@\">\n"
									"<patientPK>%ld</patientPK>\n"
									"<siteUserPK>%ld</siteUserPK>\n"
								"</getPatientTaskList>\n"
							"</soap12:Body>\n"
						 "</soap12:Envelope>", serviceRoot, patientPK, theSiteUserPK];
	
	TaskListDelegate* taskListDelegate = [[TaskListDelegate alloc] init];
	[self openConnectionWithSoapXML:soapXML andParseXMLWithDelegate:taskListDelegate];
	NSMutableArray* taskList = [taskListDelegate.taskList retain];
	
	[taskListDelegate release];
	
	return taskList;
}

// Gets the entire SiteUser's information given their SiteUserPK
- (SiteUser*)getSiteUserForSiteUserPK:(NSInteger)siteUserPK {
	NSString *soapXML = [NSString stringWithFormat:
						 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
						"<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
												"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
												"xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
							"<soap12:Body>\n"
								"<getSiteUser xmlns=\"%@\">\n"
									"<siteUserPK>%ld</siteUserPK>\n"
								"</getSiteUser>\n"
							"</soap12:Body>\n"
						 "</soap12:Envelope>", serviceRoot, siteUserPK];
	
	SiteUserDelegate* userDelegate = [[SiteUserDelegate alloc] init];
	userDelegate.xmlSearchToken = @"getSiteUserResult";

	[self openConnectionWithSoapXML:soapXML andParseXMLWithDelegate:userDelegate];
	NSMutableArray* siteUserList = userDelegate.siteUserList;
	SiteUser* result = [[siteUserList objectAtIndex:0] retain];
	
	[userDelegate release];
	
	return result;
}

// Gets all responses for a task
- (NSMutableArray*)getTaskResponsesForTaskPK:(NSInteger)taskPK {
	NSString *soapXML = [NSString stringWithFormat:
						 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
						 "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
											"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
											"xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
							"<soap12:Body>\n"
								"<getTaskResponses xmlns=\"%@\">\n"
									"<taskPK>%ld</taskPK>\n"
									"<siteUserPK>%ld</siteUserPK>\n"
								"</getTaskResponses>\n"
							"</soap12:Body>\n"
						 "</soap12:Envelope>", serviceRoot, taskPK, theSiteUserPK];
	
	ResponseDelegate* responseDelegate = [[ResponseDelegate alloc] init];
	[self openConnectionWithSoapXML:soapXML andParseXMLWithDelegate:responseDelegate];
	NSMutableArray* responseList = [responseDelegate.responseList retain];
	
	[responseDelegate release];
	
	return responseList;
}

// Logs the user in by updating the database.  The response will hand back a
// SiteUserPK which will be used by every other function to identify yourself.
- (NSInteger)loginWithUserName:(NSString*)userName password:(NSString*)password {
	NSString *soapXML = [NSString stringWithFormat:
						 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
						 "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
											"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
											"xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
							"<soap12:Body>\n"
								"<login xmlns=\"%@\">\n"
									"<username>%@</username>\n"
									"<password>%@</password>\n"
								"</login>\n"
							"</soap12:Body>\n"
						 "</soap12:Envelope>", serviceRoot, userName, password];
	
	SingleResultDelegate* loginDelegate = [[SingleResultDelegate alloc] init];
	loginDelegate.xmlSearchToken = @"loginResult";
	
	[self openConnectionWithSoapXML:soapXML andParseXMLWithDelegate:loginDelegate];
	
	NSInteger result = [[loginDelegate xmlResult] integerValue];

	[loginDelegate release];
	
	return result;
}

// Logs the current user out by updating the database
- (void)logout {	
	NSString *soapXML = [NSString stringWithFormat:
						 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
						 "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
											"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
											"xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
							"<soap12:Body>\n"
								"<logout xmlns=\"%@\">\n"
									"<siteUserPK>%ld</siteUserPK>\n"
								"</logout>\n"
							"</soap12:Body>\n"
						 "</soap12:Envelope>", serviceRoot, theSiteUserPK];

	// there is no delegate or return value from logout
	[self openConnectionWithSoapXML:soapXML andParseXMLWithDelegate:nil];
}

// Adds a response to a task
- (Boolean)respondToTaskWithResponse:(Response*)response {
	// the web service has a specific format for DateTime
	NSString* date = [[response.dateAdded description] substringToIndex:10];
	NSString* time = [[response.dateAdded description] substringFromIndex:11];
	time = [time substringToIndex:8];

	NSMutableString* dateTime = [[NSMutableString alloc] initWithString:date];
	[dateTime appendFormat:@"T%@", time];
	
	NSString *soapXML = [NSString stringWithFormat:
						 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
						 "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
											"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
											"xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
							"<soap12:Body>\n"
								"<respondToTask xmlns=\"%@\">\n"
									"<newResponse>\n"
										"<responsePK>%ld</responsePK>\n"
										"<taskFK>%ld</taskFK>\n"
										"<actionFK>%ld</actionFK>\n"
										"<dateAdded>%@</dateAdded>\n"
										"<addedBy>%ld</addedBy>\n"
										"<assignmentUserFK>%ld</assignmentUserFK>\n"
									"</newResponse>\n"
									"<siteUserPK>%ld</siteUserPK>\n"
								"</respondToTask>\n"
							"</soap12:Body>\n"
						 "</soap12:Envelope>", serviceRoot,
											   response.responsePK, response.taskFK, response.actionFK,
											   dateTime, response.addedBy, response.assignmentUserFK,
											   theSiteUserPK];
	
	SingleResultDelegate* respondDelegate = [[SingleResultDelegate alloc] init];
	respondDelegate.xmlSearchToken = @"respondToTaskResult";
	
	[self openConnectionWithSoapXML:soapXML andParseXMLWithDelegate:respondDelegate];
	Boolean result = [respondDelegate.xmlResult boolValue];
	
	[respondDelegate release];
	
	return result;
}
									/***********************************
									 *     Private Helper Functions    *
									 ***********************************/

// Given a SOAP 1.2 request and an XML delegate to parse the request, sends the request synchronously to the web service.
- (void)openConnectionWithSoapXML:(NSString*)soapXML andParseXMLWithDelegate:(id)delegate { 
	
	// set up the request with the URL path
	NSURL *url = [NSURL URLWithString:servicePath];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	
	// add common SOAP 1.2 headers
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapXML length]];
	[theRequest addValue: @"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest setHTTPBody: [soapXML dataUsingEncoding:NSUTF8StringEncoding]];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	
	// log the XML for debugging
	#ifdef ENABLE_LOGGING
	
	NSLog(@"\n\n");
	NSLog(@"@", soapXML);
	NSLog(@"\n\n");
	
	#endif
	
	NSURLResponse* theResponse;
	NSError* connectionError;
	NSData* webData;

	// send the request synchronously - block the main thread
 	webData = [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&connectionError];
	NSString *theXML = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];

	// log the result for debugging
	#ifdef ENABLE_LOGGING	
	
	NSLog(@"DONE. Received Bytes: %d", [webData length]);
	NSLog(@"\n\n");
	NSLog(@"@", theXML);
	NSLog(@"\n\n");
	
	#endif
	
	// parse the XML response with the passed in delegate
	if(delegate) {
		xmlParser = [xmlParser initWithData: webData];
		[xmlParser setDelegate: delegate];
		[xmlParser setShouldResolveExternalEntities: YES];
		[xmlParser parse];
	}
	
	[theXML release];
}

@end
