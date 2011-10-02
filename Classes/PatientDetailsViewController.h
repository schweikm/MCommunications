//
//  DetailsViewController.h
//  MComm
//
//  Created by Marc Schweikert on 3/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Patient;

/*
 * This view controller is the one that slides in when you tap a Patient in
 * the patient list.
 */
@interface PatientDetailsViewController : UIViewController <UITableViewDataSource> {
@private 
	Patient* currentPatient;
	NSMutableArray* taskList;
	
	UIBarButtonItem* addTaskItem;

	IBOutlet UILabel* patientRegNumberLabel;
	IBOutlet UILabel* patientDOBLabel;
	IBOutlet UILabel* patientFloorLabel;
	IBOutlet UITableView* tableView;
}

@property (nonatomic, retain) Patient* currentPatient;
@property (nonatomic, retain) UIBarButtonItem* addTaskItem;

- (IBAction)addTaskWasPressed;

@end
