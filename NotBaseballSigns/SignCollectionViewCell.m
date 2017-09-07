//
//  SignCollectionViewCell.m
//  NotBaseballSigns
//
//  Created by John  Seubert on 9/6/17.
//  Copyright © 2017 John Seubert. All rights reserved.
//

#import "SignCollectionViewCell.h"

#import <UIView+Size.h>


@interface SignCollectionViewCell ()


@end

@implementation SignCollectionViewCell
- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.numberOfLines = 0;
        [self.contentView addSubview:self.textLabel];
        
       
        self.imageView = [[UIImageView alloc] initWithImage:nil];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}


- (void)layoutSubviews {
    CGFloat padding = 10;
    
    self.imageView.frame = CGRectMake(padding, padding, self.contentView.height - padding*2, self.contentView.height - padding*2);
    
    self.textLabel.frame = CGRectMake(padding + self.imageView.end, padding, self.contentView.width - self.imageView.width - (padding *3), self.contentView.height - padding*2);
}
@end
