//
//  AlertsTimer.m
//  MComm
//
//  Created by Marc Schweikert on 4/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AlertsTimer.h"
#import "AlertsData.h"
#import "AlertsViewController.h"
#import "AsynchronousWebService.h"
#import "CachedData.h"
#import "SiteUser.h"

// refresh rate to check for new alerts
const NSInteger update_interval_c = 10;


@implementation AlertsTimer

- (id)initWithUITabBarItem:(UITabBarItem*)item navController:(UINavigationController*)navController siteUserPK:(NSInteger)pk {
	if(self = [super init]) {
		alertsItem = item;
		alertsNavController = navController;
		siteUserPK = pk;
	
		// Get the URL to the sound file to play
		lowSoundFileURLRef = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR ("low"), CFSTR ("wav"), NULL);
		highSoundFileURLRef = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR ("high"), CFSTR ("wav"), NULL);
	
		// Create a system sound object representing the sound file
		AudioServicesCreateSystemSoundID(lowSoundFileURLRef, &lowSound);
		AudioServicesCreateSystemSoundID(highSoundFileURLRef, &highSound);
	}
	return self;
}

- (void)start {
	// set up the web service
	NSString* path = [[NSString alloc] initWithString:[CachedData get_instance].webServicePath];
	NSString* root = [[NSString alloc] initWithString:[CachedData get_instance].webServiceRoot];
	
	asyncWebService = [[AsynchronousWebService alloc] init];
	asyncWebService.servicePath = path;
	asyncWebService.serviceRoot = root;
	asyncWebService.siteUserPK = [CachedData get_instance].currentUser.siteUserPk;
	
	[path release];
	[root release];

	NSRunLoop* myRunLoop = [NSRunLoop currentRunLoop];
	
	// fire an event with a delay of 1 second, the every update_interval_c seconds
	NSDate* futureDate = [NSDate dateWithTimeIntervalSinceNow:1.0];
	alertsTimer = [[NSTimer alloc] initWithFireDate:futureDate
												interval:update_interval_c
												  target:self
												selector:@selector(checkAlerts)
												userInfo:nil
												 repeats:YES];

	// add the timer to the default run loop
	[myRunLoop addTimer:alertsTimer forMode:NSDefaultRunLoopMode];
}

- (void)stop {
	[alertsTimer invalidate];
	[asyncWebService release];
}

- (void)checkAlerts {
	[asyncWebService checkMyAlertsWithTarget:self selector:@selector(processAlerts:)];
}

- (void)processAlerts:(AlertsData*)data {
	// change the badge value every time (won't change if number is the same)
	if(data.alertsCount) {
		alertsItem.badgeValue = [NSString stringWithFormat:@"%ld", data.alertsCount];
	}
	else {
		alertsItem.badgeValue = nil;
	}
	
	static Boolean first = YES;
	if((first && data.alertsCount) || data.newAlertsExist) {
		if(data.hasHighPriority) {
			AudioServicesPlayAlertSound(highSound);
		}
		else {
			AudioServicesPlaySystemSound(lowSound);
		}
		
		// refresh the alerts table view
		NSArray* viewControllers = alertsNavController.viewControllers;
		AlertsViewController* viewController = (AlertsViewController*)[viewControllers objectAtIndex:0];
		[viewController refresh];
		
		[asyncWebService acknowledgeAlertReceipt:data.GUID];
		first = NO;
	}
}

@end
