//
//  Enemy.h
//  Outlaw
//
//  Created by Stephen Johnson on 12/24/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#ifndef Outlaw_Enemy_h
#define Outlaw_Enemy_h

#import "Common.h"
#import "LevelHelperLoader.h"
#import "CCPhysicsSprite.h"

@interface Enemy : NSObject {

	LHSprite* _sprite;

	bool _isMoving;
	CGPoint _movementVector;
	
	double _lifetime;
	int _seed;
}

-(id)initWithSprite:(LHSprite*)sprite;

-(void)update:(ccTime)dt;

-(LHSprite*)sprite;

-(void)setMovementVector:(CGPoint)movementVector;
-(void)setMoving:(bool)isMoving;

-(void)dealloc;

@end

#endif