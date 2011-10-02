//
//  MCommAppDelegate.m
//  MComm
//
//  Created by Marc Schweikert on 1/29/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "MCommAppDelegate.h"
#import "AlertsTimer.h"
#import "CachedData.h"
#import "SiteUser.h"
#import "WebService.h"


@implementation MCommAppDelegate

- (void) dealloc {
	[webService release];
	
    [mainWindow release];
	[loginWindow release];
	[tabBarController release];
	[alertsNavController release];
	[alertsItem release];
	
	[usernameTextField release];
	[passwordTextField release];
	[loginMessageLabel release];
	[loginActivityView release];
	
	[currentUserNameLabel release];
	[currentUserEMailLabel release];
	[currentUserTypeLabel release];
	[logoutActivityView release];

    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)applicationDidFinishLaunching:(UIApplication*)application {	
	// This is used as the xmlns for the method name
	// There needs to be an ending / otherwise everything will break
	[CachedData get_instance].webServiceRoot = @"http://eecs497-3.eecs.umich.edu/"; 
	
	// This is the URL of the webservice
	[CachedData get_instance].webServicePath = @"http://mcomm.eecs.umich.edu/WebService/service.asmx";
    
    // Add the tab bar controller's current view as a subview of the window
    [mainWindow addSubview:tabBarController.view];
	
	// start with the login window
	mainWindow.hidden = YES;
	loginWindow.hidden = NO;
	[loginWindow makeKeyAndVisible];
	
	// when the user logs in, let's open the keyboard for username
	[usernameTextField becomeFirstResponder];
}

- (IBAction)loginButtonClick:(id)sender {
	// set the Patient List as the default tab
	tabBarController.selectedIndex = 0;
	
	// close the virtual keyboard
	[usernameTextField resignFirstResponder];
	[passwordTextField resignFirstResponder];
	
	// clear the error label
	loginMessageLabel.text = @"";

	// start the wheel spinning
	[loginActivityView startAnimating];
	
	//Trigger a short timer to give the event loop some time to start spinning the wheel
	[NSTimer scheduledTimerWithTimeInterval: 0.1
									 target:self
								   selector:@selector(loginMethod)
								   userInfo:nil
									repeats:NO];
}

- (void)loginMethod {
	webService = [[WebService alloc] init];
	NSInteger siteUserPK = [webService loginWithUserName:usernameTextField.text password:passwordTextField.text];
	
	// invalid == 0, valid > 0
	if(siteUserPK > 0) {
		// get the user and store it in our static class
		[CachedData get_instance].currentUser = [webService getSiteUserForSiteUserPK:siteUserPK];
		
		// update the info on the Admin tab
		currentUserNameLabel.text = [CachedData get_instance].currentUser.fullname;
		currentUserEMailLabel.text = [NSString stringWithFormat:@"%@@med.umich.edu", [CachedData get_instance].currentUser.userName];
		currentUserTypeLabel.text = [SiteUser getUserTypeDescriptionForUserType:[CachedData get_instance].currentUser.userType];

		// start checking for alerts in the background
		alertsTimer = [[AlertsTimer alloc] initWithUITabBarItem:alertsItem navController:alertsNavController siteUserPK:siteUserPK];
		[alertsTimer start];
				
		// change window from login to main
		loginWindow.hidden = YES;
		mainWindow.hidden = NO;
		[mainWindow makeKeyAndVisible];
	}
	else {
		loginMessageLabel.text = @"Login Failed";
		usernameTextField.text = @"";
		passwordTextField.text = @"";
	}

	[loginActivityView stopAnimating];
}

- (IBAction)logoutButtonClick:(id)sender {
	// close the keyboard
	[usernameTextField resignFirstResponder];
	[passwordTextField resignFirstResponder];
	
	// start the wheel spinning
	[logoutActivityView startAnimating];
	
	//Trigger a short timer to give the event loop some time to start spinning the wheel
	[NSTimer scheduledTimerWithTimeInterval: 0.1
									 target:self
								   selector:@selector(logoutMethod)
								   userInfo:nil
									repeats:NO];
}

- (void)logoutMethod {
	// call the Web Service to update the user's status in the DB
	[webService logout];
	
	[CachedData get_instance].currentUser = nil;
	
	// stop checking for alerts
	[alertsTimer stop];
	[alertsTimer release];
	
	usernameTextField.text = @"";
	passwordTextField.text = @"";
	
	// stop the wheel
	[logoutActivityView stopAnimating];
	
	// change windows from main to login
	mainWindow.hidden = YES;
	loginWindow.hidden = NO;
	[loginWindow makeKeyAndVisible];
}

@end
