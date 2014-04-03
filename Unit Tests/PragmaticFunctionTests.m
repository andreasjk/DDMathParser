//
//  PrecisionFunctionTests.m
//  DDMathParser
//
//  Created by Andreas Karlsson on 2014-01-05.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "DDMathEvaluator.h"

@interface PragmaticFunctionTests : SenTestCase
@property (strong, nonatomic) DDMathEvaluator *evaluator;
@property (strong, nonatomic) DDMathEvaluator *pragmaticEvaluator;
@property (strong, nonatomic) NSNumberFormatter *formatter;
@end

@implementation PragmaticFunctionTests

- (void)setUp
{
    [super setUp];
    self.evaluator = [[DDMathEvaluator alloc] init];
    self.pragmaticEvaluator = [[DDMathEvaluator alloc] init];
    self.pragmaticEvaluator.usesHighPrecisionEvaluation = YES;
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
    self.formatter.maximumIntegerDigits = 1000;
    self.formatter.maximumSignificantDigits = 1000;
    self.formatter.maximumFractionDigits = 15;
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testPrecisionFunctions
{
    // regular precision and high precision should give the same result when dealing with floating point input
    // for each regular function, if there is a high precision equivalent, make sure it gives a reasonable result when testing with all combinations of quick test numbers

    [self quickTestPattern:@"sinh($)" withValues:@[@"5465"]];
    
    [self quickTestPattern:@"$+$" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"$-$" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"$/$" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"$*$" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"sqrt($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"cuberoot($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"$-$%" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"$+$%" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"$*$%" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"$/$%" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"$!" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"sin($)" withValues:[self quickCheckValues]];

    [self quickTestPattern:@"cos($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"tan($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"sinh($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"cosh($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"tanh($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"asin($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"acos($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"atan($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"asinh($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"acosh($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"atanh($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"ln($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"log($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"log2($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"fabs($)" withValues:[self quickCheckValues]];
    
    [self quickTestPattern:@"e()" withValues:nil];
    [self quickTestPattern:@"π()" withValues:nil];
   
    [self quickTestPattern:@"$**$" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"$**$**$" withValues:@[@"0",@"1",@"-1",@"2",@"-2"]];
    
    [self quickTestPattern:@"mod($,$)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"negate($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"nthroot($,$)" withValues:[self quickCheckValues]];
    
    [self quickTestPattern:@"rshift($,$)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"lshift($,$)" withValues:[self quickCheckValues]];
    
    [self quickTestPattern:@"average($,$,$)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"sum($,$,$)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"count($,$,$)" withValues:[self quickCheckValues]];
    
    [self quickTestPattern:@"median($,$,$)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"stddev($,$,$)" withValues:[self quickCheckValues]];
    
    [self quickTestPattern:@"exp($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"ceil($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"floor($)" withValues:[self quickCheckValues]];
    [self quickTestPattern:@"abs($)" withValues:@[@"0", @"1", @"-1", @"-3", @"3", @"5465", @"15456654.0"]];
    [self quickTestPattern:@"percent($)" withValues:[self quickCheckValues]];
    
    // got tired of having one per line..
    
    NSArray *oneParameter = @[@"csc", @"sec", @"cotan", @"acsc", @"asec", @"acotan", @"csch", @"sech", @"cotanh", @"acsch", @"asech", @"acotanh", @"versin", @"vercosin", @"coversin", @"covercosin", @"haversin", @"havercosin", @"hacoversin", @"hacovercosin", @"exsec", @"excsc", @"crd", @"dtor", @"rtod"];
    for (NSString *str in oneParameter) {
        NSString *pattern = [NSString stringWithFormat:@"%@($)", str];
        [self quickTestPattern:pattern withValues:[self quickCheckValues]];
    }
    
    NSArray *zeroParameters = @[@"phi", @"pi", @"pi_2", @"pi_4", @"tau", @"sqrt2", @"e", @"log2e", @"log10e", @"ln2", @"ln10"];
    for (NSString *str in zeroParameters) {
        NSString *pattern = [NSString stringWithFormat:@"%@()", str];
        [self quickTestPattern:pattern withValues:[self quickCheckValues]];
    }
}

// Recursive method that will replace $ with all combinations of quickTestValues and sanity check
- (BOOL)quickTestPattern:(NSString*)prototype withValues:(NSArray*)values {
    NSRange range = [prototype rangeOfString:@"$"];
    
    if (range.location == NSNotFound) {
        // we have replaced all occurences of $, make sure they evaluate to the same
        return [self isEvaluationSane:prototype];
    }
    BOOL sane = YES;
    for (NSString *s in values) {
        NSString *newPrototype = [prototype stringByReplacingCharactersInRange:range withString:s];
        sane = [self quickTestPattern:newPrototype withValues:values];
        if (!sane) {
//            break;
        }
    }
    return sane;
}


// Since decimals cant handle infinity, normalize every weird value to NAN
- (NSNumber*)normalize:(NSNumber*)number {
    if ([number isEqual:@(-0)]) {
        number = @(0);
    }
    
    if ([number isEqual:@(INFINITY)] || [number isEqual:@(-INFINITY)]) {
        number = @(NAN);
    }
    
    return number;
}

- (BOOL)isEvaluationSane:(NSString*)string {
    NSError *regularError;
    NSNumber *regularResult = [self.evaluator evaluateString:string withSubstitutions:nil error:&regularError];

    NSError *hpError;
    NSNumber *hpResult = [self.pragmaticEvaluator evaluateString:string withSubstitutions:nil error:&hpError];
    
    STAssertEqualObjects(regularError, hpError, @"If there is an error, both should have the same error");

    regularResult = [self normalize:regularResult];
    hpResult = [self normalize:hpResult];
    
    NSString *regularFormatted = [self.formatter stringFromNumber:regularResult];
    NSString *hpFormatted = [self.formatter stringFromNumber:hpResult];

    for (NSUInteger loc = 0; loc < regularFormatted.length && loc < hpFormatted.length; loc++) {
        NSRange range = NSMakeRange(loc, 1);
        if (loc > 10) {
            // 10 digits match, good enough!
            // TODO: make sure it is good enough!
            return YES;
        }
        
        NSString *regularDigit = [regularFormatted substringWithRange:range];
        NSString *hpDigit = [hpFormatted substringWithRange:range];
        
        if (![regularDigit isEqualToString:hpDigit]) {
            STFail(@"Mismatch \"%@\" regular:%@ hp:%@", string, regularFormatted, hpFormatted);
            return NO;
        }
    }
    
    return YES;
}

- (NSArray*)quickCheckValues {
    return @[@"0", @"1", @"-1", @"-3", @"3", @"0.5", @"-0.5", @"2.5", @"-2.5", @"0.33333", @"5465", @"15456654.0", @"-43546564.54"];
}


@end
