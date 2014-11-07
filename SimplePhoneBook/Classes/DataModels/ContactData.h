//
//  ContactData.h
//  SimplePhoneBook
//
//  Created by oleksandr on 11/6/14.
//  Copyright (c) 2014 OleksandrNechet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ContactData : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSData *photoData;
@property (nonatomic, readonly) UIImage *photoImage;

@end
