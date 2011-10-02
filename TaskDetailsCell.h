//
//  TaskDetailsCell.h
//  MComm
//
//  Created by Marc Schweikert on 4/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * This custom table cell is used by My Tasks and Alerts to display a little
 * more information than just the message text.
 */
@interface TaskDetailsCell : UITableViewCell {
@private
	IBOutlet UILabel* taskMessageLabel;
	IBOutlet UILabel* patientNameLabel;
	IBOutlet UILabel* taskStatusLabel;
}

@property (nonatomic, retain) UILabel* taskMessageLabel;
@property (nonatomic, retain) UILabel* patientNameLabel;
@property (nonatomic, retain) UILabel* taskStatusLabel;


@end
