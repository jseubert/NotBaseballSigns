//
//  ViewController.h
//  NotBaseballSigns
//
//  Created by John  Seubert on 9/6/17.
//  Copyright © 2017 John Seubert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputViewController : UIViewController

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, strong) NSString *keyString;

-(void)loading:(BOOL)loading;

@end

