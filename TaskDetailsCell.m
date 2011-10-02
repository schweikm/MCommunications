//
//  TaskDetailsCell.m
//  MComm
//
//  Created by Marc Schweikert on 4/18/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TaskDetailsCell.h"


@implementation TaskDetailsCell

@synthesize taskMessageLabel;
@synthesize patientNameLabel;
@synthesize taskStatusLabel;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // nothing special here
    }
    return self;
}

- (void)dealloc {
	[taskMessageLabel release];
	[patientNameLabel release];
	[taskStatusLabel release];
	[super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
