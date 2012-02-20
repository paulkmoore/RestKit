//
//  RKManagedObjectStore+MagicalRecord.h
//  RestKit
//
//  Created by Paul Moore on 06/02/2012.
//  Copyright (c) 2012 WhoseBill Ltd. All rights reserved.
//

#import "RKManagedObjectStore.h"

@interface RKManagedObjectStore (MagicalRecord)

/**
 * Overload of the designated initializer in order to use MagicalRecord.
 *
 * @todo {This implementation does NOT support i) specification of the store directory, 
 * ii) managed object model or iii) seed database.  This will cause related functionality 
 * in RestKit not to work, and is a work-in-progress.}
 */
- (id)initWithStoreFilename:(NSString *)storeFilename
                inDirectory:(NSString *)nilOrDirectoryPath
      usingSeedDatabaseName:(NSString *)nilOrNameOfSeedDatabaseInMainBundle
         managedObjectModel:(NSManagedObjectModel*)nilOrManagedObjectModel
                   delegate:(id)delegate;

/**
 * We overload the pathToStoreFile method here in order that the filepath is 
 * retrieved from the relevant NSPersistentStore, rather than a retained
 * attribute of the RKObjectStore.
 */
- (NSString*)pathToStoreFile;

/**
 * Overload in order to proxy to MagicalRecord method
 */
- (NSManagedObjectContext*)managedObjectContext;

/**
 * Overload in order to proxy to MagicalRecord method
 */
- (NSPersistentStoreCoordinator*)persistentStoreCoordinator;

/**
 * Overload in order to proxy to MagicalRecord method
 */
- (NSManagedObjectModel*)managedObjectModel;

/**
 * Overload in order to proxy to MagicalRecord method
 */
- (NSError*)save;


- (NSManagedObject*)findOrCreateInstanceOfEntity:(NSEntityDescription*)entity
                         withPrimaryKeyAttribute:(NSString*)primaryKeyAttribute
                                        andValue:(id)primaryKeyValue;

- (NSManagedObject*)objectWithID:(NSManagedObjectID*)objectID;
- (NSManagedObject*)objectWithID:(NSManagedObjectID*)objectID
                       inContext:(NSManagedObjectContext*)context;
- (NSArray*)objectsWithIDs:(NSArray*)objectIDs;



@end
