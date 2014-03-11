//
//  NSDateSIUtilitiesTests.m
//  NSDateSIUtilitiesTests
//
//  Created by ChenYu Xiao on 11/10/13.
//  Copyright (c) 2013 Sumi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+SIUtilities.h"

@interface NSDateSIUtilitiesTests : XCTestCase

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@interface NSDate(Test)

- (NSDateFormatter *)sip_localDateFormatter;

- (NSDateFormatter *)sip_GMTDateFormatter;

@end

@implementation NSDateSIUtilitiesTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"HH:mm:ss"];
    [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSI_GMTDateAtStartOfDayWithTimeZoneNameMethod
{
    NSDate *date = [NSDate date];
    for (NSUInteger i = 0; i < 8760; i++) {
        NSDate *testDate = [[date dateByAddingTimeInterval:3600 * i] si_GMTDateAsStartOfDayWithCurrentTimeZone];
        NSString *string = [self.dateFormatter stringFromDate:testDate];
        XCTAssertFalse(![string isEqualToString:@"00:00:00"], @"fuck!!!!! string:%@ testDate:%@", string, testDate);
    }
}

- (void)testSI_LocalDate
{
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"HH:mm:ss";
    NSDateFormatter *newDf = [[NSDateFormatter alloc] init];
    newDf.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    for (NSUInteger i = 0; i < 8784; i++) {
        NSDate *testDate = [[date dateByAddingTimeInterval:3600 * i] si_GMTDateAsStartOfDayWithCurrentTimeZone];
        NSDate *testLocalDate = [testDate si_LocalDate];
        NSString *dfstring = [df stringFromDate:testLocalDate];
        NSString *newdfstring = [newDf stringFromDate:testLocalDate];
//        NSLog(@"%@ %@ %@", newdfstring, testLocalDate, testDate);
        XCTAssertFalse(![dfstring isEqualToString:@"00:00:00"], @"fuck!!!!! testGMTDate:%@ testLocalDate:%@", dfstring, testLocalDate);
    }
}


- (void)testEqualToDate
{
    NSDate *date = [NSDate date];
    XCTAssert([[date si_GMTDateAsStartOfDayWithCurrentTimeZone] isEqualToDate:[[date si_GMTDateAsStartOfDayWithCurrentTimeZone] si_GMTDateAsStartOfDayWithCurrentTimeZone]], @"");
    XCTAssert([[date si_LocalDate] isEqualToDate:[[date si_LocalDate] si_LocalDate]], @"");
}

- (void)test
{
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |
                             NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit |
                             NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);
    calendar.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSDateComponents *dateComponents = [calendar components:components fromDate:date];
    dateComponents.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    dateComponents.year = 2014;
    dateComponents.month = 10;
    dateComponents.day = 19;
    dateComponents.hour = 0;
    dateComponents.minute = 0;
    dateComponents.second = 0;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"HH:mm:ss";
    NSDate *testDate = [calendar dateFromComponents:dateComponents];
    NSLog(@"%@ %@ %@", testDate, [testDate si_LocalDate], [df stringFromDate:[testDate si_LocalDate]]);
}



@end
