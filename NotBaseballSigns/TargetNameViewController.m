//
//  TargetNameViewController.m
//  NotBaseballSigns
//
//  Created by John  Seubert on 9/6/17.
//  Copyright © 2017 John Seubert. All rights reserved.
//

#import "TargetNameViewController.h"
#import "SelectSignViewController.h"
#import <CloudKit/CloudKit.h>
#import <UIViewController+Alerts.h>

NSString * const TargetNameKey = @"TargetNameKey";

@interface TargetNameViewController ()

@end

@implementation TargetNameViewController

- (void)viewDidLoad {
    self.keyString = TargetNameKey;
    
    [super viewDidLoad];

    self.title = @"Send";
    self.descriptionLabel.text = @"Who are you sending secret not-baseball signs to?";
    self.textField.placeholder = @"Coaches Code Name";
    
}


- (void)nextVC:(BOOL)animated {
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:[[NSUserDefaults standardUserDefaults] stringForKey:self.keyString]];
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    [publicDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord *recordReturned, NSError *error) {
        if (error) {
            if(error.code == 11) {
                dispatch_async(dispatch_get_main_queue(), ^{

                    [self showErrorAlertWithTitle:@"Whoops" message:@"No Coach with that name"];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showErrorAlertView:error];
                });
            }

        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                SelectSignViewController *vc = [[SelectSignViewController alloc] init];
                [self.navigationController pushViewController:vc animated:animated];
            });
        }
    }];

}

@end
