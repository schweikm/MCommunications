//
//  AddTaskViewController.h
//  MComm
//
//  Created by Marc Schweikert on 3/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Patient;
@class SiteUser;
@class Task;
@class WebService;

/*
 * The view controller for the My Tasks tab
 */
@interface AddTaskViewController : UIViewController <UITextFieldDelegate, 
													 UIPickerViewDataSource, 
													 UIPickerViewDelegate> {
@private 
	Patient* currentPatient;
	SiteUser* assignToUser;
	NSMutableArray* caretakerList;
	WebService* webService;
	Task* newTask;
	
	IBOutlet UIBarButtonItem* addTaskButton;
	IBOutlet UILabel* patientRegNumberLabel;
	IBOutlet UITextField* messageTextField;
	IBOutlet UISwitch* prioritySwitch;
	IBOutlet UIPickerView* assignToPicker;
	IBOutlet UIActivityIndicatorView* activityView;
}

@property (nonatomic, retain) Patient* currentPatient;

- (IBAction)addTaskClick;
- (void)addTaskMethod;

@end
