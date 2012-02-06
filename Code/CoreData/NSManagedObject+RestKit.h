//
//  NSManagedObject+RestKit.h
//  RestKit
//
//  Created by Paul Moore on 06/02/2012.
//  Copyright (c) 2012 WhoseBill Ltd. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (RestKit)

+ (NSManagedObjectContext*)managedObjectContext;
+ (NSEntityDescription*)entity;
+ (id)object;
- (BOOL)isNew;

@end
