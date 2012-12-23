//
//  SettingsManager.h
//
//  Created by Stephen Johnson on 10/25/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//


#ifndef Outlaw_SettingsManager_h
#define Outlaw_SettingsManager_h

@interface SettingsManager : NSObject


+(bool)boolForKey:(NSString*)key;
+(NSString*)stringForKey:(NSString*)key;
+(int)intForKey:(NSString*)key;
+(double)doubleForKey:(NSString*)key;

+(NSString*)getUUID;


+(void)setString:(NSString*)value forKey:(NSString*)key;
+(void)setBool:(bool)value forKey:(NSString*)key;
+(void)setInt:(int)value forKey:(NSString*)key;
+(void)setDouble:(double)value forKey:(NSString*)key;

+(int)incrementIntBy:(int)amount forKey:(NSString*)key;
+(int)decrementIntBy:(int)amount forKey:(NSString*)key;


+(void)remove:(NSString*)key;


+(NSArray*)keysWithPrefix:(NSString*)prefix;




+(void)promptForAppReview:(NSString*)message;
+(void)sendToAppReviewPage;

+(void)sendToFacebookPage;


@end






#define SETTING_UUID @"UUID"
#define SETTING_SOUND_ENABLED @"SoundEnabled"
#define SETTING_MUSIC_ENABLED @"MusicEnabled"

#define SETTING_LAST_RUN_TIMESTAMP @"LastRunTimestamp"
#define SETTING_NUM_APP_OPENS @"NumAppOpens"

#define SETTING_CURRENT_VERSION @"CurrentVersion"

#define SETTING_NUM_REVIEW_PROMPTS @"NumReviewPrompts"
#define SETTING_LEFT_REVIEW_VERSION @"LeftReviewVersion"

#define SETTING_LIKED_FACEBOOK_VERSION @"LikedFacebookVersion"




#define REVIEW_PROMPT_TAG 0



#endif
