//
//  RKManagedObjectLoader+MagicalRecord.h
//  RestKit
//
//  Created by Paul Moore on 08/02/2012.
//  Copyright (c) 2012 WhoseBill Ltd. All rights reserved.
//

#import "RKManagedObjectLoader.h"

@interface RKManagedObjectLoader (MagicalRecord)

//@property (nonatomic, readonly) NSManagedObjectID*  targetObjectID;

- (id)targetObject;
- (void)setTargetObject:(NSObject*)targetObject;
- (NSManagedObjectID*)targetObjectID;
- (void)processMappingResult:(RKObjectMappingResult*)result;

@end
