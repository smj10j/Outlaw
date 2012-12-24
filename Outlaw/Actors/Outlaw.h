//
//  Outlaw.h
//  Outlaw
//
//  Created by Stephen Johnson on 12/24/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#ifndef Outlaw_Outlaw_h
#define Outlaw_Outlaw_h

#import "Enemy.h"

@interface Outlaw : Enemy {

}

-(id)initWithSprite:(LHSprite*)sprite;

-(void)update:(ccTime)dt;

-(void)dealloc;

@end

#endif