//
//  SettingsManager.mm
//
//  Created by Stephen Johnson on 10/25/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#import "Common.h"
#import "SettingsManager.h"
#import "SSKeychain.h"
#import "Analytics.h"


@implementation SettingsManager


+(NSMutableDictionary*)loadSettings {
	static NSMutableDictionary* sSettings = nil;
	if(sSettings == nil) {
		NSString* rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		NSString* settingsPlistPath = [rootPath stringByAppendingPathComponent:@"UserSettings.plist"];
		sSettings = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPlistPath];
		if(sSettings == nil) {
			sSettings = [[NSMutableDictionary alloc] init];
		}
		if(DEBUG_SETTINGS) DebugLog(@"Loaded user settings from %@", settingsPlistPath);
	}
	return sSettings;
}

+(void)saveSettings {
	//write to file!
	NSString* rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString* settingsPlistPath = [rootPath stringByAppendingPathComponent:@"UserSettings.plist"];
	NSMutableDictionary* settings = [self loadSettings];

	if(![settings writeToFile:settingsPlistPath atomically: YES]) {
        DebugLog(@"---- Failed to save user settings!! - %@ -----", settingsPlistPath);
        return;
    }
	if(DEBUG_SETTINGS) DebugLog(@"Saved user settings");
}




+(id)objectForKey:(NSString*)key {
	NSMutableDictionary* settings = [self loadSettings];
	if(DEBUG_SETTINGS) DebugLog(@"Loading settings value for key %@", key);
	return [settings objectForKey:key];
}
+(NSString*)stringForKey:(NSString*)key {
	return [self objectForKey:key];
}
+(bool)boolForKey:(NSString*)key {
	id value = [self objectForKey:key];
	return value == nil ? nil : [((NSNumber*)value) boolValue];
}
+(int)intForKey:(NSString*)key {
	id value = [self objectForKey:key];
	return value == nil ? nil :  [((NSNumber*)value) intValue];
}
+(double)doubleForKey:(NSString*)key {
	id value = [self objectForKey:key];
	return value == nil ? nil :  [((NSNumber*)value) doubleValue];
}




+(void)setObject:(id)value forKey:(NSString*)key {
	NSMutableDictionary* settings = [self loadSettings];
	if(value != nil) {
		[settings setObject:value forKey:key];
	}else {
		[settings removeObjectForKey:key];
	}
	[self saveSettings];
}

+(void)remove:(NSString*)key {
	[self setObject:nil forKey:key];
}
+(void)setString:(NSString*)value forKey:(NSString*)key {
	[self setObject:[NSString stringWithString:value] forKey:key];
}
+(void)setBool:(bool)value forKey:(NSString*)key {
	[self setObject:[NSNumber numberWithBool:value] forKey:key];
}
+(void)setInt:(int)value forKey:(NSString*)key {
	[self setObject:[NSNumber numberWithInt:value] forKey:key];
}
+(void)setDouble:(double)value forKey:(NSString*)key {
	[self setObject:[NSNumber numberWithDouble:value] forKey:key];
}


+(int)incrementIntBy:(int)amount forKey:(NSString*)key {
	if(amount != 0) [self setInt:[self intForKey:key]+amount forKey:key];
	return [self intForKey:key];
}

+(int)decrementIntBy:(int)amount forKey:(NSString*)key {
	if(amount != 0) [self setInt:[self intForKey:key]-amount forKey:key];
	return [self intForKey:key];
}



+(NSArray*)keysWithPrefix:(NSString*)prefix {
	NSMutableDictionary* settings = [self loadSettings];
	NSMutableArray* keys = [[[NSMutableArray alloc] init] autorelease];
	for(NSString* key in settings) {
		if([key hasPrefix:prefix]) {
			[keys addObject:key];
		}
	}
	return keys;
}



+(NSString*)getUUID {

	NSString* UUID = [self stringForKey:SETTING_UUID];
	
	if(UUID == nil) {
		//create a user id
	
		//first see if the userId is in the keychain
		NSError *error = nil;
		UUID = [SSKeychain passwordForService:COMPANY_IDENTIFIER account:@"user" error:&error];
		if (error != nil) {
			DebugLog(@"@@@@ ERROR SSKeychain passwordForService error code: %d", [error code]);
		}
		if(UUID == nil) {

			CFUUIDRef cfUUID = CFUUIDCreate(NULL);
			CFStringRef strUUUID = CFUUIDCreateString(NULL, cfUUID);
			CFRelease(cfUUID);
			UUID = (NSString*)strUUUID;
			DebugLog(@"Created a new uuid");
							
			//store the userId to the keychain
			error = nil;
			[SSKeychain setPassword:UUID forService:COMPANY_IDENTIFIER account:@"user" error:&error];
			if (error!= nil) {
				DebugLog(@"@@@@ ERROR SSKeychain setPassword error code: %d", [error code]);
			}
			
		}else {
			DebugLog(@"Retrieved uuid from the keychain!");
		}
		[self setString:UUID forKey:SETTING_UUID];
					
		//TODO: also store this to iCloud: refer to: http://stackoverflow.com/questions/7273014/ios-unique-user-identifier
		/*
			To make sure ALL devices have the same UUID in the Keychain.

			Setup your app to use iCloud.
			Save the UUID that is in the Keychain to NSUserDefaults as well.
			Pass the UUID in NSUserDefaults to the Cloud with Key-Value Data Store.
			On App first run, Check if the Cloud Data is available and set the UUID in the Keychain on the New Device.
		*/
	}
	
	
	return UUID;
}



+(void)sendToFacebookPage {
	[SettingsManager setString:[SettingsManager stringForKey:SETTING_CURRENT_VERSION] forKey:SETTING_LIKED_FACEBOOK_VERSION];

	NSString* escapedValue = [FACEBOOK_PAGE_URL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *escStr = [escapedValue stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSURL *url = [NSURL URLWithString:escStr];
	[[UIApplication sharedApplication] openURL:url];
}

+(void)promptForAppReview:(NSString*)message {
	[SettingsManager incrementIntBy:1 forKey:SETTING_NUM_REVIEW_PROMPTS];
	if(DEBUG_REVIEWS) DebugLog(@"This is the %d time we've asked for a review", [SettingsManager intForKey:SETTING_NUM_REVIEW_PROMPTS]);
	UIAlertView* reviewPromptAlert = [[UIAlertView alloc] initWithTitle:@"Rate Me?"
		message:[NSString stringWithFormat:@"%@Let us know what you think about Save Penguin so we can improve and keep building more levels!", message == nil ? @"" : [NSString stringWithFormat:@"%@ ", message]]
		delegate:self cancelButtonTitle:@"Not Now" otherButtonTitles:@"Okay!",nil];
	reviewPromptAlert.tag = REVIEW_PROMPT_TAG;
	[reviewPromptAlert show];	
}

+(void)sendToAppReviewPage {
	[SettingsManager setString:[SettingsManager stringForKey:SETTING_CURRENT_VERSION] forKey:SETTING_LEFT_REVIEW_VERSION];

	NSString* escapedValue = [APP_STORE_REVIEW_URL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *escStr = [escapedValue stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
	NSURL *url = [NSURL URLWithString:escStr];
	[[UIApplication sharedApplication] openURL:url];
}

+(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == REVIEW_PROMPT_TAG) {
	
		bool accept = buttonIndex == 1;
	
		//analytics logging
		NSDictionary* flurryParams = [NSDictionary dictionaryWithObjectsAndKeys:
			[SettingsManager stringForKey:SETTING_CURRENT_VERSION], @"App_Version",
			[NSNumber numberWithInt:[SettingsManager intForKey:SETTING_NUM_REVIEW_PROMPTS]], @"Num_Review_Prompts",
		nil];
		[Analytics logEvent:[NSString stringWithFormat:@"ReviewRequest_%@", (accept ? @"Accepted" : @"Rejected")] withParameters:flurryParams];
	
		if(accept) {
			[self sendToAppReviewPage];
		}
	}
}


@end

