//
//  BootScene.mm
//  Outlaw
//
//  Created by Stephen Johnson on 12/23/12.
//  Copyright Conquer LLC 2012. All rights reserved.
//


// Import the interfaces
#import "BootScene.h"
#import "GameScene.h"
#import "SimpleAudioEngine.h"
#import "IAPManager.h"

@implementation BootScene

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BootScene *layer = [BootScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//
-(id) init
{
	if( (self=[super init])) {
		
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			if(IS_STUPID_IPHONE_5) {
				background = [CCSprite spriteWithFile:@"Default-568h@2x.png"];
			}else {
				background = [CCSprite spriteWithFile:@"Default.png"];
			}
			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);
		
		// add the label as a child to this Layer
		[self addChild: background];
		
		
/*
		//IAP Be Slow - get the ball rolling
		//100 coins
		IAPManager* iapManager = [[IAPManager alloc] init];
		[iapManager requestProduct:IAP_PACKAGE_ID_1 successCallback:^(NSString* productPrice){
			if(DEBUG_IAP) DebugLog(@"Requested IAP product successfully!");
		}];
		[iapManager release];
*/

/*
		// *********** Sound Settings ************
		[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.40f];
		[[SimpleAudioEngine sharedEngine] setEffectsVolume:0.80f];
		[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"sounds/menu/ambient/theme.mp3"];
*/
		
		double lastRun = [SettingsManager doubleForKey:SETTING_LAST_RUN_TIMESTAMP];
		DebugLog(@"Last run was: %f", lastRun);
		
		//INITIAL SETTINGS TIME!!
		if(lastRun == 0) {
			//first run
			
			//set up the default user preferences
			[SettingsManager setBool:true forKey:SETTING_SOUND_ENABLED];
			[SettingsManager setBool:true forKey:SETTING_MUSIC_ENABLED];
			[SettingsManager setInt:1 forKey:SETTING_NUM_APP_OPENS];

			//TODO: do any other first-run logic here
		}		
		
		[Analytics setUserId:[SettingsManager getUUID]];
		DebugLog(@"Launching with uuid=%@", [SettingsManager getUUID]);
		
		//set our current version (can be used in future version to test for update
		NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
		NSString* version = [infoDict objectForKey:@"CFBundleShortVersionString"];
		[SettingsManager setString:version forKey:SETTING_CURRENT_VERSION];
		if(DEBUG_SETTINGS) DebugLog(@"Updated Current Version setting to %@", version);
		
		//set our boot time (can be used for applying settings on updates
		[SettingsManager setDouble:[[NSDate date] timeIntervalSince1970] forKey:SETTING_LAST_RUN_TIMESTAMP];
		[SettingsManager incrementIntBy:1 forKey:SETTING_NUM_APP_OPENS];
		
		
		
		
		//TODO: clear any settings that need to be reset on each app load here
		
		
	}
	
	return self;
}

-(void) onEnter {
	[super onEnter];
	[self scheduleOnce:@selector(showMainLayer) delay:(DEVICE_BUILD ? 1.0f : 0.0f)];
}

-(void)showMainLayer {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFadeBL transitionWithDuration:0.5 scene:[GameScene scene]]];
}

-(void) onExit {
	[super onExit];
	if(DEBUG_MEMORY) DebugLog(@"BootLayer onExit");
}

@end
