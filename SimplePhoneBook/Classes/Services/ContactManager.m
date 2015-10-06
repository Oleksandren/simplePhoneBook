//
//  ContactManager.m
//  SimplePhoneBook
//
//  Created by oleksandr on 11/6/14.
//  Copyright (c) 2014 OleksandrNechet. All rights reserved.
//

#import "ContactManager.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "ContactData.h"
#import "ContactsListData.h"

@implementation ContactManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t predicate = 0;
    __strong static ContactManager *manager = nil;
    dispatch_once(&predicate, ^{
        manager = [self new];
    });
    return manager;
}

#pragma mark - Load Contacts

- (void)authorizeAndLoadContacts
{
    ABAddressBookRef addressBook = NULL;
    CFErrorRef error = NULL;
    
    switch (ABAddressBookGetAuthorizationStatus())
    {
        case kABAuthorizationStatusAuthorized:
        {
            addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            if(addressBook != NULL)
            {
                [self parseAddressBookData:addressBook];
                return ;
            }
        }
            break;
            
        case kABAuthorizationStatusDenied:
        {
            NSLog(@"Access denied!");
            [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Please, setup your Privacy settings to access your Contacts." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        }
            break;
            
        case kABAuthorizationStatusNotDetermined:
        {
            addressBook = ABAddressBookCreateWithOptions(NULL, &error);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted)
                {
                    if(addressBook != NULL)
                    {
                        [self parseAddressBookData:addressBook];
                        return ;
                    }
                }
                else if (!granted || error)
                {
                    NSLog(@"not granted address book! OR error!");
                }
            });
        }
            break;
        case kABAuthorizationStatusRestricted:
            NSLog(@"Access restricted!");
            break;
        default:
            break;
    }
    _contactsListBlock(nil);
}
-(void)parseAddressBookData:(ABAddressBookRef)addressBook
{
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSMutableArray *contactsData = [NSMutableArray new];
    NSMutableArray *contactsDataWithoutPhoneNumber = [NSMutableArray new];
    
    for(int i = 0; i < ABAddressBookGetPersonCount(addressBook); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
        
        NSString *name = (__bridge NSString *)ABRecordCopyValue(person,kABPersonFirstNameProperty);
        NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person,kABPersonLastNameProperty);
        
        if (!name && !lastName)
        {
            CFRelease(person);
            continue;
        }
        
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        if (ABMultiValueGetCount(phones))
        {
            for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
            {
                CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
                NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
                CFRelease(phoneNumberRef);
                
                ContactData *contact = [ContactData new];
                contact.firstName = name;
                contact.lastName = lastName;
                contact.photoData = (__bridge_transfer NSData *)ABPersonCopyImageData(person);
                contact.phoneNumber = phoneNumber;
                [contactsData addObject:contact];
            }
        }
        else
        {
            ContactData *contact = [ContactData new];
            contact.firstName = name;
            contact.lastName = lastName;
            contact.photoData = (__bridge_transfer NSData *)ABPersonCopyImageData(person);
            [contactsDataWithoutPhoneNumber addObject:contact];
        }
        CFRelease(phones);
        if (person)
            CFRelease(person);
    }
    CFRelease(allPeople);
    
    ContactsListData *cld = [[ContactsListData alloc] initWithContactList:contactsData
                                            andContactsWithoutPhoneNumber:contactsDataWithoutPhoneNumber];
    if (_contactsListBlock)
        _contactsListBlock(cld);
}

- (void)setContactsListBlock:(void (^)(ContactsListData *))contactsListBlock
{
    _contactsListBlock = contactsListBlock;
    [self authorizeAndLoadContacts];
}

@end
