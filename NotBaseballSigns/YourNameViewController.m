//
//  YourNameViewController.m
//  NotBaseballSigns
//
//  Created by John  Seubert on 9/6/17.
//  Copyright © 2017 John Seubert. All rights reserved.
//

#import <CloudKit/CloudKit.h>
#import "YourNameViewController.h"
#import "TargetNameViewController.h"

#import <JSBaseFramework/UIViewController+Alerts.h>

NSString * const CurrentNameKey = @"CurrentNameKey";

@interface YourNameViewController ()

@end

@implementation YourNameViewController

- (void)viewDidLoad {
    self.keyString = CurrentNameKey;
    
    [super viewDidLoad];
    
    self.title = @"Who are you?";
    self.textField.placeholder = @"Your Code Name";
}

- (void)nextVC:(BOOL)animated {

    
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError *error) {
        if (accountStatus == CKAccountStatusNoAccount) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sign in to iCloud"
                                                                           message:@"Sign in to your iCloud account to write records. On the Home screen, launch Settings, tap iCloud, and enter your Apple ID. Turn iCloud Drive on. If you don't have an iCloud account, tap Create a new Apple ID."
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"Okay"
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            [self addNameToICloud:animated];
            
        }
    }];
}

- (void)addNameToICloud:(BOOL)animated {
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:[[NSUserDefaults standardUserDefaults] stringForKey:self.keyString]];
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    [publicDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord *recordReturned, NSError *error) {
        if (error) {
            //No record found add it
            if(error.code == 11) {
                // Error handling for failed fetch from public database
                //Create name record
                CKRecord *record = [[CKRecord alloc] initWithRecordType:@"Name" recordID:recordID];
                [record setObject:[[NSUserDefaults standardUserDefaults] stringForKey:self.keyString] forKey:@"coachID"];
                [record setObject:@"" forKey:@"message"];
                
                //Save record
                CKContainer *myContainer = [CKContainer defaultContainer];
                CKDatabase *publicDatabase = [myContainer publicCloudDatabase];
                [publicDatabase saveRecord:record completionHandler:^(CKRecord *artworkRecord, NSError *error){
                    [self subscribe];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Insert successfully saved record code
                        TargetNameViewController *vc = [[TargetNameViewController alloc] init];
                        [self.navigationController pushViewController:vc animated:animated];
                    });
                    if (error) {
                        // Insert error handling
                        return;
                    }
                }];
            } else {
                
            }
        } else {
            [self subscribe];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Insert successfully saved record code
                TargetNameViewController *vc = [[TargetNameViewController alloc] init];
                [self.navigationController pushViewController:vc animated:animated];
            });
        }
    }];

    

}

- (void)subscribe {
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    //Remove Old Subsriptions
    [publicDatabase fetchAllSubscriptionsWithCompletionHandler:^(NSArray<CKSubscription *> * _Nullable subscriptions, NSError * _Nullable error) {
        NSMutableArray *subscriptionIDs = [[NSMutableArray alloc] init];
        for(CKSubscription *subscription in subscriptions) {
            [subscriptionIDs addObject:subscription.subscriptionID];
        }
        CKModifySubscriptionsOperation *operation = [[CKModifySubscriptionsOperation alloc] initWithSubscriptionsToSave:nil subscriptionIDsToDelete:subscriptionIDs];
        operation.allowsCellularAccess = YES;
        operation.qualityOfService = NSQualityOfServiceDefault;
        operation.modifySubscriptionsCompletionBlock = ^(NSArray<CKSubscription *> * _Nullable savedSubscriptions, NSArray<NSString *> * _Nullable deletedSubscriptionIDs, NSError * _Nullable operationError) {
            //CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:[[NSUserDefaults standardUserDefaults] stringForKey:self.keyString]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"coachID = %@", [[NSUserDefaults standardUserDefaults] stringForKey:self.keyString]];
            
            CKSubscription *subscription = [[CKQuerySubscription alloc] initWithRecordType:@"Name"
                                                                                 predicate:predicate
                                                                                   options:CKQuerySubscriptionOptionsFiresOnRecordUpdate];
            
            CKNotificationInfo *notificationInfo = [CKNotificationInfo new];
            notificationInfo.alertLocalizationKey = @"WOWWOWOWOW";
            notificationInfo.shouldBadge = NO;
            notificationInfo.desiredKeys = @[@"message"];
            
            subscription.notificationInfo = notificationInfo;
            
            [publicDatabase saveSubscription:subscription
                           completionHandler:^(CKSubscription *subscription, NSError *error) {
                               if (error) {
                                   // insert error handling
                               }
                           }];
        };
        
        [publicDatabase addOperation:operation];
    }];
}

@end
