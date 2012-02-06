//
//  NSManagedObject+RestKit.m
//  RestKit
//
//  Created by Paul Moore on 06/02/2012.
//  Copyright (c) 2012 WhoseBill Ltd. All rights reserved.
//

#import "NSManagedObject+RestKit.h"

#import "CoreData+MagicalRecord.h"
#import <objc/runtime.h>

@implementation NSManagedObject (RestKit)


/**
 * Proxy to the NSManagedObject(MagicalRecord) method
 */
+ (NSManagedObjectContext*)managedObjectContext {
	return [NSManagedObjectContext contextForCurrentThread];
}


/**
 * Proxy to the NSManagedObject(MagicalRecord) method
 */
+ (NSEntityDescription*)entity {
    return [self entityDescription];
}

/**
 * Proxy to the NSManagedObject(MagicalRecord) method
 */
+ (id)object {
	return [self createEntity];
}

- (BOOL)isNew {
    NSDictionary *vals = [self committedValuesForKeys:nil];
    return [vals count] == 0;
}



@end
