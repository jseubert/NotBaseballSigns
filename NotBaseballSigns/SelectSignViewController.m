//
//  SelectSignViewController.m
//  NotBaseballSigns
//
//  Created by John  Seubert on 9/6/17.
//  Copyright © 2017 John Seubert. All rights reserved.
//
#import <CloudKit/CloudKit.h>

#import "SelectSignViewController.h"
#import "SignCollectionViewCell.h"

#import <UIColor+Defaults.h>
#import <UIView+Size.h>
#import <UIViewController+Alerts.h>

@interface SelectSignViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>



@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation SelectSignViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Send a Sign";
    self.view.backgroundColor = [UIColor collectionViewBackgroundColor];
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    //collectionViewFlowLayout.minimumLineSpacing = 5;
    //collectionViewFlowLayout.minimumInteritemSpacing = 5;
    collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:collectionViewFlowLayout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor collectionViewBackgroundColor];
    self.collectionView.alwaysBounceVertical = YES;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView registerClass:[SignCollectionViewCell class] forCellWithReuseIdentifier:@"SignCollectionViewCell"];
    
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLayoutSubviews {
    CGFloat padding = 10;
    [super viewDidLayoutSubviews];
    self.collectionView.frame = CGRectMake(padding, 0, self.view.width - (padding*2), self.view.height);
}

#pragma mark -
#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:[[NSUserDefaults standardUserDefaults] stringForKey:@"TargetNameKey"]];
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    [publicDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord *recordReturned, NSError *error) {
        if (error) {
            // Error handling for failed fetch from public database
        }
        else {
            // Modify the record and save it to the database
            [recordReturned setObject:@"Worked!" forKey:@"message"];
            [publicDatabase saveRecord:recordReturned completionHandler:^(CKRecord *savedRecord, NSError *saveError) {
                // Error handling for failed save to public database
                [self showErrorAlertWithTitle:@"WHEE" message:@"Sending"];
            }];
        }
    }];

}





#pragma mark -
#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 50;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SignCollectionViewCell *cell = (SignCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"SignCollectionViewCell" forIndexPath:indexPath];
    cell.textLabel.text = @"Quickie Ball";
    
    return cell;
}

#pragma mark -
#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.width, 70);
}
@end
