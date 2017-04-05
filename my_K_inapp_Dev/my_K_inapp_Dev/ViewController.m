//
//  ViewController.m
//  my_K_inapp_Dev
//
//  Created by kbsmedia on 2017. 3. 15..
//  Copyright © 2017년 kbsmedia. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    arrProductName = [[NSArray alloc] initWithObjects:@"VOD 10회 시청권",@"VOD 20회 시청권",@"VOD 30회 시청권",@"VOD 1달 정기 이용권", nil];
    arrProductID   = [[NSArray alloc] initWithObjects:@"kr.co.kbs.inapp.consum.vod.10", @"kr.co.kbs.inapp.consum.vod.20", @"kr.co.kbs.inapp.consum.vod.30", @"kr.co.kbs.inapp.renewable.vod.1m", nil];
    
    
    
    
    [self makeSubViews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)makeSubViews
{
//    UIButton *btnPurchase = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btnPurchase.frame = CGRectMake(50, 50, 100, 50);
//    [btnPurchase setTitle:@"구입하기" forState:UIControlStateNormal];
//    [btnPurchase addTarget:self action:@selector(onPurchaseProduct) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:btnPurchase];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 30)];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
}


#pragma mark - TableView Delegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}
//
//- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return @[@"VOD 회차 이용권", @"VOD 정기 이용권"];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrProductName.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *prodID = [arrProductID objectAtIndex:indexPath.row];
    NSSet *prodSet = [NSSet setWithObject:prodID];
    
    [self onPurchaseProduct:prodSet];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"inappTableView";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = [arrProductName objectAtIndex:indexPath.row];
    return cell;
}



#pragma mark - In-app Purchase Payment Delegate
- (void)onPurchaseProduct:(NSSet *)itemID
{
    if([SKPaymentQueue canMakePayments])
    {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
    }
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:itemID];
    
    request.delegate = self;
    [request start];
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"상품 정보 요청");
    
    if( [response.products count] > 0 ) {
        SKProduct *product = [response.products objectAtIndex:0];
        NSLog(@"Title : %@", product.localizedTitle);
        NSLog(@"Description : %@", product.localizedDescription);
        NSLog(@"Price : %@", product.price);
        
        
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    
    if( [response.invalidProductIdentifiers count] > 0 ) {
        NSString *invalidString = [response.invalidProductIdentifiers objectAtIndex:0];
        NSLog(@"Invalid Identifiers : %@", invalidString);
    }
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    
    NSLog(@"SKProduct update");
    NSLog(@"Transaction : %@", transactions);
    
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}


- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"Transaction Complete");
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"Transaction Restore");
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"Transaction Failed");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        // Optionally, display an error here.
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}





@end
