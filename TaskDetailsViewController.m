//
//  TaskDetailsViewController.m
//  MComm
//
//  Created by Marc Schweikert on 3/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TaskDetailsViewController.h"
#import "CachedData.h"
#import "Patient.h"
#import "Response.h"
#import "SiteUser.h"
#import "Task.h"
#import "WebService.h"

// "constants"
NSString* acknowledge_action_c = @"Acknowledge";
NSString* delegate_action_c = @"Delegate";
NSString* complete_action_c = @"Complete";


@implementation TaskDetailsViewController

@synthesize currentPatient, currentTask;

- (void)dealloc {
	[currentTask release];
	[currentPatient release];
	[responseList removeAllObjects];
	[responseList release];
	[caretakerList removeAllObjects];
	[caretakerList release];
	[webService release];
	
	[fullMessageTextView release];
	[historyTextView release];
	[assignToPicker release];
	[taskActionPicker release];
	[patientRegNumberLabel release];
	[patientDOBLabel release];
	[patientFloorLabel release];
	[toolbar release];
	
    [super dealloc];
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		webService = [[WebService alloc] init];
		self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

// load the patient list before the view appears to be updated
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	self.navigationItem.title = currentPatient.fullName;
	self.navigationItem.leftBarButtonItem.title = @"ROFL";
	
	// full message text
	fullMessageTextView.text = currentTask.messageText;
	fullMessageTextView.editable = NO;

	fullMessageTextView.textColor = [UIColor blackColor];
	
	// high priority tasks have red text
	if(currentTask.isHighPriority) {
		fullMessageTextView.textColor = [UIColor redColor];
	}
	
	// completed tasks are light gray
	if([currentTask isComplete]) {
		fullMessageTextView.textColor = [UIColor lightGrayColor];
	}
	
	// history
	NSMutableString* historyString = [[NSMutableString alloc] init];
	NSEnumerator* enumerator = [responseList objectEnumerator];
	Response* element;
	NSString* action;
	NSString* user;
	NSString* assignUser;
	NSString* date;
	NSString* time;
	
	while(element = [enumerator nextObject]) {
		action = [Response getResponseDescriptionByActionFK:element.actionFK];
		
		if(element.addedBy > 0) {
			user = [webService getSiteUserForSiteUserPK:element.addedBy].fullname;
		}
		else {
			user = @"Unknown!!!";
		}
		
		date = [[element.dateAdded description] substringToIndex:10];
		time = [[element.dateAdded description] substringFromIndex:11];
		time = [time substringToIndex:8];
		
		if([action isEqualToString:@"Delegated"]) {
			assignUser = [webService getSiteUserForSiteUserPK:element.assignmentUserFK].fullname;
			[historyString appendString:[NSString stringWithFormat:@"%@ %@\n%@ by %@\nto %@\n\n", date, time, action, user, assignUser]];
		}
		else {
			[historyString appendString:[NSString stringWithFormat:@"%@ %@\n%@ by %@\n\n", date, time, action, user]];
		}
    }
	
	historyTextView.text = historyString;
	NSRange range;
	range.location = [historyString length];
	[historyTextView scrollRangeToVisible:NSMakeRange([historyString length], 0)];

	// make the user wheel default to the current assignee or empty for no assignment
	// can't use the TaskListData user because I need the index number of the picker
	enumerator = [caretakerList objectEnumerator];
	SiteUser* userObj;
	int count = 0, index = 0;
	Boolean found = NO;
	while(userObj = [enumerator nextObject]) {
		if(currentTask.assignedTo == userObj.siteUserPk) {
			index = count;
			found = YES;
			break;
		}
		else {
			count++;
		}
    }
	
	index = (found) ? index : 0;
	[assignToPicker selectRow:index inComponent:0 animated:NO];
	initialAssignToUser = [caretakerList objectAtIndex:index];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// get the responses here so that they are reloaded with every new task
	responseList = [webService getTaskResponsesForTaskPK:currentTask.taskPK];
	
	// get the active caretakers for assignment
	caretakerList = [webService getAllCareTakersForPatientPK:currentPatient.patientPK];
	SiteUser* empty = [[SiteUser alloc] init];
	[caretakerList insertObject:empty atIndex:0];
	
	// hide the pickers
	assignToPicker.hidden = YES;
	taskActionPicker.hidden = YES;
	
	// set the patient information
	patientRegNumberLabel.text = [NSString stringWithFormat:@"Reg#: %ld", currentPatient.regNumber];
	patientDOBLabel.text = [NSString stringWithFormat:@"Date of Birth: %@", [[currentPatient.dateOfBirth description] substringToIndex:10]];
	patientFloorLabel.text = [NSString stringWithFormat:@"Floor: %@", currentPatient.floorName];
}

- (IBAction)applyChanges {
	// don't do anything if the user delegates to the same person or doesn't specify an action
	if(([actionString isEqualToString:delegate_action_c] && (assignToUser == initialAssignToUser)) || [actionString isEqualToString:@""]) {
		return;
	}

	// otherwise, add a response
	Response* response = [[Response alloc] init];
		
	response.taskFK = currentTask.taskPK;
	response.dateAdded = [NSDate date];
	response.assignmentUserFK = [CachedData get_instance].currentUser.siteUserPk;
	
	if([actionString isEqualToString:delegate_action_c]) {
		response.assignmentUserFK = assignToUser.siteUserPk;
		response.actionFK = 2;
	}
	else if([actionString isEqualToString:acknowledge_action_c]) {
		response.actionFK = 3;
	}
	else if([actionString isEqualToString:complete_action_c]) {
		response.actionFK = 4;
	}

	[webService respondToTaskWithResponse:response];
		
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)toolbarActionClick {
	assignToUser = nil;
	
	// both are closed, show action
	if(assignToPicker.hidden && taskActionPicker.hidden) {
		taskActionPicker.hidden = NO;
		[assignToPicker reloadAllComponents];
		[taskActionPicker reloadAllComponents];
		return;
	}
	
	// if either is open, close them both
	if(!assignToPicker.hidden || !taskActionPicker.hidden) {
		assignToPicker.hidden = YES;
		taskActionPicker.hidden = YES;
	}
}

- (IBAction)toolbarAcceptClick {
	// we need to pick someone to delegate to
	if([actionString isEqualToString:delegate_action_c]) {
		if(!assignToUser && assignToPicker.hidden && !taskActionPicker.hidden) {
			taskActionPicker.hidden = YES;
			assignToPicker.hidden = NO;
			[assignToPicker reloadAllComponents];
			[taskActionPicker reloadAllComponents];
			return;
		}
		
		// we've made a selection
		else if(!assignToPicker.hidden && taskActionPicker.hidden) {
			taskActionPicker.hidden = NO;
			assignToPicker.hidden = YES;
			[assignToPicker reloadAllComponents];
			[taskActionPicker reloadAllComponents];
			return;
		}
		// otherwise, we have chosen someone and it is showing up, so let's apply it
	}

	// otherwise, they are acknowledging or completing; store and hide
	[self applyChanges];
	assignToPicker.hidden = YES;
	taskActionPicker.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

# pragma mark UIPickerView methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component {
	if(!assignToPicker.hidden) {
		return [caretakerList count];
	}
	
	return 4;
}

- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if(!assignToPicker.hidden) {
		SiteUser* user = [caretakerList objectAtIndex:row];
		return user.fullname;
	}
	
	switch(row) {
		case 0:
			return @"";
			
		case 1:
			return acknowledge_action_c;
			
		case 2:
			// no assignment made yet
			if(!assignToUser) {
				return delegate_action_c;
			}
			return [NSString stringWithFormat:@"Delegate to %@", assignToUser.fullname];
			
		case 3:
			return complete_action_c;
			
		default:
			return @"";
	}
}

- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if(!assignToPicker.hidden) {
		assignToUser = [caretakerList objectAtIndex:row];
		return;
	}
	
	switch(row) {
		case 1:
			actionString = acknowledge_action_c;
			break;
			
		case 2:
			actionString = delegate_action_c;
			break;
			
		case 3:
			actionString = complete_action_c;
			break;
			
		default:
			actionString = @"";
			break;
	}
}

@end
