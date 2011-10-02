//
//  CachedInformation.m
//  MComm
//
//  Created by Marc Schweikert on 3/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CachedData.h"

static CachedData* instance = 0;

@implementation CachedData

@synthesize currentUser;
@synthesize webServicePath;
@synthesize webServiceRoot;

+ (CachedData*)get_instance {
	@synchronized(self) {
        if(!instance) {
            instance = [[self alloc] init];
		}
    }

    return instance;
}

- (void)dealloc {
	[instance release];
	[super dealloc];
}

@end
