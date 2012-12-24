//
//  Player.h
//  Outlaw
//
//  Created by Stephen Johnson on 12/24/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#ifndef Outlaw_Player_h
#define Outlaw_Player_h

#import "Common.h"
#import "LevelHelperLoader.h"
#import "CCPhysicsSprite.h"

@interface Player : NSObject {

	LHSprite* _sprite;

	bool _isMoving;
	CGPoint _movementVector;	
}

-(id)initWithSprite:(LHSprite*)sprite;

-(void)update:(ccTime)dt;


-(LHSprite*)sprite;

-(void)setMovementVector:(CGPoint)movementVector;
-(void)setMoving:(bool)isMoving;

-(void)dealloc;

@end

#endif