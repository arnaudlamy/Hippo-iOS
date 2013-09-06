//
//  Webtoon.h
//  Hippo
//
//  Created by 전수열 on 13. 9. 6..
//  Copyright (c) 2013년 Joyfl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ORM.h"

@interface Webtoon : ORM

@property (nonatomic, retain) NSNumber * finished;
@property (nonatomic, retain) NSNumber * fri;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * mon;
@property (nonatomic, retain) NSNumber * new_count;
@property (nonatomic, retain) NSString * portal;
@property (nonatomic, retain) NSString * portal_id;
@property (nonatomic, retain) NSNumber * revision;
@property (nonatomic, retain) NSNumber * sat;
@property (nonatomic, retain) NSNumber * subscribed;
@property (nonatomic, retain) NSNumber * sun;
@property (nonatomic, retain) NSNumber * thu;
@property (nonatomic, retain) NSString * thumbnail_url;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * tue;
@property (nonatomic, retain) NSNumber * wed;

@end
