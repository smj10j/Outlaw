//
//  ConfigManager.mm
//  Outlaw
//
//  Created by Stephen Johnson on 12/23/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#import "Common.h"
#import "ConfigManager.h"

@implementation ConfigManager


+(NSMutableDictionary*)loadConfig {
	static NSMutableDictionary* sConfig = nil;
	static long lastConfigReloadSeconds = 0;
	if(sConfig == nil ||
		(MODIFYING_GAME_CONFIG && [[NSDate date] timeIntervalSince1970] - lastConfigReloadSeconds > GAME_CONFIG_REFRESH_RATE)) {
		
		lastConfigReloadSeconds = [[NSDate date] timeIntervalSince1970];
		
		NSString* configPlistPast = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"GameConfig.plist"];
		
		sConfig = [[NSMutableDictionary alloc] initWithContentsOfFile:configPlistPast];
		if(sConfig == nil) {
			sConfig = [[NSMutableDictionary alloc] init];
		}
		if(DEBUG_CONFIG) DebugLog(@"Loaded config from %@", configPlistPast);
	}
	return sConfig;
}







+(id)objectForKey:(NSString*)key {
	NSMutableDictionary* config = [self loadConfig];
	id value = [config objectForKey:key];
	if(DEBUG_CONFIG) DebugLog(@"Loading config value %@ for key %@", value, key);
	return value;
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



@end
