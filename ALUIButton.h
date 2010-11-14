//
//  ALUIButton.h
//  Aloft
//
//  Created by Jan-Willem Buurlage on 26-10-10.
//  Copyright 2010 Web6.nl Diensten. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface ALUIButton : CALayer {
	NSString* title; //title used
	CATextLayer* textLayer; //self-explanatory
	CALayer* view; //used to open up the HUD window/view
	CALayer* iconLayer; //self-explanatory
	BOOL on;
	
	id delegate;
}

-(void)setFlag:(BOOL)turnOn;
-(id)initWithTitle:(NSString*)theTitle frame:(CGRect)theFrame layer:(CALayer*)theLayer;
-(id)initLeftWithTitle:(NSString*)theTitle frame:(CGRect)theFrame layer:(CALayer*)theLayer delegate:(id)aDelegate;

@end
