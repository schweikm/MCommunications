//
//  CachedInformation.h
//  MComm
//
//  Created by Marc Schweikert on 3/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SiteUser;

/*
 * Singleton class that holds the information related to the logged-in user
 * as well as constants
 */
@interface CachedData : NSObject {
@private 
	SiteUser* currentUser;
	NSString* webServicePath;
	NSString* webServiceRoot;
}

@property (nonatomic, retain) SiteUser* currentUser;
@property (nonatomic, retain) NSString* webServicePath;
@property (nonatomic, retain) NSString* webServiceRoot;

+ (CachedData*)get_instance;

@end
