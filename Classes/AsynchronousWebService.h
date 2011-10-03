//
//  AsynchronousWebService.h
//  MComm
//
//  Created by Marc Schweikert on 4/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AlertsData;

/*
 * This web service is used to make asynchronous requests to the web service.
 */
@interface AsynchronousWebService : NSObject<NSXMLParserDelegate> {
@private 
	NSXMLParser* xmlParser;
	NSMutableData* webData;
	NSString *theXML;
	NSMutableString* soapResults;
	NSString* xmlElementName;
	
	id target;
	SEL method;
	
	AlertsData* alertsData;
	SEL finishMethod;
	
	NSString* serviceRoot;
	NSString* servicePath;
	NSInteger siteUserPK;
}

@property (nonatomic, assign) NSInteger siteUserPK;
@property (nonatomic, retain) NSString* servicePath;
@property (nonatomic, retain) NSString* serviceRoot;

- (void)checkMyAlertsWithTarget:(id)Atarget selector:(SEL)sel;
- (void)acknowledgeAlertReceipt:(NSString*)GUID;

// private helper functions
- (void)openConnectionWithSoapXML:(NSString*)soapXML;
- (void)finishCheckMyAlerts;
- (void)finishNothing;

// this is a hack because I can't get async to work
- (void)fakeIt;

@end
