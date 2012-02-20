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
              
        // Initialize the MagicalRecord Core Data stack (by filename)
        // Note: we do not set the _persistentStoreCoordinator or
        // _managedObjectModel iVars. We prefer instead to overload
        // the accessors as proxy methods - @see Custom Accessors
        
        [MagicalRecordHelpers setupCoreDataStackWithStoreNamed:(NSString *)storeFilename];
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

- (NSPersistentStoreCoordinator*)persistentStoreCoordinator {
    return [NSPersistentStoreCoordinator defaultStoreCoordinator];
}

- (NSManagedObjectModel*)managedObjectModel {
    return [[self persistentStoreCoordinator] managedObjectModel];
}




#pragma mark -
#pragma mark Helper Methods

- (NSManagedObject*)findOrCreateInstanceOfEntity:(NSEntityDescription*)entity withPrimaryKeyAttribute:(NSString*)primaryKeyAttribute andValue:(id)primaryKeyValue {
    NSAssert(entity, @"Cannot instantiate managed object without a target class");
    NSAssert(primaryKeyAttribute, @"Cannot find existing managed object instance without a primary key attribute");
    NSAssert(primaryKeyValue, @"Cannot find existing managed object by primary key without a value");
	NSManagedObject* object = nil;
    
    // Determine the object class of the entity - MagicalRecord uses NSManagedObject class
    // methods in preference to being 'entity based'.
    Class objectClass = NSClassFromString([entity managedObjectClassName]);
   
    // Try to find the object...
    if (!(object = [objectClass findFirstByAttribute:primaryKeyAttribute withValue:primaryKeyValue])) {
        // and if we don't find the object, create a new one.
        object = [objectClass createEntity];
    }

	return (object);
}

- (NSError*)save {
    __block NSError* saveError = nil;  // Mutable reference
    
    // We call the MagicalRecord NSManagedObjectContext:saveWithErrorHandler to get to the
    // NSError object, acknowledging that we forego MR's default error handlers.
    [[NSManagedObjectContext contextForCurrentThread] saveWithErrorHandler:^(NSError* error) {
        // Capture the error so that we can return it (outside of the block)
        saveError = error;
    }];
    
    return (saveError);
}

// TODO Consider moving the 'object with ID methods to NSManagedObject+MagicalRecord

- (NSManagedObject*)objectWithID:(NSManagedObjectID*)objectID {
    return [[NSManagedObjectContext contextForCurrentThread] objectWithID:objectID];
}

- (NSManagedObject*)objectWithID:(NSManagedObjectID*)objectID inContext:(NSManagedObjectContext*)context {
    return [context objectWithID:objectID];
}


- (NSArray*)objectsWithIDs:(NSArray*)objectIDs {
	NSMutableArray* objects = [[NSMutableArray alloc] init];
	for (NSManagedObjectID* objectID in objectIDs) {
		[objects addObject:[self objectWithID:objectID]];
	}
	NSArray* objectArray = [NSArray arrayWithArray:objects];
	[objects release];
	
	return objectArray;
}



@end
