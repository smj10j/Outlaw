//
//  IAPManager.h
//
//  Created by Stephen Johnson on 10/25/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//


#ifndef Outlaw_IAPManager_h
#define Outlaw_IAPManager_h


#import "EBPurchase.h"

@interface IAPManager : NSObject <EBPurchaseDelegate> {

	EBPurchase* _ebPurchase;
	
	UIActivityIndicatorView* _loadingIndicator;
	
	__block void(^_purchaseSuccessCallback)(bool);
	__block void(^_requestSuccessCallback)(NSString*);
}

-(SKProduct*)selectedProduct;
-(void)clearSelectedProduct;
-(bool)purchase:(SKProduct*)product successCallback:(void(^)(bool))successCallback;
-(bool)requestProduct:(NSString*)productId successCallback:(void(^)(NSString*))successCallback;

@end


#endif