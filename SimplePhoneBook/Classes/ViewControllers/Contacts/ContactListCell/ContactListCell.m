//
//  ContactListCell.m
//  SimplePhoneBook
//
//  Created by oleksandr on 11/7/14.
//  Copyright (c) 2014 OleksandrNechet. All rights reserved.
//

#import "ContactListCell.h"
#import "ContactData.h"

@interface ContactListCell ()
{
    __weak IBOutlet UIImageView *photoImageView;
    __weak IBOutlet UILabel *nameLabel;
    __weak IBOutlet UILabel *phoneLabel;
    __weak IBOutlet UIButton *callButton;
}

@end

@implementation ContactListCell

- (void)setContactData:(ContactData *)contactData
{
    [photoImageView setImage:contactData.photoImage];
    [nameLabel setText:contactData.name];
    if (contactData.phoneNumber)
        [phoneLabel setText:contactData.phoneNumber];
}

- (void)didSwipe:(UISwipeGestureRecognizer *)sgr
{
    phoneLabel.hidden = (sgr.direction == UISwipeGestureRecognizerDirectionRight);
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = callButton.frame;
            if (sgr.direction == UISwipeGestureRecognizerDirectionLeft)
                frame.origin.x = self.frame.size.width - frame.size.width;
            else if (sgr.direction == UISwipeGestureRecognizerDirectionRight)
                frame.origin.x = self.frame.size.width;
            callButton.frame = frame;
        }];
}

- (IBAction)onCall:(UIButton *)sender
{
    NSString *tel = [NSString stringWithFormat:@"tel:%@", phoneLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    photoImageView.layer.cornerRadius = photoImageView.bounds.size.height / 2;
}

@end
