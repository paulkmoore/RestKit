//
//  RKManagedObjectLoader+MagicalRecord.m
//  RestKit
//
//  Created by Paul Moore on 08/02/2012.
//  Copyright (c) 2012 WhoseBill Ltd. All rights reserved.
//

#import "RKManagedObjectLoader+MagicalRecord.h"

//#import "RKURL.h"
//#import "RKObjectMapper.h"
#import "RKManagedObjectThreadSafeInvocation.h"
//#import "RKObjectLoader_Internals.h"
//#import "RKRequest_Internals.h"
#import "ObjectMapping.h"
#import "RKLog.h"
#import "CoreData+MagicalRecord.h"

@implementation RKManagedObjectLoader (MagicalRecord)

#pragma mark -
#pragma mark Custom Accessors

// TODO - consider whether we'll nedd to override accessors of the RKObjectManager...
//- (RKManagedObjectStore*)objectStore {
//}

- (id)targetObject {
    NSManagedObject* target = nil;
    
    // If we have a targetObjectID then return the object in our current (thread specific) MOC
    if (_targetObjectID) {
        target = [[[RKObjectManager sharedManager] objectStore] objectWithID:_targetObjectID];       
    } 
    
    return (target);
}

- (void)setTargetObject:(NSObject*)targetObject {
    [_targetObjectID release];
    _targetObjectID = [[targetObject objectID] retain]; // We retain here as we're using the RKMOL iVar (no @property exists) for targetObjectID
}

- (NSManagedObjectID*)targetObjectID {
    return (_targetObjectID);
}


/**
 * Overload of processMappingResult: in order that we reset the MOC at the end 
 * of the mapping work (after the save).  This prevents continual growth of the 
 * object graph in the MOC.
 */
// NOTE: We are on the background thread here, be mindful of Core Data's threading needs
- (void)processMappingResult:(RKObjectMappingResult*)result {
    NSAssert(_sentSynchronously || ![NSThread isMainThread], @"Mapping result processing should occur on a background thread");
    if (_targetObjectID && self.targetObject && self.method == RKRequestMethodDELETE) {
        NSManagedObject* backgroundThreadObject = [self.objectStore objectWithID:_targetObjectID];
        RKLogInfo(@"Deleting local object %@ due to DELETE request", backgroundThreadObject);
        [[self.objectStore managedObjectContext] deleteObject:backgroundThreadObject];        
    }
    
    // If the response was successful, save the store...
    if ([self.response isSuccessful]) {
        [self deleteCachedObjectsMissingFromResult:result];
        
        // PKM - 31/1/2012 - added objectLoader:willSaveWithContext hook
        if ([[self delegate] respondsToSelector:@selector(objectLoader:willSaveObjects:inContext:)]) {
            [[self delegate] objectLoader:self
                          willSaveObjects:[result asCollection]
                                inContext:[[self objectStore] managedObjectContext]];
        }
        
        NSError* error = [self.objectStore save];
        
        // PKM - 16/02/2012 - cleanse the thread MOC from cached objects
        // Reset the thread specific MOC
//        NSLog(@"com.whosebill.temp: Registered objects (pre-reset) : %@", [[NSManagedObjectContext contextForCurrentThread] registeredObjects]);
        [NSManagedObjectContext resetContextForCurrentThread];
//        NSLog(@"com.whosebill.temp: Registered objects (post-reset): %@", [[NSManagedObjectContext contextForCurrentThread] registeredObjects]);
        
        if (error) {
            RKLogError(@"Failed to save managed object context after mapping completed: %@", [error localizedDescription]);
            NSMethodSignature* signature = [self.delegate methodSignatureForSelector:@selector(objectLoader:didFailWithError:)];
            RKManagedObjectThreadSafeInvocation* invocation = [RKManagedObjectThreadSafeInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self.delegate];
            [invocation setSelector:@selector(objectLoader:didFailWithError:)];
            [invocation setArgument:&self atIndex:2];
            [invocation setArgument:&error atIndex:3];
            [invocation invokeOnMainThread];
            return;
        }
    }
    
    NSDictionary* dictionary = [result asDictionary];
    NSMethodSignature* signature = [self methodSignatureForSelector:@selector(informDelegateOfObjectLoadWithResultDictionary:)];
    RKManagedObjectThreadSafeInvocation* invocation = [RKManagedObjectThreadSafeInvocation invocationWithMethodSignature:signature];
    [invocation setObjectStore:self.objectStore];
    [invocation setTarget:self];
    [invocation setSelector:@selector(informDelegateOfObjectLoadWithResultDictionary:)];
    [invocation setArgument:&dictionary atIndex:2];
    [invocation setManagedObjectKeyPaths:_managedObjectKeyPaths forArgument:2];
    [invocation invokeOnMainThread];
}


@end
