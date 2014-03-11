//
//  NSDate+SIUtilities.m
//  NSDateSIUtilities
//
//  Created by ChenYu Xiao on 11/10/13.
//  Copyright (c) 2013 Sumi. All rights reserved.
//

#import "NSDate+SIUtilities.h"

#define ONEDAYTIMEINTERVAL 86400.0
static const double oneHour = 3600.0;

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
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSDate *result;
    if (offset == 0) {
        NSInteger offsetSeconds = timeZone.secondsFromGMT;
        localDate = [self dateByAddingTimeInterval:-offsetSeconds];
        // 不同情况不同处理
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"HH";
        NSInteger flag = [[df stringFromDate:localDate] integerValue];
        result = localDate;
        if (flag > 0 && flag < 12) {
            result = [localDate dateByAddingTimeInterval:-(oneHour * flag)];
        } else if (flag > 12 && flag < 24){
            NSInteger i = 24 - flag;
            result = [localDate dateByAddingTimeInterval:oneHour * i];
        }
    } else {
        result = self;
    }
    //    NSLog(@"%@ %@", self, localDate);
    return result;
}

/**
 *  从任意时间获得对应GMT时间的00:00:00
 *
 *  @return GMT时间00:00:00
 */
- (NSDate *)si_GMTDateAsStartOfDayWithCurrentTimeZone
{
    NSDate *result;
    NSTimeInterval offset = fmod([self timeIntervalSince1970], ONEDAYTIMEINTERVAL);
    if (offset != 0) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSUInteger components = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |
                                 NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit |
                                 NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);
        // 获取本地时间的00:00:00
        NSString *localDateString = [[self sip_localDateFormatter] stringFromDate:self];
        result = [[self sip_GMTDateFormatter] dateFromString:localDateString];
        // 获取GMT时间的00:00:00
        [calendar setTimeZone: [NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        NSDateComponents *dateComponents = [calendar components:components fromDate:result];
        dateComponents.hour = 0;
        dateComponents.minute = 0;
        dateComponents.second = 0;
        result = [calendar dateFromComponents:dateComponents];
        //    NSLog(@"%@ %@ %@", self, result, localDateString);
        
    } else {
        result = self;
    }
    
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
