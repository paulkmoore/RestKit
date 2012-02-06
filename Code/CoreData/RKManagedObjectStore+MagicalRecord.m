//
//  RKManagedObjectStore+MagicalRecord.m
//  RestKit
//
//  Created by Paul Moore on 06/02/2012.
//  Copyright (c) 2012 WhoseBill Ltd. All rights reserved.
//

#import "RKManagedObjectStore+MagicalRecord.h"

#import "CoreData+MagicalRecord.h"

@implementation RKManagedObjectStore (MagicalRecord)

#pragma mark -
#pragma mark Initialization Methods

- (id)initWithStoreFilename:(NSString *)storeFilename inDirectory:(NSString *)nilOrDirectoryPath usingSeedDatabaseName:(NSString *)nilOrNameOfSeedDatabaseInMainBundle managedObjectModel:(NSManagedObjectModel*)nilOrManagedObjectModel delegate:(id)delegate {
    self = [self init];
    if (self) {
        _storeFilename = [storeFilename retain];
        _delegate = delegate;
              
        // Initialize the MagicalRecord Core Data stack (by filename) and set the attributes in the RKManagedObjectStore
        [MagicalRecordHelpers setupCoreDataStackWithStoreNamed:(NSString *)storeFilename];
        _persistentStoreCoordinator = [NSPersistentStoreCoordinator defaultStoreCoordinator];
        _managedObjectModel = [[self persistentStoreCoordinator] managedObjectModel];
    }
    
    return self;
}

#pragma mark -
#pragma mark Custom Accessors

- (NSString*)pathToStoreFile {
    return [[NSPersistentStore urlForStoreName:[self storeFilename]] path];
}

- (NSManagedObjectContext*)managedObjectContext {
	return [NSManagedObjectContext contextForCurrentThread];
}

#pragma mark -
#pragma mark Helper Methods

- (NSManagedObject*)findOrCreateInstanceOfEntity:(NSEntityDescription*)entity withPrimaryKeyAttribute:(NSString*)primaryKeyAttribute andValue:(id)primaryKeyValue {
    NSAssert(entity, @"Cannot instantiate managed object without a target class");
    NSAssert(primaryKeyAttribute, @"Cannot find existing managed object instance without a primary key attribute");
    NSAssert(primaryKeyValue, @"Cannot find existing managed object by primary key without a value");
	NSManagedObject* object = nil;
   
    // Try to find the object
    object = [NSClassFromString([entity managedObjectClassName]) findFirstByAttribute:(NSString *)primaryKeyAttribute
                                                                            withValue:(id)primaryKeyValue];  // Note: the MagicalRecord method is a class method, and requires us to 'obtain' the specific class for the requested entity.

    // If we can't find the object, create a new one...
    if (!object) {
        object = [[[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:[NSManagedObjectContext contextForCurrentThread]] autorelease];
    }
    
	return object;
}



@end
