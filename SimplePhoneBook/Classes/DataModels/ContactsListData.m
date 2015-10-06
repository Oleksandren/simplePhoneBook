//
//  ContactsListData.m
//  SimplePhoneBook
//
//  Created by oleksandr on 11/7/14.
//  Copyright (c) 2014 OleksandrNechet. All rights reserved.
//

#import "ContactsListData.h"
#import "ContactData.h"
#import <Foundation/Foundation.h>

@implementation ContactsListData

- (instancetype)initWithContactList:(NSArray *)cl andContactsWithoutPhoneNumber:(NSArray *)c
{
    self = [super init];
    if (self)
    {
        originContacts = cl;
        originContactsWithoutPhoneNumber =c;
        originContactsData = @[originContacts, originContactsWithoutPhoneNumber];
        
        contacts = cl;
        contactsWithoutPhoneNumber = c;
        contactsData = @[contacts, contactsWithoutPhoneNumber];
    }
    return self;
}

#pragma mark - Helpers

- (NSInteger)numberOfSection
{
    NSInteger count = 0;
    if (contacts.count)
        count ++;
    if (contactsWithoutPhoneNumber.count)
        count ++;
    return count;
}

- (NSInteger)numberOfContactsInSection:(NSInteger)section
{
    return [(NSArray *)contactsData[section] count];
}

- (ContactsSectionType)typeForSection:(NSInteger)section
{
    if (section == 0)
    {
        if (contacts.count)
            return ContactsSectionTypeDefault;
        else if (contactsWithoutPhoneNumber.count)
            return ContactsSectionTypeWithoutPhones;
    }
    else if ((section == 1) && (contactsWithoutPhoneNumber.count))
        return ContactsSectionTypeWithoutPhones;
    return ContactsSectionTypeUndefined;
}

- (ContactData *)contactForSection:(NSInteger)section row:(NSInteger)row
{
    return contactsData[section][row];
}

- (void)makeSearch:(NSString *)searchString
{
    if (searchString && searchString.length > 0)
    {
        NSMutableArray *c = [NSMutableArray new];
        NSMutableArray *cwp = [NSMutableArray new];
        for (ContactData *temp in originContacts)
            if ([temp.name rangeOfString:searchString].location != NSNotFound)
                [c addObject:temp];
        
        
        for (ContactData *temp in originContactsWithoutPhoneNumber)
            if ([temp.name rangeOfString:searchString].location != NSNotFound)
                [cwp addObject:temp];
        
        contacts = c;
        contactsWithoutPhoneNumber = cwp;
        contactsData = @[c, cwp];
    }
    else
    {
        contacts = originContacts;
        contactsWithoutPhoneNumber = originContactsWithoutPhoneNumber;
        contactsData = originContactsData;
    }
}

@end
