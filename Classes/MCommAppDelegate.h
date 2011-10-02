//
//  MCommAppDelegate.h
//  MComm
//
//  Created by Marc Schweikert on 1/29/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlertsTimer;
@class WebService;
@class SiteUser;

/*
 * Manages logging in and out as well as managing the alerts timer.
 */
@interface MCommAppDelegate : NSObject <UIApplicationDelegate, 
										UITabBarControllerDelegate, 
										UITextFieldDelegate> {
@private 
	WebService* webService;
	AlertsTimer* alertsTimer;

	IBOutlet UIWindow* mainWindow;
	IBOutlet UIWindow* loginWindow;
    IBOutlet UITabBarController *tabBarController;
	IBOutlet UINavigationController* alertsNavController;
	IBOutlet UITabBarItem* alertsItem;
	
	// login window
	IBOutlet UITextField* usernameTextField;
	IBOutlet UITextField* passwordTextField;
	IBOutlet UILabel* loginMessageLabel;
	IBOutlet UIActivityIndicatorView* loginActivityView;
	
	// admin tab
	IBOutlet UILabel* currentUserNameLabel;
	IBOutlet UILabel* currentUserEMailLabel;
	IBOutlet UILabel* currentUserTypeLabel;
	IBOutlet UIActivityIndicatorView* logoutActivityView;
}

- (IBAction)loginButtonClick:(id)sender;
- (IBAction)logoutButtonClick:(id)sender;
- (void)loginMethod;
- (void)logoutMethod;

@end
