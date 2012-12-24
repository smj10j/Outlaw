//
//  Lawman.mm
//  Outlaw
//
//  Created by Stephen Johnson on 12/24/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#import "Lawman.h"

@implementation Lawman


-(id)initWithSprite:(LHSprite*)sprite {
	if(self = [super initWithSprite:sprite]) {
		
		_patrolPoints.push_back(_sprite.position);
		for(int i = 0; i < 2; i++) {
			CGPoint point = ccpAdd(_sprite.position, ccp((int)(arc4random_uniform(500)-250)*SCALING_FACTOR_H,
														(int)(arc4random_uniform(500)-250)*SCALING_FACTOR_V)
							);
			_patrolPoints.push_back(point);
		}

		_patrolPointIndex = 0;
		_isMoving = true;

	}
	return self;
}

-(void)update:(ccTime)dt {

	CGPoint diff = ccpSub(_patrolPoints[_patrolPointIndex], _sprite.position);
	if(ccpLengthSQ(diff) < 100) {
		_patrolPointIndex++;
		if(_patrolPointIndex >= _patrolPoints.size()) {
			_patrolPointIndex = 0;
		}
		diff = ccpSub(_patrolPoints[_patrolPointIndex], _sprite.position);
		[self setMovementVector:ccpMult(ccpNormalize(diff), (arc4random_uniform(50)+50)*SCALING_FACTOR)];
	}
			
	[super update:dt];
}


-(void)dealloc {
	[super dealloc];
}

@end
