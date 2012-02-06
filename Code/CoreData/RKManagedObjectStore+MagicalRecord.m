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

/**
 * We overload the pathToStoreFile method here in order that the filepath is 
 * retrieved from the relevant NSPersistentStore, rather than a retained
 * attribute of the RKObjectStore.
 */
- (NSString*)pathToStoreFile {
    return [[NSPersistentStore urlForStoreName:[self storeFilename]] path];
}

@end
