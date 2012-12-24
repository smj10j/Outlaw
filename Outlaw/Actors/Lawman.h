//
//  Lawman.h
//  Outlaw
//
//  Created by Stephen Johnson on 12/24/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#ifndef Outlaw_Lawman_h
#define Outlaw_Lawman_h

#import "Enemy.h"
#include <vector>
using namespace std;

@interface Lawman : Enemy {

	vector<CGPoint> _patrolPoints;
	int _patrolPointIndex;
}

-(id)initWithSprite:(LHSprite*)sprite;

-(void)update:(ccTime)dt;

-(void)dealloc;

@end

#endif