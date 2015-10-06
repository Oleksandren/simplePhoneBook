//
//  ContactListTVC.m
//  SimplePhoneBook
//
//  Created by oleksandr on 11/6/14.
//  Copyright (c) 2014 OleksandrNechet. All rights reserved.
//

#import "ContactListTVC.h"
#import "ContactManager.h"
#import "ContactListCell.h"
#import "ContactsListData.h"

@implementation ContactListTVC
{
    ContactsListData *contactsListData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[ContactManager sharedInstance] setContactsListBlock:^(ContactsListData *cld) {
        contactsListData = cld;
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableView Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"ContactListCell";
    if ([contactsListData typeForSection:indexPath.section] == ContactsSectionTypeWithoutPhones)
        cellIdentifier = @"ContactListCellNoPhoneNumber";
    ContactListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    ContactData *cd = [contactsListData contactForSection:indexPath.section row:indexPath.row];
    [cell setContactData:cd];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect frame = [[[[UIApplication sharedApplication] delegate] window] frame];
    frame.size.height = 80;
    UILabel *h = [[UILabel alloc] initWithFrame:frame];
    h.textAlignment = NSTextAlignmentCenter;
    h.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    
    switch ([contactsListData typeForSection:section])
    {
        case ContactsSectionTypeDefault:
            h.backgroundColor = [UIColor colorWithRed:1 green:204.0/255.0 blue:0 alpha:1];
            h.text = @"Друзья в теме";
            break;
            
        case ContactsSectionTypeWithoutPhones:
            h.backgroundColor = [UIColor lightGrayColor];
            h.text = @"Друзья не в теме";
            break;
        default:
            break;
    }
    return h;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [contactsListData numberOfContactsInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [contactsListData numberOfSection];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([contactsListData typeForSection:indexPath.section] == ContactsSectionTypeWithoutPhones)
        return 50;
    return 69;
}

#pragma mark - Search

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (searchBar.text) {
        [contactsListData makeSearch:searchBar.text];
        [self.tableView reloadData];
    }
}

- (IBAction)didSwipeCell:(UISwipeGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint swipeLocation = [sender locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
        ContactListCell *swipedCell = (ContactListCell *)[self.tableView cellForRowAtIndexPath:swipedIndexPath];
        [swipedCell didSwipe:sender];
    }
}

@end
