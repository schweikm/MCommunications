//
//  SingleResultDelegate.h
//  MComm
//
//  Created by Marc Schweikert on 2/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * This delegate is used when there is a single value returned.  It is returned
 * as a string, so it is the client's job to parse it further if needed.
 *
 * The client must define xmlSearchToken (the xml open tag that defines the 
 * result).  xmlResult is the string that holds the value.
 */
@interface SingleResultDelegate : NSObject {
@private 
	NSMutableString* soapResults;
	NSString* xmlElementName;
	NSString* xmlSearchToken;
	NSString* xmlResult;
}

@property (nonatomic, retain) NSString* xmlSearchToken;
@property (nonatomic, retain) NSString* xmlResult;

@end
