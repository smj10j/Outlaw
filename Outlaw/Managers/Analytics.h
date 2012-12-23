//
//  Analytics.h
//
//  Created by Stephen Johnson on 10/30/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#ifndef Outlaw_Analytics_h
#define Outlaw_Analytics_h

@interface Analytics : NSObject {

}



+(void)startAnalytics;
+(void)setUserId:(NSString*)userId;

+(void)logEvent:(NSString*)eventName;
+(void)logEvent:(NSString*)eventName withParameters:(NSDictionary*)parameters timed:(bool)timed;
+(void)logEvent:(NSString*)eventName withParameters:(NSDictionary*)parameters;
+(void)logError:(NSString*)error message:(NSString*)message exception:(NSException*)exception;
+(void)endTimedEvent:(NSString*)eventName withParameters:(NSDictionary*)parameters;


@end


#endif