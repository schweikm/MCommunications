//
//  PatientListTableViewController.h
//  MComm
//
//  Created by Marc Schweikert on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PatientListTableCell;
@class SiteUser;

/*
 * This view controller is for the patient list tab.
 */
@interface PatientListTableViewController : UITableViewController {
@private 
	NSMutableArray* patientList;
	
	UITableView* tableView;
	UIBarButtonItem* bbItem;
}

@end
