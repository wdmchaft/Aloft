//
//  ALDataManager.h
//  Aloft
//
//  Created by Jan-Willem Buurlage on 22-10-10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <sqlite3.h>

struct Star {
	float ra;
	float dec;
	float mag;
};


@interface ALDataManager : NSObject {
	NSString* dbPath;
	NSMutableArray* stars;
}

+ (id)shared;
- (void)getData;
- (NSMutableArray*)stars;

@end
