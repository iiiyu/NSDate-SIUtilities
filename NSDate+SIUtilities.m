//
//  NSDate+SIUtilities.m
//  NSDateSIUtilities
//
//  Created by ChenYu Xiao on 11/10/13.
//  Copyright (c) 2013 Sumi. All rights reserved.
//

#import "NSDate+SIUtilities.h"

#define ONEDAYTIMEINTERVAL 86400.0

@implementation NSDate (SIUtilities)


- (NSDate *)si_GMTDateAsStartOfDayWithCurrentTimeZone
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |
                             NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit |
                             NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);
    
    NSDateComponents *dataComponents = [calendar components:components fromDate:self];
    dataComponents.hour = 0;
	dataComponents.minute = 0;
	dataComponents.second = 0;
    NSDate *localDateAtStartDay = [calendar dateFromComponents:dataComponents];
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    if (timeZone.secondsFromGMT < 0) {
        return [localDateAtStartDay dateByAddingTimeInterval:ONEDAYTIMEINTERVAL + timeZone.secondsFromGMT + [timeZone daylightSavingTimeOffsetForDate:localDateAtStartDay]];
    }
    return [localDateAtStartDay dateByAddingTimeInterval:timeZone.secondsFromGMT + [timeZone daylightSavingTimeOffsetForDate:localDateAtStartDay]];
}

- (NSDate *)si_LocalDate
{
    NSDate *localDate = self;
    NSTimeInterval offset = fmod([self timeIntervalSince1970], ONEDAYTIMEINTERVAL);
    if (offset == 0) {
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        NSInteger offsetSeconds = timeZone.secondsFromGMT;
        localDate = [self dateByAddingTimeInterval:offsetSeconds + [timeZone daylightSavingTimeOffsetForDate:self]];
    }else{
        localDate = self;
    }
    
    return localDate;
}

//- (NSDate *)si_GMTDateAtStartOfDayWithTimeZoneName:(NSString *)tzName
//{
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSUInteger components = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |
//                             NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit |
//                             NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);
//
//    NSDateComponents *dataComponents = [calendar components:components fromDate:self];
//    dataComponents.hour = 0;
//	dataComponents.minute = 0;
//	dataComponents.second = 0;
//    NSDate *localAtStartDay = [calendar dateFromComponents:dataComponents];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:tzName];
//    if (timeZone.secondsFromGMT < 0) {
//        return [localAtStartDay dateByAddingTimeInterval:ONEDAYTIMEINTERVAL + timeZone.secondsFromGMT + [timeZone daylightSavingTimeOffsetForDate:localAtStartDay]];
//    }
//    return [localAtStartDay dateByAddingTimeInterval:timeZone.secondsFromGMT + [timeZone daylightSavingTimeOffsetForDate:localAtStartDay]];
//}



@end
