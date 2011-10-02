//
//  SiteUser.h
//  MComm
//
//  Created by Marc Schweikert on 1/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * This class holds information related to user who can login
 */
@interface SiteUser : NSObject {
@private 
	NSInteger siteUserPk;
	NSString* userName;
	NSString* fullname;
	NSInteger userType;
	NSString* password;
	Boolean isOnDuty;
}

@property (nonatomic, assign) NSInteger siteUserPk;
@property (nonatomic, retain) NSString* userName;
@property (nonatomic, retain) NSString* fullname;
@property (nonatomic, assign) NSInteger userType;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, assign) Boolean isOnDuty;

+ (NSString*)getUserTypeDescriptionForUserType:(NSInteger)userTypeIn;

@end
