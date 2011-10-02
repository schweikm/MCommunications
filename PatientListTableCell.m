//
//  PatientListTableCell.m
//  MComm
//
//  Created by Marc Schweikert on 3/23/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "PatientListTableCell.h"


@implementation PatientListTableCell

@synthesize patientNameLabel;
@synthesize lowPriorityTasksLabel;
@synthesize highPriorityTasksLabel;
@synthesize regNumberLabel;
@synthesize floorLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// nothing special here
    }
    return self;
}

- (void)dealloc {
	[patientNameLabel release];
	[lowPriorityTasksLabel release];
	[highPriorityTasksLabel release];
	[regNumberLabel release];
	[floorLabel release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
