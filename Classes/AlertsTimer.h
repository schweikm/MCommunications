//
//  AlertsTimer.h
//  MComm
//
//  Created by Marc Schweikert on 4/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class AlertsData;
@class AsynchronousWebService;

/*
 * This class is responsible for checking for alerts with a timer.
 */
@interface AlertsTimer : NSObject {
@private
	UITabBarItem* alertsItem;
	UINavigationController* alertsNavController;
	NSInteger siteUserPK;
	
	AsynchronousWebService* asyncWebService;
	NSTimer* alertsTimer;
	
	// sounds
	CFURLRef lowSoundFileURLRef;
	CFURLRef highSoundFileURLRef;
	SystemSoundID lowSound;
	SystemSoundID highSound;
}

- (id)initWithUITabBarItem:(UITabBarItem*)item navController:(UINavigationController*)navController siteUserPK:(NSInteger)pk;
- (void)start;
- (void)stop;
- (void)checkAlerts;
- (void)processAlerts:(AlertsData*)data;

@end
