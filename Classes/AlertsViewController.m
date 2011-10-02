//
//  ThirdViewController.m
//  MComm
//
//  Created by Marc Schweikert on 1/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AlertsViewController.h"
#import "CachedData.h"
#import "Patient.h"
#import "Response.h"
#import "SiteUser.h"
#import "Task.h"
#import "TaskDetailsCell.h"
#import "TaskDetailsViewController.h"
#import "TaskListData.h"
#import "WebService.h"


@implementation AlertsViewController

- (void)dealloc {
	[alertsTaskList removeAllObjects];
	[alertsTaskList release];
    [super dealloc];
}

// load the patient list before the view appears to be updated
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self refresh];
}

- (void)refresh {
	// load the patient list for the current user
	WebService* webService = [[WebService alloc] init];	
	alertsTaskList = [webService getAlertsTaskList];
	[webService release];
	
	[[self tableView] reloadData];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [alertsTaskList count];
}

// 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61;
}

// Customize the appearance of table view cells.
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    static NSString *CellIdentifier = @"TaskDetailsCell";
	
	TaskDetailsCell* cell = 
	(TaskDetailsCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if(!cell) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] 
									loadNibNamed:@"TaskDetailsCell" owner:nil options:nil];
		
		for(id obj in topLevelObjects) {
			if([obj isKindOfClass:[UITableViewCell class]]) {
				cell = (TaskDetailsCell*) obj;
				break;
			}
		}
    }
	
	if(cell) {
		TaskListData* data = [alertsTaskList objectAtIndex:indexPath.row];
		Task* currentTask = data.task;
		cell.taskMessageLabel.text = currentTask.messageText;
		
		cell.taskMessageLabel.textColor = [UIColor blackColor];
		
		// high priority tasks have red text
		if(currentTask.isHighPriority) {
			cell.taskMessageLabel.textColor = [UIColor redColor];
		}
		
		// completed tasks are light gray
		if([currentTask isComplete]) {
			cell.taskMessageLabel.textColor = [UIColor lightGrayColor];
		}
		
		Patient* currentPatient = data.patient;
		cell.patientNameLabel.text = currentPatient.fullName;
		cell.taskStatusLabel.text = [Response getResponseDescriptionByActionFK:currentTask.latestActionFK];
	}
	
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	TaskDetailsViewController* taskDetailsViewController;
	taskDetailsViewController = [[TaskDetailsViewController alloc] initWithNibName:@"TaskDetailsView" bundle:nil];
	
	TaskListData* data = [alertsTaskList objectAtIndex:indexPath.row];
	taskDetailsViewController.currentTask = data.task;
	taskDetailsViewController.currentPatient = data.patient;
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
	
	[self.navigationController pushViewController:taskDetailsViewController animated:YES];
	[taskDetailsViewController release];
}

@end
