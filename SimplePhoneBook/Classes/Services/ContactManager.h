//
//  ContactManager.h
//  SimplePhoneBook
//
//  Created by oleksandr on 11/6/14.
//  Copyright (c) 2014 OleksandrNechet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ContactsListData;
@interface ContactManager : NSObject

+ (instancetype)sharedInstance;

/**
 * The contacts array include two subarrays. 
 * First subarray contain data of contact which present phone number. 
 * The second subarray contain contact data without phone number.
 */
@property (copy, nonatomic) void (^contactsListBlock) (ContactsListData* contactsList);

@end
