//
//  Gist.h
//  Activity Stream Example
//
//  Created by Dennin Dalke GVT on 6/4/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Gist : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * descriptionText;
@property (nonatomic, retain) NSNumber * gistID;
@property (nonatomic, retain) id htmlURL;
@property (nonatomic, retain) id jsonURL;
@property (nonatomic, retain) NSNumber * public;
@property (nonatomic, retain) NSNumber * shouldBeDeleted;
@property (nonatomic, retain) NSDate * updatedAt;

@end
