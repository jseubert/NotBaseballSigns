//
//  TargetNameViewController.m
//  NotBaseballSigns
//
//  Created by John  Seubert on 9/6/17.
//  Copyright © 2017 John Seubert. All rights reserved.
//

#import "TargetNameViewController.h"
#import "SelectSignViewController.h"

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
    SelectSignViewController *vc = [[SelectSignViewController alloc] init];
    [self.navigationController pushViewController:vc animated:animated];
}

@end
