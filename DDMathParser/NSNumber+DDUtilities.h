//
//  NSNumber+DDAdditions.h
//  DDMathParser
//
//  Created by Andreas Karlsson on 2014-01-04.
//
//

#import <Foundation/Foundation.h>

@interface NSNumber (DDUtilities)
- (NSNumber*)dd_numberByAdding:(NSNumber*)number;
- (NSNumber*)dd_numberBySubtracting:(NSNumber*)number;
- (NSNumber*)dd_numberByDividingBy:(NSNumber*)number;
- (NSNumber*)dd_numberByMultiplyingBy:(NSNumber*)number;
- (NSNumber*)dd_absoluteValue;
@end
