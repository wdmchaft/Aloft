//
//  ALTimeManager.h
//  Aloft
//
//  Created by Jan-Willem Buurlage on 23-10-10.
//  Copyright 2010 Web6.nl Diensten. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ALTimeManager : NSObject {
	//move to time manager
	NSTimer* timeTest;
	NSDate* simulatedDate;
	NSDate* actualDate;
	float speed;	
}

@property(readwrite, assign) NSDate* actualDate;
@property(readwrite, assign) NSDate* simulatedDate;

+ (id)shared;
- (float)elapsed;
-(void)ff;
-(void)bb;

@end
