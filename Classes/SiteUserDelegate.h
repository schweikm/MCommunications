//
//  SiteUserDelegate.h
//  MComm
//
//  Created by Marc Schweikert on 2/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SiteUser;

/*
 * This delegate is used to parse SiteUser objects from XML.  You also use this
 * delegate to get a single SiteUser - it is in the first index of the array.
 */
@interface SiteUserDelegate : NSObject {
@private 
	NSMutableString* soapResults;
	NSString* xmlElementName;
	NSMutableArray* siteUserList;
	SiteUser* newUser;
	NSString* xmlSearchToken;
}

@property (nonatomic, retain) NSString* xmlSearchToken;
@property (nonatomic, retain) NSMutableArray* siteUserList;

@end
