//
//  NSDate+SIUtilities.h
//  NSDateSIUtilities
//
//  Created by ChenYu Xiao on 11/10/13.
//  Copyright (c) 2013 Sumi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SIUtilities)


- (NSDate *)si_LocalDate;
- (NSDate *)si_UTCDateAsStartOfDayWithCurrentTimeZone;

@end
