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
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger components = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |
                             NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit |
                             NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);
    
    for (NSUInteger i = 0; i < 8760; i++) {
        NSDateComponents *dataComponents = [calendar components:components fromDate:[date dateByAddingTimeInterval:3600 * i]];
        dataComponents.hour = 0;
        dataComponents.minute = 0;
        dataComponents.second = 0;
        
        NSDate *testGMTDate = [calendar dateFromComponents:dataComponents];
        NSDate *testLocalDate = [testGMTDate si_LocalDate];
        NSLog(@"testGMTDate:%@ testLocalDate:%@", testGMTDate, testLocalDate);
        
        XCTAssertFalse(![testGMTDate isEqualToDate:testLocalDate], @"fuck!!!!! testGMTDate:%@ testLocalDate:%@", testGMTDate, testLocalDate);
    }
}



@end
