//
//  AlertsData.h
//  MComm
//
//  Created by Marc Schweikert on 4/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * This class holds the data related to Alerts.
 */
@interface AlertsData : NSObject {
@private
	Boolean   newAlertsExist;
	Boolean   hasHighPriority;
	NSInteger alertsCount;
	NSString* GUID;
}

@property (nonatomic, assign) Boolean newAlertsExist;
@property (nonatomic, assign) Boolean hasHighPriority;
@property (nonatomic, assign) NSInteger alertsCount;
@property (nonatomic, retain) NSString* GUID;

@end
