//
//  ContactListCell.h
//  SimplePhoneBook
//
//  Created by oleksandr on 11/7/14.
//  Copyright (c) 2014 OleksandrNechet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContactData;
@interface ContactListCell : UITableViewCell

@property (nonatomic, weak) ContactData *contactData;

@end
