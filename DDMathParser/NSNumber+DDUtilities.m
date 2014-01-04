//
//  NSNumber+DDAdditions.m
//  DDMathParser
//
//  Created by Andreas Karlsson on 2014-01-04.
//
//

#import "NSNumber+DDUtilities.h"

@implementation NSNumber (DDUtilities)

- (NSNumber*)dd_numberByAdding:(NSNumber*)number {
    return [NSNumber numberWithDouble:[self doubleValue] + [number doubleValue]];
}

- (NSNumber*)dd_numberBySubtracting:(NSNumber*)number {
    return [NSNumber numberWithDouble:[self doubleValue] - [number doubleValue]];
}

- (NSNumber*)dd_numberByDividingBy:(NSNumber*)number {
     return [NSNumber numberWithDouble:[self doubleValue] / [number doubleValue]];
}

- (NSNumber*)dd_numberByMultiplyingBy:(NSNumber*)number {
    return [NSNumber numberWithDouble:[self doubleValue] * [number doubleValue]];
}

- (NSNumber*)dd_absoluteValue {
    return [NSNumber numberWithDouble:fabs([self doubleValue])];
}

@end
