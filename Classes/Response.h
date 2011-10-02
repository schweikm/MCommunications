//
//  Response.h
//  MComm
//
//  Created by Marc Schweikert on 1/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * This class holds all of the information related to responses.
 */
@interface Response : NSObject {
@private 
	NSInteger responsePK;
	NSInteger taskFK;
	NSInteger actionFK;
	NSDate* dateAdded;
	NSInteger addedBy;
	NSInteger assignmentUserFK;
}

@property (nonatomic, assign) NSInteger responsePK;
@property (nonatomic, assign) NSInteger taskFK;
@property (nonatomic, assign) NSInteger actionFK;
@property (nonatomic, retain) NSDate* dateAdded;
@property (nonatomic, assign) NSInteger addedBy;
@property (nonatomic, assign) NSInteger assignmentUserFK;

+ (NSString*)getResponseDescriptionByActionFK:(NSInteger)anActionFK;

@end
