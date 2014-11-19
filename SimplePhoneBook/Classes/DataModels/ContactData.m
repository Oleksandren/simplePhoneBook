//
//  ContactData.m
//  SimplePhoneBook
//
//  Created by oleksandr on 11/6/14.
//  Copyright (c) 2014 OleksandrNechet. All rights reserved.
//

#import "ContactData.h"

@implementation ContactData

-(NSString *)name
{
    if (_firstName.length > 0)
        return [_firstName stringByAppendingFormat:@" %@", _lastName];
    else
        return _lastName;
}
-(UIImage *)photoImage
{
    if (_photoData.length > 0)
        return [UIImage imageWithData:_photoData];
    else
        return [UIImage imageNamed:@"noPhoto"];
}

@end
