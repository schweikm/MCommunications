//
//  ThirdViewController.h
//  MComm
//
//  Created by Marc Schweikert on 1/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * This view controller is for the Alerts tab
 */
@interface AlertsViewController : UITableViewController {
@private 
	NSMutableArray* alertsTaskList;
}

// the AlertsTimer calls this method to reload the table
- (void)refresh;

@end
