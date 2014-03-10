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

/**
 *  如果是GMT时间00:00:00 还原到本地时间的00:00:00。否则不做改变
 *
 *  @return 本地时间
 */
- (NSDate *)si_LocalDate
{
    NSDate *localDate = self;
    NSTimeInterval offset = fmod([self timeIntervalSince1970], ONEDAYTIMEINTERVAL);
    if (offset == 0) {
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        NSInteger offsetSeconds = timeZone.secondsFromGMT;
        localDate = [self dateByAddingTimeInterval:offsetSeconds];
    }else{
        localDate = self;
    }
//    NSLog(@"%@ %@", self, localDate);
    return localDate;
}

/**
 *  从任意时间获得对应GMT时间的00:00:00
 *
 *  @return GMT时间00:00:00
 */
- (NSDate *)si_GMTDateAsStartOfDayWithCurrentTimeZone
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |
                             NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit |
                             NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);
    // 获取本地时间的00:00:00
    NSString *localDateString = [[self sip_localDateFormatter] stringFromDate:self];
    NSDate *result = [[self sip_GMTDateFormatter] dateFromString:localDateString];
    // 获取GMT时间的00:00:00
    [calendar setTimeZone: [NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSDateComponents *dataComponents = [calendar components:components fromDate:result];
    dataComponents.hour = 0;
	dataComponents.minute = 0;
	dataComponents.second = 0;
    result = [calendar dateFromComponents:dataComponents];
//    NSLog(@"%@ %@ %@", self, result, localDateString);
    return result;
}

#pragma mark - private methods

- (NSDateFormatter *)sip_localDateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:[NSLocale currentLocale]];
    });
    return dateFormatter;
}

- (NSDateFormatter *)sip_GMTDateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy-MM-dd" options:0 locale:[NSLocale currentLocale]];
    });
    return dateFormatter;
}



@end
