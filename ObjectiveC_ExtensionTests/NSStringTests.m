//
//  NSStringTests.m
//  ObjectiveC_Extension
//
//  Created by Vitor Marques de Miranda on 15/05/17.
//  Copyright © 2017 Vitor Marques de Miranda. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "NSString+Extension.h"
#import "NSData+Extension.h"

@interface NSStringTests : XCTestCase

@end

@implementation NSStringTests

- (void)testStringContains
{
    XCTAssert(![@"12345678" contains:@""]);
    XCTAssert( [@"12345678" contains:@"123"]);
    XCTAssert(![@"12345678" contains:@"321"]);
}

- (void)testStringWebStructure
{
    XCTAssert([[@"?" encodeURIComponent] isEqualToString:@"%3F"]);
    XCTAssert([[@"<" encodeURIComponent] isEqualToString:@"%3C"]);
    XCTAssert([[@"&" encodeURIComponent] isEqualToString:@"%26"]);
    XCTAssert([[@"%" encodeURIComponent] isEqualToString:@"%25"]);
    XCTAssert([[@" " encodeURIComponent] isEqualToString:@"%20"]);
    
    XCTAssert([[@"\n" encodeURIComponent] isEqualToString:@"%0A"]);
    XCTAssert([[@"\t" encodeURIComponent] isEqualToString:@"%09"]);
    
    XCTAssert([[@"B" encodeURIComponent] isEqualToString:@"B"]);
    XCTAssert([[@"+" encodeURIComponent] isEqualToString:@"%2B"]);
    XCTAssert([[@"=" encodeURIComponent] isEqualToString:@"%3D"]);
}

- (void)testStringRangeAfterAndBefore
{
    // With Before and End in the String; With Before and End arguments
    XCTAssert([@"012345678X0123Y5" rangeAfterString:@"X" andBeforeString:@"Y"].location == 10);
    XCTAssert([@"012345678X0123Y5" rangeAfterString:@"X" andBeforeString:@"Y"].length == 4);
    
    // With Before and End in the String; With Before argument only
    XCTAssert([@"012345678X0123Y5" rangeAfterString:@"X" andBeforeString:nil].location == 10);
    XCTAssert([@"012345678X0123Y5" rangeAfterString:@"X" andBeforeString:nil].length == 6);
    
    // With Before and End in the String; With After argument only
    XCTAssert([@"012345678X0123Y5" rangeAfterString:nil andBeforeString:@"Y"].location == 0);
    XCTAssert([@"012345678X0123Y5" rangeAfterString:nil andBeforeString:@"Y"].length == 14);
    
    // With Before and End in the String; With no arguments
    XCTAssert([@"012345678X0123Y5" rangeAfterString:nil andBeforeString:nil].location == 0);
    XCTAssert([@"012345678X0123Y5" rangeAfterString:nil andBeforeString:nil].length == 16);
    
    
    
    // With Before in the String; With Before and End arguments
    XCTAssert([@"012345678X012345" rangeAfterString:@"X" andBeforeString:@"Y"].location == 10);
    XCTAssert([@"012345678X012345" rangeAfterString:@"X" andBeforeString:@"Y"].length == 6);
    
    // With Before in the String; With Before argument only
    XCTAssert([@"012345678X012345" rangeAfterString:@"X" andBeforeString:nil].location == 10);
    XCTAssert([@"012345678X012345" rangeAfterString:@"X" andBeforeString:nil].length == 6);
    
    // With Before in the String; With After argument only
    XCTAssert([@"012345678X012345" rangeAfterString:nil andBeforeString:@"Y"].location == 0);
    XCTAssert([@"012345678X012345" rangeAfterString:nil andBeforeString:@"Y"].length == 16);
    
    // With Before in the String; With no arguments
    XCTAssert([@"012345678X012345" rangeAfterString:nil andBeforeString:nil].location == 0);
    XCTAssert([@"012345678X012345" rangeAfterString:nil andBeforeString:nil].length == 16);
    
    
    
    // With End in the String; With Before and End arguments
    XCTAssert([@"01234567890123Y5" rangeAfterString:@"X" andBeforeString:@"Y"].location == NSNotFound);
    
    // With End in the String; With Before argument only
    XCTAssert([@"01234567890123Y5" rangeAfterString:@"X" andBeforeString:nil].location == NSNotFound);
    
    // With End in the String; With After argument only
    XCTAssert([@"01234567890123Y5" rangeAfterString:nil andBeforeString:@"Y"].location == 0);
    XCTAssert([@"01234567890123Y5" rangeAfterString:nil andBeforeString:@"Y"].length == 14);
    
    // With End in the String; With no arguments
    XCTAssert([@"01234567890123Y5" rangeAfterString:nil andBeforeString:nil].location == 0);
    XCTAssert([@"01234567890123Y5" rangeAfterString:nil andBeforeString:nil].length == 16);
    
    
    
    // With End in the String; With Before and End arguments
    XCTAssert([@"0123456789012345" rangeAfterString:@"X" andBeforeString:@"Y"].location == NSNotFound);
    
    // With End in the String; With Before argument only
    XCTAssert([@"0123456789012345" rangeAfterString:@"X" andBeforeString:nil].location == NSNotFound);
    
    // With End in the String; With After argument only
    XCTAssert([@"0123456789012345" rangeAfterString:nil andBeforeString:@"Y"].location == 0);
    XCTAssert([@"0123456789012345" rangeAfterString:nil andBeforeString:@"Y"].length == 16);
    
    // With End in the String; With no arguments
    XCTAssert([@"0123456789012345" rangeAfterString:nil andBeforeString:nil].location == 0);
    XCTAssert([@"0123456789012345" rangeAfterString:nil andBeforeString:nil].length == 16);
}

- (void)testGetFragment
{
    // With Before and End in the String; With Before and End arguments
    XCTAssert([[@"012345678X0123Y5" getFragmentAfter:@"X" andBefore:@"Y"] isEqualToString:@"0123"]);
    
    // With Before and End in the String; With Before argument only
    XCTAssert([[@"012345678X0123Y5" getFragmentAfter:@"X" andBefore:nil] isEqualToString:@"0123Y5"]);
    
    // With Before and End in the String; With After argument only
    XCTAssert([[@"012345678X0123Y5" getFragmentAfter:nil andBefore:@"Y"] isEqualToString:@"012345678X0123"]);
    
    // With Before and End in the String; With no arguments
    XCTAssert([[@"012345678X0123Y5" getFragmentAfter:nil andBefore:nil] isEqualToString:@"012345678X0123Y5"]);
    
    
    
    // With Before in the String; With Before and End arguments
    XCTAssert([[@"012345678X012345" getFragmentAfter:@"X" andBefore:@"Y"] isEqualToString:@"012345"]);
    
    // With Before in the String; With Before argument only
    XCTAssert([[@"012345678X012345" getFragmentAfter:@"X" andBefore:nil] isEqualToString:@"012345"]);
    
    // With Before in the String; With After argument only
    XCTAssert([[@"012345678X012345" getFragmentAfter:nil andBefore:@"Y"] isEqualToString:@"012345678X012345"]);
    
    // With Before in the String; With no arguments
    XCTAssert([[@"012345678X012345" getFragmentAfter:nil andBefore:nil] isEqualToString:@"012345678X012345"]);
    
    
    
    // With End in the String; With Before and End arguments
    XCTAssert([@"01234567890123Y5" getFragmentAfter:@"X" andBefore:@"Y"] == nil);
    
    // With End in the String; With Before argument only
    XCTAssert([@"01234567890123Y5" getFragmentAfter:@"X" andBefore:nil] == nil);
    
    // With End in the String; With After argument only
    XCTAssert([[@"01234567890123Y5" getFragmentAfter:nil andBefore:@"Y"] isEqualToString:@"01234567890123"]);
    
    // With End in the String; With no arguments
    XCTAssert([[@"01234567890123Y5" getFragmentAfter:nil andBefore:nil] isEqualToString:@"01234567890123Y5"]);
    
    
    
    // Without both in the String; With Before and End arguments
    XCTAssert([@"0123456789012345" getFragmentAfter:@"X" andBefore:@"Y"] == nil);
    
    // Without both in the String; With Before argument only
    XCTAssert([@"0123456789012345" getFragmentAfter:@"X" andBefore:nil] == nil);
    
    // Without both in the String; With After argument only
    XCTAssert([[@"0123456789012345" getFragmentAfter:nil andBefore:@"Y"] isEqualToString:@"0123456789012345"]);
    
    // Without both in the String; With no arguments
    XCTAssert([[@"0123456789012345" getFragmentAfter:nil andBefore:nil] isEqualToString:@"0123456789012345"]);
}

- (void)testComponentsMatchingWithRegex
{
    NSArray* result;
    
    result = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    XCTAssert([[@"1234567890" findAll:@"[0-9]"] isEqualToArray:result]);
    
    result = @[@"1234567890"];
    XCTAssert([[@"1234567890" findAll:@"[0-9]{10}"] isEqualToArray:result]);
    
    result = @[@"123a",@"456b",@"789c"];
    XCTAssert([[@"123a456b789c" findAll:@"[0-9]{3}[a-z]"] isEqualToArray:result]);
    
    result = @[@"1234567890"];
    XCTAssert([[@"1234567890" findAll:@"[0-9]+"] isEqualToArray:result]);
}

@end
