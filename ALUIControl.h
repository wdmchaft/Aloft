//
//  ALUIControl.h
//  Aloft
//
//  Created by Jan-Willem Buurlage on 26-10-10.
//  Copyright 2010 Web6.nl Diensten. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ALUIControl : CALayer {
	id delegate;
	int value;  //1 voor plus, -1 voor minus
}

-(void)hit;
-(id)initWithValue:(int)theValue frame:(CGRect)aFrame delegate:(id)aDelegate;


@end
