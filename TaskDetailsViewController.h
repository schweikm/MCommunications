//
//  TaskDetailsViewController.h
//  MComm
//
//  Created by Marc Schweikert on 3/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Patient;
@class SiteUser;
@class Task;
@class WebService;

/*
 * This view controller displays the details of a specific task.
 */
@interface TaskDetailsViewController : UIViewController <UIPickerViewDataSource, 
														 UIPickerViewDelegate> {
@private 
	Task* currentTask;
	Patient* currentPatient;
	NSMutableArray* responseList;
	NSMutableArray* caretakerList;
	SiteUser* assignToUser;
	SiteUser* initialAssignToUser;
	WebService* webService;
	NSString* actionString;
	
	IBOutlet UITextView* fullMessageTextView;
	IBOutlet UITextView* historyTextView;
	IBOutlet UIPickerView* assignToPicker;
	IBOutlet UIPickerView* taskActionPicker;
	IBOutlet UILabel* patientRegNumberLabel;
	IBOutlet UILabel* patientDOBLabel;
	IBOutlet UILabel* patientFloorLabel;
	IBOutlet UIToolbar* toolbar;
}

@property (nonatomic, retain) Task* currentTask;
@property (nonatomic, retain) Patient* currentPatient;

- (IBAction)applyChanges;
- (IBAction)toolbarActionClick;
- (IBAction)toolbarAcceptClick;

@end
