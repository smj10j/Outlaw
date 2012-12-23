//
//  Common.h
//
//  Created by Stephen Johnson on 11/27/12.
//
//

#ifndef Outlaw_Common_h
#define Outlaw_Common_h

/******************* USER-DEFINABLE ******************/

//prepares all settings for App Store
//NOTE: be sure to set the correct distribution provisioning profile!
#define DISTRIBUTION_BUILD false

//enables TestFlight as well as sets this as a Distribution build
//NOTE: be sure to set the correct distribution provisioning profile!
#define BETA_BUILD (false && !DISTRIBUTION_BUILD)


//opens up the GameConfig.json file on run
#define MODIFYING_GAME_CONFIG (true && !DISTRIBUTION_BUILD)

/******************* END USER-DEFINABLE ******************/







//true to disable all output and send analytics data (DON'T SET THIS DIRECTLY)
#define DEVICE_BUILD (false || BETA_BUILD || DISTRIBUTION_BUILD)




#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_STUPID_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define SCALING_FACTOR_H (IS_IPHONE ? 480.0/1024.0 : 1.0)
#define SCALING_FACTOR_V (IS_IPHONE ? 320.0/768.0 : 1.0)
#define SCALING_FACTOR SCALING_FACTOR_V
#define SCALING_FACTOR_FONTS (IS_IPHONE ? 0.6 : 1.0)



 
/******************* USER-DEFINABLE ******************/

#define TARGET_FPS 60
#define TARGET_PHYSICS_STEP .03

#define DEBUG_ALL_THE_THINGS	( false							 && !DEVICE_BUILD)
#define DEBUG_SETTINGS			((false || DEBUG_ALL_THE_THINGS) && !DEVICE_BUILD)
#define DEBUG_REVIEWS			((false || DEBUG_ALL_THE_THINGS) && !DEVICE_BUILD)
#define DEBUG_IAP				((false || DEBUG_ALL_THE_THINGS) && !DEVICE_BUILD)




#define TESTFLIGHT_API_KEY @"dcb57a9ef2d39552f3b77d6fa6ec3bb0_MTQxOTk2MjAxMi0xMC0xMSAwMjo1NDowMy44OTg4NTk"
#define FLURRY_API_KEY @"DPYDCDRY484SJVZ2D5CN"



/******************* END USER-DEFINABLE ******************/






#if DEVICE_BUILD
#define COCOS2D_DEBUG 0
#else
#define COCOS2D_DEBUG 1
#endif

#if !DISTRIBUTION_MODE
#define DebugLog( s, ... ) NSLog( @"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DebugLog( s, ... )
#endif

#define stringify( name ) # name



// Common includes
#include "cocos2d.h"
#include "Utilities.h"
#include "Analytics.h"
#include "SettingsManager.h"

#endif

