//
//  GameScene.h
//  Outlaw
//
//  Created by Stephen Johnson on 12/23/12.
//  Copyright Conquer LLC 2012. All rights reserved.
//

#import "Common.h"
#import "Box2D.h"
#import "Player.h"
#import "Outlaw.h"
#import "Lawman.h"
#include <vector>
using namespace std;

// HelloWorldLayer
@interface GameScene : CCLayer
{	
	LevelHelperLoader* _levelLoader;
	b2World* _world;					// strong ref

	CGSize _levelSize;
	LHLayer* _mainLayer;


	Player* _player;
	vector<Enemy*> _enemies;

	CGPoint _joystickCenter;
	int _numTouchesOnScreen;

	float _fixedTimestepAccumulator;
	
	
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;




@end
