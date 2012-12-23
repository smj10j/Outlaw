//
//  Analytics.mm
//
//  Created by Stephen Johnson on 10/29/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#include "Common.h"
#include "Analytics.h"
#include "Flurry.h"

@implementation Analytics


+(void)startAnalytics {
#if DISTRIBUTION_MODE
	//[Flurry setDebugLogEnabled:true];
	//[Flurry setShowErrorInLogEnabled:true];
	[Flurry setEventLoggingEnabled:true];
	[Flurry startSession:FLURRY_API_KEY];
#endif
}

+(void)setUserId:(NSString*)userId {
#if DISTRIBUTION_MODE
	[Flurry setUserID:userId];
#endif
}

+(void)logEvent:(NSString*)eventName {
#if DISTRIBUTION_MODE
	[Flurry logEvent:eventName];
#endif
}

+(void)logEvent:(NSString*)eventName withParameters:(NSDictionary*)parameters timed:(bool)timed {
#if DISTRIBUTION_MODE
	[Flurry logEvent:eventName withParameters:[self massageDictionaryForFlurry:parameters] timed:timed];
#endif
}

+(void)logEvent:(NSString*)eventName withParameters:(NSDictionary*)parameters {
#if DISTRIBUTION_MODE
	[Flurry logEvent:eventName withParameters:[self massageDictionaryForFlurry:parameters]];
#endif
}

+(void)logError:(NSString*)error message:(NSString*)message exception:(NSException*)exception {
#if DISTRIBUTION_MODE
	[Flurry logError:error message:message exception:exception];
#endif
}

+(void)endTimedEvent:(NSString*)eventName withParameters:(NSDictionary*)parameters {
#if DISTRIBUTION_MODE
	[Flurry endTimedEvent:eventName withParameters:[self massageDictionaryForFlurry:parameters]];
#endif
}

//converts all NS objects to NSString (why Flurry can't do this themselves is beyond me)
+(NSDictionary*)massageDictionaryForFlurry:(NSDictionary*)dictionaryIn {
	NSMutableDictionary* dictionaryOut = [NSMutableDictionary dictionaryWithDictionary:dictionaryIn];
	
	for(id key in dictionaryIn) {
		[dictionaryOut setObject:[NSString stringWithFormat:@"%@", [dictionaryIn objectForKey:key]] forKey:key];
	}
	
	return dictionaryOut;
}


@end
