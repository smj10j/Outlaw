//
//  Player.h
//  Outlaw
//
//  Created by Stephen Johnson on 12/24/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#ifndef Outlaw_Player_h
#define Outlaw_Player_h

#import "Actor.h"

@interface Player : Actor {

}

-(id)initWithSprite:(LHSprite*)sprite;

-(void)update:(ccTime)dt;

-(void)dealloc;

@end

#endif