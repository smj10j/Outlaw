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
	if(self = [super init]) {
		_sprite = sprite;
		[_sprite retain];
		
		_isMoving = false;
		_movementVector = ccp(0,0);
	}
	return self;
}

-(void)update:(ccTime)dt {
	if(_isMoving) {
		[_sprite transformPosition:ccpAdd(ccpMult(_movementVector, dt), _sprite.position)];
	}
}

-(LHSprite*)sprite {
	return _sprite;
}

-(void)setMovementVector:(CGPoint)movementVector {
	_movementVector = movementVector;
	DebugLog(@"Movement vector: %@", NSStringFromCGPoint(_movementVector));
}

-(void)setMoving:(bool)isMoving {
	_isMoving = isMoving;
	if(!_isMoving) {
		[self setMovementVector:ccp(0,0)];
	}
}



-(void)dealloc {
	if(_sprite != nil) {
		[_sprite release];
		_sprite = nil;
	}
	[super dealloc];
}

@end
