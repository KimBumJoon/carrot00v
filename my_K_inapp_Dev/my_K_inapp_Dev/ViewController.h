//
//  ViewController.h
//  my_K_inapp_Dev
//
//  Created by kbsmedia on 2017. 3. 15..
//  Copyright © 2017년 kbsmedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import <StoreKit/SKProduct.h>
#import <StoreKit/SKPaymentQueue.h>
#import <StoreKit/SKPaymentTransaction.h>

@interface ViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver, UITableViewDelegate, UITableViewDataSource>

{
    NSArray *arrProductName, *arrProductID;
    
}
@end

