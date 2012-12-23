//
//  HelloWorldLayer.h
//  Outlaw
//
//  Created by Stephen Johnson on 12/23/12.
//  Copyright Conquer LLC 2012. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "Common.h"
#include "Box2D.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer
{	
	b2World* _world;					// strong ref

}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
