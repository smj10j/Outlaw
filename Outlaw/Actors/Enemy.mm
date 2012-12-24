//
//  Enemy.mm
//  Outlaw
//
//  Created by Stephen Johnson on 12/24/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy


-(id)initWithSprite:(LHSprite*)sprite {
	if(self = [super initWithSprite:sprite]) {

		_hasTarget = false;
		_type = @"Enemy";
	}
	return self;
}

-(void)update:(ccTime)dt {

	if(_hasTarget) {
	
	}
	
	[super update:dt];
}


-(void)dealloc {
	[super dealloc];
}

@end
