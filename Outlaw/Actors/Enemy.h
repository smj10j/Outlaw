//
//  Enemy.h
//  Outlaw
//
//  Created by Stephen Johnson on 12/24/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#ifndef Outlaw_Enemy_h
#define Outlaw_Enemy_h

#import "Actor.h"

@interface Enemy : Actor {

	bool _hasTarget;
}

-(id)initWithSprite:(LHSprite*)sprite;

-(void)update:(ccTime)dt;

-(void)dealloc;

@end

#endif