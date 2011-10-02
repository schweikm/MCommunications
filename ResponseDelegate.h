//
//  ResponseDelegate.h
//  MComm
//
//  Created by Marc Schweikert on 3/6/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Response;

/*
 * This delegate is used to parse Response objects from XML
 */
@interface ResponseDelegate : NSObject {
@private 
	NSMutableString* soapResults;
	NSString* xmlElementName;
	Response* newResponse;
	NSMutableArray* responseList;
}

@property (nonatomic, retain) NSMutableArray* responseList;

@end
