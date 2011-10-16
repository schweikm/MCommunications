//
//  DetailsViewController.m
//  MComm
//
//  Created by Marc Schweikert on 3/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PatientDetailsViewController.h"
#import "AddTaskViewController.h"
#import "CachedData.h"
#import "Patient.h"
#import "SiteUser.h"
#import "Task.h"
#import "TaskDetailsViewController.h"
#import "TaskListData.h"
#import "WebService.h"


@implementation PatientDetailsViewController

@synthesize currentPatient;
@synthesize addTaskItem;

- (void)dealloc {
	[currentPatient release];
	[taskList removeAllObjects];
	[taskList release];
	
	[addTaskItem release];
	
	[patientRegNumberLabel release];
	[patientDOBLabel release];
	[patientFloorLabel release];
	[tableView release];

    [super dealloc];
}

// load the patient list before the view appears to be updated
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// set the title as the patient's full name
	self.navigationItem.title = [NSString stringWithString:currentPatient.fullName];
	
	// load the task list for the current user
	WebService* webService = [[WebService alloc] init];
	taskList = [webService getPatientTaskListForPatientPK:currentPatient.patientPK];
	[webService release];
	
	// need to reload the table
	[tableView reloadData];	
}


// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		self.addTaskItem = [[[UIBarButtonItem alloc] 
							initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
							target:self 
							action:@selector(addTaskWasPressed)] autorelease];
		
		self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// set the patient information
	patientRegNumberLabel.text = [NSString stringWithFormat:@"Reg#: %ld", currentPatient.regNumber];
	patientDOBLabel.text = [NSString stringWithFormat:@"Date of Birth: %@", [[currentPatient.dateOfBirth description] substringToIndex:10]];
	patientFloorLabel.text = [NSString stringWithFormat:@"Floor: %@", currentPatient.floorName];
	
	self.navigationItem.rightBarButtonItem = self.addTaskItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (IBAction)addTaskWasPressed {
	AddTaskViewController* addTaskViewController;
	addTaskViewController = [[AddTaskViewController alloc] initWithNibName:@"AddTaskView" bundle:nil];
	
	addTaskViewController.currentPatient = currentPatient;
	
	[self.navigationController pushViewController:addTaskViewController animated:YES];
	[addTaskViewController release];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView*)AtableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView*)AtableView numberOfRowsInSection:(NSInteger)section {
    return [taskList count];
}

// Customize the appearance of table view cells.
- (UITableViewCell*)tableView:(UITableView*)AtableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    static NSString *CellIdentifier = @"PatientDetailsCell";
    
    UITableViewCell *cell = [AtableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	TaskListData* data = [taskList objectAtIndex:indexPath.row];
	Task* currentTask = data.task;

	cell.textLabel.textColor = [UIColor blackColor];
	
	// high priority tasks have red text
	if(currentTask.isHighPriority) {
		cell.textLabel.textColor = [UIColor redColor];
	}
	
	// completed tasks are light gray
	if([currentTask isComplete]) {
		cell.textLabel.textColor = [UIColor lightGrayColor];
	}
	
	// use the full text for now
	cell.textLabel.text = currentTask.messageText;
	
    return cell;
}


- (void)tableView:(UITableView*)AtableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	TaskDetailsViewController* taskDetailsViewController;
	taskDetailsViewController = [[TaskDetailsViewController alloc] initWithNibName:@"TaskDetailsView" bundle:nil];
	
	taskDetailsViewController.currentPatient = currentPatient;
	TaskListData* data = [taskList objectAtIndex:indexPath.row];
	taskDetailsViewController.currentTask = data.task;
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
	
	[self.navigationController pushViewController:taskDetailsViewController animated:YES];
	[taskDetailsViewController release];
}

@end
