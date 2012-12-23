//
//  GameScene.mm
//  Outlaw
//
//  Created by Stephen Johnson on 12/23/12.
//  Copyright Conquer LLC 2012. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

+(CCScene *) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init {
	if( (self=[super init])) {
	
		self.isTouchEnabled = YES;

		//variable initialization
		_fixedTimestepAccumulator = 0;
		
		
		CGSize winSize = [CCDirector sharedDirector].winSize;
		[LevelHelperLoader dontStretchArt];

		//create a LevelHelperLoader object that has the data of the specified level
		_levelLoader = [[LevelHelperLoader alloc] initWithContentOfFile:[NSString stringWithFormat:@"Levels/Empty"]];
		
		//create all objects from the level file and adds them to the cocos2d layer (self)
		[_levelLoader addObjectsToWorld:_world cocos2dLayer:self];

		_levelSize = winSize.width < _levelLoader.gameWorldSize.size.width ? _levelLoader.gameWorldSize.size : winSize;
		DebugLog(@"Level size: %f x %f", _levelSize.width, _levelSize.height);

		_mainLayer = [_levelLoader layerWithUniqueName:@"MAIN_LAYER"];

		//checks if the level has physics boundaries
		if([_levelLoader hasPhysicBoundaries]) {
			//if it does, it will create the physic boundaries
			[_levelLoader createPhysicBoundaries:_world];
		}	

		// init physics
		[self initPhysics];

		[self testMovement];
		
		[self scheduleUpdate];
	}
	return self;
}

-(void) initPhysics {
	DebugLog(@"Initializing physics...");

	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	_world = new b2World(gravity);
	
	
	// Do we want to let bodies sleep?
	_world->SetAllowSleeping(true);
	
	_world->SetContinuousPhysics(true);
}

-(void)testMovement {
	
	DebugLog(@"Drawing background...");
	
	//draw the background tiles
	LHSprite* sandTile = [_levelLoader createSpriteWithName:@"4-7" fromSheet:@"Tiles" fromSHFile:@"OutlawSprites" parent:_mainLayer];
	for(int x = -sandTile.boundingBox.size.width/2; x < _levelSize.width + sandTile.boundingBox.size.width/2; ) {
		for(int y = -sandTile.boundingBox.size.height/2; y < _levelSize.height + sandTile.boundingBox.size.width/2; ) {
			LHSprite* sandTile = [_levelLoader createSpriteWithName:@"4-7" fromSheet:@"Tiles" fromSHFile:@"OutlawSprites" parent:_mainLayer];
			[sandTile setZOrder:0];
			[sandTile transformPosition:ccp(x,y)];
			y+= sandTile.boundingBox.size.height;
		}
		x+= sandTile.boundingBox.size.width;
	}
	[sandTile removeSelf];
	
	
	_playerSprite = [_levelLoader createSpriteWithName:@"19-11" fromSheet:@"Tiles" fromSHFile:@"OutlawSprites" parent:_mainLayer];
	[_playerSprite transformPosition:ccp(_levelSize.width/2, 100)];
	
	
}

-(void) draw {
	[super draw];
}

-(void) update: (ccTime) dt {
	
	_fixedTimestepAccumulator+= dt;
	//DebugLog(@"dt = %f, _fixedTimestepAccumulator = %f", dt, _fixedTimestepAccumulator);
	
	//dynamically set this guy
	const int BASELINE_MAX_STEPS = [ConfigManager intForKey:CONFIG_SIMULATION_MAX_STEPS];
	static float maxSteps = BASELINE_MAX_STEPS;
	
	const double stepSize = [ConfigManager doubleForKey:CONFIG_SIMULATION_STEP_SIZE];
	const int steps = _fixedTimestepAccumulator / stepSize;
		
	if (steps > 0) {

		const int stepsClamped = MIN(steps, (int)maxSteps);
        _fixedTimestepAccumulator-= (stepsClamped * stepSize);
	 
		for (int i = 0; i < stepsClamped; i++) {
			[self singleUpdateStep:stepSize];
		}
		
	}else {
		//no step - we're just too dang fast!
	}
}

-(void) singleUpdateStep:(ccTime) dt {
	
	//DebugLog(@"singleUpdateStep. _fixedTimestepAccumulator = %f", _fixedTimestepAccumulator);

	const static int32 velocityIterations = 8;
	const static int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	_world->Step(dt, velocityIterations, positionIterations);
	
	
	if(_isMoving) {
		[_playerSprite transformPosition:ccpAdd(_movementVector, _playerSprite.position)];
	}
}



- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	_numTouchesOnScreen+= [touches count];
	
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		if(location.x < 200*SCALING_FACTOR_H && location.y < 200*SCALING_FACTOR_V) {
			//touching joystick
			_isMoving = true;
			_movementVector = ccp(0,0);
			_joystickCenter = location;
		}
	}
	
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {

	//Add a new body/atlas sprite at the touched location
	for( UITouch *touch in touches ) {
		CGPoint location = [touch locationInView: [touch view]];
		
		location = [[CCDirector sharedDirector] convertToGL: location];
		
		if(location.x < 200*SCALING_FACTOR_H && location.y < 200*SCALING_FACTOR_V) {
			//touching joystick

			_movementVector = ccpNormalize(ccpSub(location, _joystickCenter));
		}
		DebugLog(@"Movement vector: %@", NSStringFromCGPoint(_movementVector));		
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	_numTouchesOnScreen-= [touches count];
	if(_numTouchesOnScreen <= 0) {
		_numTouchesOnScreen = 0;
		_isMoving = false;
	}
}




-(void) onEnter {
	[super onEnter];
}


-(void) onExit {
	if(DEBUG_MEMORY) DebugLog(@"HelloWorldLayer onExit");

	for(LHSprite* sprite in _levelLoader.allSprites) {
		[sprite stopAnimation];
	}
	
	[super onExit];
}

-(void) dealloc {
	if(DEBUG_MEMORY) DebugLog(@"HelloWorldLayer dealloc");
	if(DEBUG_MEMORY) report_memory();
	
	[_levelLoader removeAllPhysics];
	[_levelLoader release];
	_levelLoader = nil;

	delete _world;
	_world = NULL;
			
	[super dealloc];
	
	if(DEBUG_MEMORY) DebugLog(@"End HelloWorldLayer dealloc");
	if(DEBUG_MEMORY) report_memory();
}


@end
