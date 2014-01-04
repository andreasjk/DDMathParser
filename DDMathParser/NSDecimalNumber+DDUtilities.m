//
//  NSDecimalNumber+DDUtilities.m
//  DDMathParser
//
//  Created by Andreas Karlsson on 2014-01-04.
//
//

#import "NSDecimalNumber+DDUtilities.h"

@implementation NSDecimalNumber (DDUtilities)

- (BOOL)dd_isNegative {
    return [self compare:[NSDecimalNumber zero]] == NSOrderedAscending;
}

#pragma mark - Overrides

- (NSNumber*)dd_numberByAdding:(NSNumber*)number {
    if ([number isKindOfClass:[NSDecimalNumber class]]) {
        return [self decimalNumberByAdding:(NSDecimalNumber*)number];
    } else {
        return [super dd_numberByAdding:number];
    }
}

- (NSNumber*)dd_numberBySubtracting:(NSNumber*)number {
    if ([number isKindOfClass:[NSDecimalNumber class]]) {
        return [self decimalNumberBySubtracting:(NSDecimalNumber*)number];
    } else {
        return [super dd_numberBySubtracting:number];
    }
}

- (NSNumber*)dd_numberByDividingBy:(NSNumber*)number {
    if ([number isKindOfClass:[NSDecimalNumber class]]) {
        return [self decimalNumberByDividingBy:(NSDecimalNumber*)number];
    } else {
        return [super dd_numberByDividingBy:number];
    }
}

- (NSNumber*)dd_numberByMultiplyingBy:(NSNumber*)number {
    if ([number isKindOfClass:[NSDecimalNumber class]]) {
        return [self decimalNumberByMultiplyingBy:(NSDecimalNumber*)number];
    } else {
        return [super dd_numberByMultiplyingBy:number];
    }
}

- (NSNumber*)dd_absoluteValue {
    if ([self dd_isNegative]) {
        return [self dd_numberByMultiplyingBy:[NSDecimalNumber decimalNumberWithMantissa:1 exponent:0 isNegative:YES]];
    } else {
        return self;
    }
}

@end
