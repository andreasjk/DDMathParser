//
//  PrecisionFunctionTests.m
//  DDMathParser
//
//  Created by Andreas Karlsson on 2014-01-05.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "DDMathEvaluator.h"

@interface PrecisionFunctionTests : SenTestCase
@property (strong, nonatomic) DDMathEvaluator *evaluator;
@property (strong, nonatomic) DDMathEvaluator *highPrecisionEvaluator;
@property (strong, nonatomic) NSNumberFormatter *formatter;
@end

@implementation PrecisionFunctionTests

- (void)setUp
{
    [super setUp];
    self.evaluator = [[DDMathEvaluator alloc] init];
    self.highPrecisionEvaluator = [[DDMathEvaluator alloc] init];
    self.highPrecisionEvaluator.usesHighPrecisionEvaluation = YES;
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    self.formatter.maximumFractionDigits = 15;
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testCommonMethods
{
    // regular precision and high precision should give the same result when dealing with floating point input
    // for each regular function, if there is a high precision equivalent, make sure it gives a reasonable result when testing with all combinations of quick test numbers


    [self quickTestPrototype:@"$+$" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"$-$" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"$/$" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"$*$" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"sqrt($)" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"$-$%" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"$+$%" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"$*$%" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"$/$%" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"$!" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"sin($)" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"cos($)" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"tan($)" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"sinh($)" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"cosh($)" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"tanh($)" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"asin($)" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"acos($)" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"atan($)" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"asinh($)" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"acosh($)" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"atanh($)" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"ln($)" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"log($)" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"log2($)" withValues:[self quickCheckValues]];
    [self quickTestPrototype:@"fabs($)" withValues:[self quickCheckValues]];
    
    [self quickTestPrototype:@"e()" withValues:nil];
    [self quickTestPrototype:@"π()" withValues:nil];
    
    [self quickTestPrototype:@"$**$**$" withValues:@[@"0",@"1",@"-1",@"2",@"-2"]];
}

// Recursive method that will replace $ with all combinations of quickTestValues and sanity check
- (BOOL)quickTestPrototype:(NSString*)prototype withValues:(NSArray*)values {
    NSRange range = [prototype rangeOfString:@"$"];
    
    if (range.location == NSNotFound) {
        // we have replaced all occurences of $, make sure they evaluate to the same
        return [self isEvaluationSane:prototype];
    }
    BOOL sane = YES;
    for (NSString *s in values) {
        NSString *newPrototype = [prototype stringByReplacingCharactersInRange:range withString:s];
        sane = [self quickTestPrototype:newPrototype withValues:values];
        if (!sane) {
            break;
        }
    }
    return sane;
}

- (BOOL)isEvaluationSane:(NSString*)string {
    NSNumber *regularResult = [self.evaluator evaluateString:string withSubstitutions:nil];
    // Since decimal numbers cant handle -0, or positive/negative infinity, get rid of those.
    if ([regularResult isEqual:@(-0)]) {
        regularResult = @(0);
    }
    if ([regularResult isEqual:@(INFINITY)] || [regularResult isEqual:@(-INFINITY)]) {
        regularResult = @(NAN);
    }
    NSString *regularFormatted = [self.formatter stringFromNumber:regularResult];
    
    NSNumber *hpResult = [self.highPrecisionEvaluator evaluateString:string withSubstitutions:nil];
    NSString *hpFormatted = [self.formatter stringFromNumber:hpResult];

    __block NSInteger matches = 0;
    __block BOOL sane = YES;
    [regularFormatted
     enumerateSubstringsInRange:NSMakeRange(0, regularFormatted.length)
     options:NSStringEnumerationByComposedCharacterSequences
     usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         if (matches > 5 || substringRange.location + substringRange.length > hpFormatted.length) {
             *stop = YES;
             sane = YES;
             return;
         }

         NSString *substringHp = [hpFormatted substringWithRange:substringRange];
         
         if ([substring isEqualToString:substringHp]) {
             matches++;
         } else {
             *stop = YES;
             sane = NO;
             STFail(@"Not sane \"%@\" regular:%@ hp:%@", string, regularFormatted, hpFormatted);
         }
    }];
    
    return sane;
}

- (NSArray*)quickCheckValues {
    return @[@"0", @"1", @"-1", @"-3", @"3", @"0.5", @"-0.5", @"2.5", @"-2.5", @"0.33333", @"5465", @"15456654.0", @"-43546564.54"];
}


@end
