//
//  Player.mm
//  Outlaw
//
//  Created by Stephen Johnson on 12/24/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#import "Player.h"

@implementation Player


-(id)initWithSprite:(LHSprite*)sprite {
	if(self = [super initWithSprite:sprite]) {

		_type = @"Player";
	}
	return self;
}

-(void)update:(ccTime)dt {

	if(_isMoving) {
		_sprite.parent.position = ccpAdd(ccpMult(_movementVector, -dt), _sprite.parent.position);
		
		float rotationRadians = atan2f(_movementVector.x, _movementVector.y);		
		int targetRotation = CC_RADIANS_TO_DEGREES(rotationRadians);
		double smoothedRotation = targetRotation*_sprite.rotation < 0 || abs(_sprite.rotation-targetRotation) > 180 ? targetRotation : (double)(targetRotation+(int)_sprite.rotation*14)/15;
		[_sprite transformRotation:smoothedRotation];
	}
	
	
	[super update:dt];
}


-(void)dealloc {
	[super dealloc];
}

@end
