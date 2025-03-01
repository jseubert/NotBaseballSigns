//
//  ViewController.m
//  NotBaseballSigns
//
//  Created by John  Seubert on 9/6/17.
//  Copyright © 2017 John Seubert. All rights reserved.
//

#import "InputViewController.h"

#import <JSBaseFramework/UILabel+Size.h>
#import <JSBaseFramework/UIView+Size.h>
#import <JSBaseFramework/UIColor+Defaults.h>
#import <JSBaseFramework/UIViewController+Alerts.h>

@interface InputViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;


@end

@implementation InputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:self action:@selector(tappedSubmitButton:)] ;
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel.numberOfLines = 0;
    [self.view addSubview:self.descriptionLabel];
    
    self.textField = [[UITextField alloc] init];
    self.textField.userInteractionEnabled = YES;
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.backgroundColor = [UIColor collectionViewBackgroundColor];
    self.textField.layer.cornerRadius = 10;
    self.textField.delegate = self;
    [self.view addSubview:self.textField];
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(tappedSubmitButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator sizeToFit];
    self.activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator.color = [UIColor darkGrayColor];
    [self.view addSubview:self.activityIndicator];
    
    NSString *currentName = [[NSUserDefaults standardUserDefaults] stringForKey:self.keyString];
    if(currentName && currentName.length > 0) {
        self.textField.text = currentName;
       // [self nextVC:NO];
    }
    
}

- (void)loading:(BOOL)loading {
    if(loading) {
        [self.activityIndicator startAnimating];
    } else {
        [self.activityIndicator stopAnimating];
    }
    self.submitButton.userInteractionEnabled = !loading;
    self.textField.userInteractionEnabled = !loading;
    self.navigationItem.rightBarButtonItem.enabled = !loading;
}


- (void)tappedSubmitButton:(UIButton *)sender {
    [self loading:YES];
    NSString *name = self.textField.text;
    if(name && name.length > 0) {
        [self.textField resignFirstResponder];
        [[NSUserDefaults standardUserDefaults] setObject:[name lowercaseString] forKey:self.keyString];
        [self nextVC:YES];
    } else {
        [self loading:NO];
        [self showErrorAlertWithTitle:@"Error" message:@"Enter a valid name"];
    }
}

- (void)nextVC:(BOOL)animated {
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat padding = 10;
    CGSize textSize;
    CGFloat y = padding;
    
    textSize = [self.descriptionLabel sizeOfLabelWithWithWidth:self.view.width - padding*2];
    self.descriptionLabel.frame = CGRectMake(padding, y, self.view.width - padding*2, textSize.height);
    
    y = self.descriptionLabel.bottom + padding;
    
    self.textField.frame = CGRectMake(padding, y, self.view.width - padding*2, self.textField.font.lineHeight + (padding * 2));
    
    y = self.textField.bottom + padding;
    
    textSize = [self.submitButton.titleLabel sizeOfLabelWithWithWidth:self.view.width - padding*2];
    self.submitButton.frame = CGRectMake(padding, y, self.view.width - padding*2, textSize.height + padding*2);
    
    self.activityIndicator.center = self.view.center;
}


- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string rangeOfCharacterFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].location != NSNotFound) {
        return NO;
    }
    
    if([string rangeOfCharacterFromSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]].location != NSNotFound) {
        return NO;
    }
    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    return newLength <= 20 || returnKey;
}

@end
