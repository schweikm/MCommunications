//
//  PatientListTableViewController.m
//  MComm
//
//  Created by Marc Schweikert on 2/17/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PatientListTableViewController.h"
#import "CachedData.h"
#import "Patient.h"
#import "PatientDetailsViewController.h"
#import "PatientListTableCell.h"
#import "SiteUser.h"
#import "WebService.h"


@implementation PatientListTableViewController

- (void)dealloc {
	[tableView release];
	[bbItem release];
	[patientList removeAllObjects];
	[patientList release];

    [super dealloc];
}

// load the patient list before the view appears to be updated
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// can't load the patient list before they log in!
	static Boolean first = YES; 
	if(first) {
		first = NO;
		return;
	}
	
	self.navigationItem.leftBarButtonItem = bbItem;
	
	// load the patient list for the current user
	WebService*	webService = [[WebService alloc] init];
	patientList = [webService getPatientList];
	[webService release];
	
	[[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView*)AtableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView*)AtableView numberOfRowsInSection:(NSInteger)section {
    return [patientList count];
}

// 
- (CGFloat)tableView:(UITableView *)AtableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {  
    return 61;
}

// Customize the appearance of table view cells.
- (UITableViewCell*)tableView:(UITableView*)AtableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    static NSString *CellIdentifier = @"PatientListCell";
    
    PatientListTableCell* cell = 
	(PatientListTableCell*)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if(!cell) {
        NSArray* topLevelObjects = [[NSBundle mainBundle] 
									loadNibNamed:@"PatientListCell" owner:nil options:nil];
		
		for(id obj in topLevelObjects) {
			if([obj isKindOfClass:[UITableViewCell class]]) {
				cell = (PatientListTableCell*) obj;
				break;
			}
		}
    }

	if(cell) {
		Patient* currentPatient = [patientList objectAtIndex:indexPath.row];
    
		cell.patientNameLabel.text = [NSString stringWithString:[[patientList objectAtIndex:indexPath.row] fullName]];		
		cell.lowPriorityTasksLabel.text = [NSString stringWithFormat:@"%ld", currentPatient.numLowPriorityTasks];
		cell.highPriorityTasksLabel.text = [NSString stringWithFormat:@"%ld", currentPatient.numHighPriorityTasks];
		cell.regNumberLabel.text = [NSString stringWithFormat:@"Reg#: %ld", currentPatient.regNumber];
		cell.floorLabel.text = [NSString stringWithFormat:@"Floor: %@", currentPatient.floorName];
	}
	
    return cell;
}

- (void)tableView:(UITableView*)AtableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
	PatientDetailsViewController* patientDetailsViewController;
	patientDetailsViewController = [[PatientDetailsViewController alloc] initWithNibName:@"PatientDetailsView" bundle:nil];
	
	patientDetailsViewController.currentPatient = [patientList objectAtIndex:indexPath.row];
	
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
	self.navigationItem.backBarButtonItem = backButton;
	[backButton release];
	
	[self.navigationController pushViewController:patientDetailsViewController animated:YES];
	[patientDetailsViewController release];
}

@end
