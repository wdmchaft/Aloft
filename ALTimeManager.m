//
//  ALTimeManager.m
//  Aloft
//
//  Created by Jan-Willem Buurlage on 23-10-10.
//  Copyright 2010 Web6.nl Diensten. All rights reserved.
//

#import "ALTimeManager.h"


@implementation ALTimeManager
@synthesize actualDate, simulatedDate;

static id sharedManager = nil;

+ (void)initialize {
    if (self == [ALTimeManager class]) {
        sharedManager = [[self alloc] init];
    }
}

/* MOVE TO TIME MANAGER IN DUE TIME */
-(float)elapsed {
	float elapsed;
	NSTimeInterval dJ = [simulatedDate timeIntervalSinceDate:[[NSDate alloc] initWithString:@"2000-01-01 00:00:00 +0000"]]; 
	/* NSLog(@"%i", [simulatedDate timeIntervalSinceDate:[[NSDate alloc] initWithString:@"2000-01-01 00:00:00 +0000"]]);
	 NSLog(@"%@", [simulatedDate description]); */
	dJ = dJ / 86400;
	
	float La = 99.967794687;
	float Lb = 360.9856473662860;
	float Lc = 2.907879 * pow(10, -13);
	float Ld = -5.302 * pow(10,-22);
	
	float sT = La + ( Lb * dJ ) + ( Lc * pow(dJ,2) ) + ( Ld * pow(dJ,3) );
	while(sT > 360) {
		sT -= 360;
	}
	elapsed = sT;
	elapsed = (M_PI / 180) * elapsed;
	elapsed += (M_PI / 180);
	
	return elapsed;
}

-(id)init {
	if(self = [super init]) {
		timeTest = [NSTimer scheduledTimerWithTimeInterval:0.075 target:self selector:@selector(calculateDate:) userInfo:nil repeats:YES];
		simulatedDate = [[NSDate alloc] init];
		speed = 1;
	}
	return self;
}

- (void)calculateDate:(id)aSender {
    if(!actualDate) {
        actualDate = [[NSDate alloc] init];
	}
	NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:actualDate];
	//NSLog(@"actual: %@",[actualDate description]);
    NSTimeInterval simulatedInterval = [simulatedDate timeIntervalSinceNow];
	//NSLog(@"simInterval: %@",[simulatedDate description]);
	
    [simulatedDate release];
    simulatedDate = [[NSDate alloc] initWithTimeIntervalSinceNow:simulatedInterval + (interval * speed)];
    
    [actualDate release];
    actualDate = [[NSDate alloc] init]; 
} 

+ (id)shared {
    return sharedManager;
}

- (void)ff {
	speed = speed * 2;
}

- (void)bb {
	speed = speed / 2;
}

@end
