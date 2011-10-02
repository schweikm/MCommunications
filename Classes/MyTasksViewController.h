//
//  SecondViewController.h
//  MComm
//
//  Created by Marc Schweikert on 1/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * This view controller is for the My Tasks tab.
 */
@interface MyTasksViewController : UITableViewController {	
@private 
	NSMutableArray* myTaskList;
	UIBarButtonItem* bbItem;
}

@end
