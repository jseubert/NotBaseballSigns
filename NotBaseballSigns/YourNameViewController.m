//
//  YourNameViewController.m
//  NotBaseballSigns
//
//  Created by John  Seubert on 9/6/17.
//  Copyright © 2017 John Seubert. All rights reserved.
//

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
    TargetNameViewController *vc = [[TargetNameViewController alloc] init];
    [self.navigationController pushViewController:vc animated:animated];
}

@end
