//
//  Outlaw.mm
//  Outlaw
//
//  Created by Stephen Johnson on 12/24/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#import "Outlaw.h"

@implementation Outlaw


-(id)initWithSprite:(LHSprite*)sprite {
	if(self = [super initWithSprite:sprite]) {
		
	}
	return self;
}

-(void)update:(ccTime)dt {

	if((int)_lifetime % _seed == 0) {
		[self setMoving:(arc4random_uniform(1000) > 200)];
	}

	if((int)_lifetime % _seed*2 == 0) {

		CGPoint offset = ccp((int)(arc4random_uniform(500)-250)*SCALING_FACTOR_H,
							(int)(arc4random_uniform(500)-250)*SCALING_FACTOR_V);
		CGPoint targetMovePos = ccpAdd(_sprite.position, offset);
							
		CGPoint diff = ccpSub(targetMovePos, _sprite.position);
		[self setMovementVector:ccpMult(ccpNormalize(diff), (arc4random_uniform(30)+30)*SCALING_FACTOR)];
	}

	[super update:dt];
}


-(void)dealloc {
	[super dealloc];
}

@end
