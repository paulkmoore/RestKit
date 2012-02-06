//
//  RKManagedObjectStore+MagicalRecord.h
//  RestKit
//
//  Created by Paul Moore on 06/02/2012.
//  Copyright (c) 2012 WhoseBill Ltd. All rights reserved.
//

#import "RKManagedObjectStore.h"

@interface RKManagedObjectStore (MagicalRecord)

- (id)initWithStoreFilename:(NSString *)storeFilename
                inDirectory:(NSString *)nilOrDirectoryPath
      usingSeedDatabaseName:(NSString *)nilOrNameOfSeedDatabaseInMainBundle
         managedObjectModel:(NSManagedObjectModel*)nilOrManagedObjectModel
                   delegate:(id)delegate;

- (NSString*)pathToStoreFile;

@end
