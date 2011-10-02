//
//  AddTaskViewController.m
//  MComm
//
//  Created by Marc Schweikert on 3/21/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AddTaskViewController.h"
#import "CachedData.h"
#import "Patient.h"
#import "Response.h"
#import "SiteUser.h"
#import "Task.h"
#import "WebService.h"

@implementation AddTaskViewController

@synthesize currentPatient;

- (void)dealloc {

	[currentPatient release];
	[caretakerList removeAllObjects];
	[caretakerList release];
	[webService release];
	if(newTask) {
		[newTask release];
	}
	
	[addTaskButton release];
	[patientRegNumberLabel release];
	[messageTextField release];
	[prioritySwitch release];
	[assignToPicker release];
	[activityView release];
	
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];	
	return YES;
}

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		addTaskButton = [[UIBarButtonItem alloc]
						initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(addTaskClick)];
		
		self.navigationItem.rightBarButtonItem = addTaskButton;
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[activityView stopAnimating];
	activityView.hidesWhenStopped = YES;
	
	// make the return key done since newlines don't make sense
	messageTextField.returnKeyType = UIReturnKeyDone;
	
	// set the patient information
	patientRegNumberLabel.text = [NSString stringWithFormat:@"Reg#: %ld", currentPatient.regNumber];
	
	// make tasks low priority by default
	[prioritySwitch setOn:NO animated:NO];
	
	// load the assign to picker
	if(!webService) {
		webService = [[WebService alloc] init];
	}
	caretakerList = [webService getAllCareTakersForPatientPK:currentPatient.patientPK];
	
	// make the default no one
	SiteUser* empty = [[SiteUser alloc] init];
	[caretakerList insertObject:empty atIndex:0];
}

- (IBAction)addTaskClick {
	// start the wheel spinning
	[activityView startAnimating];
	
	newTask = [[Task alloc] init];
	newTask.patientFK = currentPatient.patientPK;
	newTask.messageText = [NSString stringWithString:messageTextField.text];
	newTask.isHighPriority = prioritySwitch.on;
	if(![assignToUser.fullname isEqualToString:@""]) {
		newTask.assignedTo = assignToUser.siteUserPk;
	}

	//Trigger a short timer to give the event loop some time to start spinning the wheel
	[NSTimer scheduledTimerWithTimeInterval: 0.1
									 target:self
								   selector:@selector(addTaskMethod)
								   userInfo:nil
									repeats:NO];
}

- (void)addTaskMethod {
	// send the request to the web service
	[webService addTask:newTask];

	[activityView stopAnimating];
	[self.navigationController popViewControllerAnimated:YES];
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
	return [caretakerList count];
}

- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	SiteUser* user = [caretakerList objectAtIndex:row];
	return user.fullname;
}

- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	assignToUser = [caretakerList objectAtIndex:row];
}

@end
