//
//  ContactsListData.h
//  SimplePhoneBook
//
//  Created by oleksandr on 11/7/14.
//  Copyright (c) 2014 OleksandrNechet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ContactData;

typedef enum
{
    ContactsSectionTypeUndefined = -1,
    ContactsSectionTypeDefault = 0,
    ContactsSectionTypeWithoutPhones = 1
}
ContactsSectionType;

@interface ContactsListData : NSObject
{
    //Origin
    NSArray *originContactsData;
    NSArray *originContacts;
    NSArray *originContactsWithoutPhoneNumber;
    
    //Filtered
    NSArray *contactsData;
    NSArray *contacts;
    NSArray *contactsWithoutPhoneNumber;
    
    
    
}

- (instancetype)initWithContactList:(NSArray *)cl andContactsWithoutPhoneNumber:(NSArray *)c;

#pragma mark - Helpers
/**
 * Will return 2 if present contacts with and without phone number
 * Will return 1 if present contacts only with phone numbers or only without phone numbers
 * Will return 0 otherwise
 */
- (NSInteger)numberOfSection;
- (NSInteger)numberOfContactsInSection:(NSInteger)section;
- (ContactsSectionType)typeForSection:(NSInteger)section;
- (ContactData *)contactForSection:(NSInteger)section row:(NSInteger)row;
- (void)makeSearch:(NSString *)searchString;
@end
