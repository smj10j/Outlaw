//
//  IAPManager.mm
//
//  Created by Stephen Johnson on 10/25/12.
//  Copyright (c) 2012 Conquer LLC. All rights reserved.
//

#import "Common.h"
#import "IAPManager.h"
#import "SettingsManager.h"
#import "EBPurchase.h"
#import "Analytics.h"


@implementation IAPManager

-(id)init {
	
	if(self = [super init]) {

		_ebPurchase = [[EBPurchase alloc] init];
		_ebPurchase.delegate = self;
		
		_loadingIndicator = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		_loadingIndicator.center=[[CCDirector sharedDirector] view].center;
		_loadingIndicator.hidesWhenStopped = true;
		[[[CCDirector sharedDirector] view] addSubview:_loadingIndicator];
		
	}
	
	return self;
}

-(SKProduct*)selectedProduct {
	return _ebPurchase.validProduct;
}

-(void)clearSelectedProduct {
	if(_ebPurchase.validProduct != nil) {
		[_ebPurchase.validProduct release];
		_ebPurchase.validProduct = nil;
	}
}

-(bool)purchase:(SKProduct*)product successCallback:(void(^)(bool))successCallback {
	
	if(product == nil) {
		return false;
	}
	
	if(_purchaseSuccessCallback != nil) {
		[_purchaseSuccessCallback release];
		_purchaseSuccessCallback = nil;
	}
	_purchaseSuccessCallback = [[successCallback copy]retain];
	
	
	
	bool enabled = [_ebPurchase purchaseProduct:product];
	
	if(enabled) {
		[_loadingIndicator startAnimating];
		return true;
	}
	return false;
}

-(bool)requestProduct:(NSString*)productId successCallback:(void(^)(NSString*))successCallback {

	if(_requestSuccessCallback != nil) {
		[_requestSuccessCallback release];
		_requestSuccessCallback = nil;
	}
	_requestSuccessCallback = [[successCallback copy]retain];

	return [_ebPurchase requestProduct:productId];
}

-(void)dealloc {

	_ebPurchase.delegate = nil;
	[_ebPurchase release];
	
	if(_purchaseSuccessCallback != nil) {
		[_purchaseSuccessCallback release];
		_purchaseSuccessCallback = nil;
	}
	if(_requestSuccessCallback != nil) {
		[_requestSuccessCallback release];
		_requestSuccessCallback = nil;
	}
	
	[_loadingIndicator removeFromSuperview];
	[_loadingIndicator release];

	[super dealloc];
}






















#pragma mark -
#pragma mark EBPurchaseDelegate Methods

-(void) requestedProduct:(EBPurchase*)ebp identifier:(NSString*)productId name:(NSString*)productName price:(NSString*)productPrice description:(NSString*)productDescription 
{
    
    if (productPrice != nil) 
    {
		if(DEBUG_IAP) DebugLog(@"IAPManager requestedProduct is available");
        // Product is available, so update button title with price.
        if(_requestSuccessCallback != nil) {
			_requestSuccessCallback(productPrice);
			[_requestSuccessCallback release];
			_requestSuccessCallback = nil;
		}
		
    } else {
        // Product is NOT available in the App Store, so notify user.
		if(DEBUG_IAP) DebugLog(@"IAPManager requestedProduct is unavailable");
        
		/*
        UIAlertView *unavailAlert = [[UIAlertView alloc] initWithTitle:@"Not Available" message:@"This In-App Purchase item is not available in the App Store at this time. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [unavailAlert show];
        [unavailAlert release];
		*/
    }
}

-(void) successfulPurchase:(EBPurchase*)ebp restored:(bool)isRestore identifier:(NSString*)productId receipt:(NSData*)transactionReceipt 
{
    if(DEBUG_IAP) DebugLog(@"IAPManager successfulPurchase");
	[_loadingIndicator stopAnimating];
   
    // Purchase or Restore request was successful, so...
    // 1 - Unlock the purchased content for your new customer!
    // 2 - Notify the user that the transaction was successful.
    
                
	//-------------------------------------
	
	// 1 - Unlock the purchased content and update the app's stored settings.

	//-------------------------------------

	// 2 - Notify the user that the transaction was successful.
	
	
	if(_purchaseSuccessCallback != nil) {
		//purchase or restore
		_purchaseSuccessCallback(isRestore);
		[_purchaseSuccessCallback release];
		_purchaseSuccessCallback = nil;
	}else {
		//restore for sure
		
		NSString *alertMessage = [NSString stringWithFormat:@"Your purchase for %@ was restored. Enjoy!", ebp.validProduct.localizedTitle];
		UIAlertView *updatedAlert = [[UIAlertView alloc] initWithTitle:@"Thank You!" message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[updatedAlert show];
		[updatedAlert release];			

	}
}




//cleanup
-(void) removedTransactions:(EBPurchase*)ebp {
	[_loadingIndicator stopAnimating];
}

//failure states

-(void) failedPurchase:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage 
{
    if(DEBUG_IAP) DebugLog(@"IAPManager failedPurchase");
	[_loadingIndicator stopAnimating];
    
    // Purchase or Restore request failed or was cancelled, so notify the user.
    
    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Purchase Stopped" message:@"Either you cancelled the request or Apple reported a transaction error. Please try again later, or contact our customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
    [failedAlert release];
}

-(void) incompleteRestore:(EBPurchase*)ebp 
{
    if(DEBUG_IAP) DebugLog(@"IAPManager incompleteRestore");
	[_loadingIndicator stopAnimating];
    
    // Restore queue did not include any transactions, so either the user has not yet made a purchase
    // or the user's prior purchase is unavailable, so notify user to make a purchase within the app.
    // If the user previously purchased the item, they will NOT be re-charged again, but it should 
    // restore their purchase. 
    
    UIAlertView *restoreAlert = [[UIAlertView alloc] initWithTitle:@"Restore Issue" message:@"A prior purchase transaction could not be found. To restore the purchased product, tap the Buy button. Paid customers will NOT be charged again, but the purchase will be restored." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [restoreAlert show];
    [restoreAlert release];
}

-(void) failedRestore:(EBPurchase*)ebp error:(NSInteger)errorCode message:(NSString*)errorMessage 
{
    if(DEBUG_IAP) DebugLog(@"IAPManager failedRestore");
	[_loadingIndicator stopAnimating];
    
    // Restore request failed or was cancelled, so notify the user.

    UIAlertView *failedAlert = [[UIAlertView alloc] initWithTitle:@"Restore Stopped" message:@"Either you cancelled the request or your prior purchase could not be restored. Please try again later, or contact our customer support for assistance." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [failedAlert show];
    [failedAlert release];
}






@end

