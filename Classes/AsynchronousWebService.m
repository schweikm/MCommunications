//
//  AsynchronousWebService.m
//  MComm
//
//  Created by Marc Schweikert on 4/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AsynchronousWebService.h"
#import "AlertsData.h"
#import "SiteUser.h"

#define ENABLE_LOGGING
//#define SYNCHRONOUS
#define ASYNCHRONOUS


@implementation AsynchronousWebService

@synthesize siteUserPK;
@synthesize servicePath;
@synthesize serviceRoot;

- (id)init {
    if(self = [super init]) { 
		xmlParser = [NSXMLParser alloc];
		webData = [[NSMutableData alloc] init];
		soapResults = [[NSMutableString alloc] init];
    } 
    return self; 
}

- (void)dealloc {
	#ifdef ASYNCHRONOUS

	[webData release];

	#endif
	
	[xmlParser release];
	[soapResults release];
	[servicePath release];
	[serviceRoot release];
	[super dealloc];
}

- (void)checkMyAlertsWithTarget:(id)in_target selector:(SEL)in_method {
	// store these for use later
	target = in_target;
	method = in_method;

	NSString *soapXML = [NSString stringWithFormat:
						 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
						 "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
											"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
											"xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
							"<soap12:Body>\n"
								"<checkMyAlerts xmlns=\"%@\">\n"
									"<siteUserPK>%ld</siteUserPK>\n"
								"</checkMyAlerts>\n"
							"</soap12:Body>\n"
						 "</soap12:Envelope>", serviceRoot, siteUserPK];

	finishMethod = @selector(finishCheckMyAlerts);
	[self openConnectionWithSoapXML:soapXML];
}

- (void)acknowledgeAlertReceipt:(NSString*)GUID {
	NSString *soapXML = [NSString stringWithFormat:
						 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
						 "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
											"xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" "
											"xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n"
							"<soap12:Body>\n"
								"<acknowledgeAlertReceipt xmlns=\"%@\">\n"
									"<ackKey>%@</ackKey>\n"
									"<siteUserPK>%ld</siteUserPK>\n"
								"</acknowledgeAlertReceipt>\n"
							"</soap12:Body>\n"
						 "</soap12:Envelope>", serviceRoot, GUID, siteUserPK];
	
	finishMethod = @selector(finishNothing);
	[self openConnectionWithSoapXML:soapXML];
}


					/***********************************
					 *     Private Helper Functions    *
					 ***********************************/

// Given a SOAP 1.2 request and an XML delegate to parse the request, sends the request asynchronously to the web service.
- (void)openConnectionWithSoapXML:(NSString*)soapXML {
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
	
	#ifdef ASYNCHRONOUS
	
	// asynchrous - don't block main thread
 	NSURLConnection* connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
	[connection start];

	#endif
	
	#ifdef SYNCHRONOUS
	
	// synchronous - block main thread
	NSURLResponse* theResponse;
	NSError* connectionError;
	
	// send the request synchronously - block the main thread
 	webData = (NSMutableData*)[NSURLConnection sendSynchronousRequest:theRequest returningResponse:&theResponse error:&connectionError];
	[self fakeIt];
	
	#endif
}

- (void)finishCheckMyAlerts {
	alertsData = [[AlertsData alloc] init];
	
	xmlParser = [xmlParser initWithData: webData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
	// call back to the app delegate with the alerts data
	[target performSelector:method withObject:(id)alertsData];
	
	[alertsData release];
}

- (void)finishNothing { }

#pragma mark NSURLConnection delegate methods

#ifdef SYNCHRONOUS

- (void)fakeIt {
	
#endif
	
#ifdef ASYNCHRONOUS
	
- (void)fakeIt { }

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

#endif
	
	theXML = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
	
	// log the result for debugging
	#ifdef ENABLE_LOGGING

	NSLog(@"DONE. Received Bytes: %d", [webData length]);
	NSLog(@"\n\n");
	NSLog(@"@", theXML);
	NSLog(@"\n\n");
	
	#endif
	
	// perform the post data function
	[self performSelector:finishMethod];
	
	[webData setData:nil];
//	[theXML release];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[webData appendData:data];
}

#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser*)parser didStartElement:(NSString*)elementName 
        namespaceURI:(NSString*)namespaceURI qualifiedName:(NSString*)qName
	    attributes:(NSDictionary*)attributeDict {

	// store the current XML element
	xmlElementName = elementName;
}

- (void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string {
	[soapResults setString:@""];
	[soapResults appendString:string];
	
	if([xmlElementName isEqualToString:@"newAlertsExist"]) {
		alertsData.newAlertsExist = [soapResults boolValue];
	}
	
	else if([xmlElementName isEqualToString:@"containsHighPriority"]) {
		alertsData.hasHighPriority = [soapResults boolValue];
	}
	
	else if([xmlElementName isEqualToString:@"totalAlertCount"]) {
		alertsData.alertsCount = [soapResults integerValue];
	}
	
	else if([xmlElementName isEqualToString:@"ackKey"]) {
		alertsData.GUID = [NSString stringWithString:soapResults];
	}
}

@end
