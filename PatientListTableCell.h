//
//  PatientListTableCell.h
//  MComm
//
//  Created by Marc Schweikert on 3/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * This custom table cell is used for the Patient List.  It displays the name
 * as well as the number of tasks.
 */
@interface PatientListTableCell : UITableViewCell {
@private 
	IBOutlet UILabel* patientNameLabel;
	IBOutlet UILabel* lowPriorityTasksLabel;
	IBOutlet UILabel* highPriorityTasksLabel;
	IBOutlet UILabel* regNumberLabel;
	IBOutlet UILabel* floorLabel;
}

@property (nonatomic, retain) UILabel* patientNameLabel;
@property (nonatomic, retain) UILabel* lowPriorityTasksLabel;
@property (nonatomic, retain) UILabel* highPriorityTasksLabel;
@property (nonatomic, retain) UILabel* regNumberLabel;
@property (nonatomic, retain) UILabel* floorLabel;

@end
