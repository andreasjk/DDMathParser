//
//  _DDPragmaticFunctionEvaluator.m
//  DDMathParser
//
//  Created by Andreas Karlsson on 2014-01-29.
//
//

#import "_DDPragmaticFunctionEvaluator.h"
#import "_DDPrecisionFunctionEvaluator.h"
#import "_DDFunctionExpression.h"

extern NSString *const _DDFunctionSelectorSuffix;

@interface _DDPragmaticFunctionEvaluator ()
@property (strong, nonatomic) _DDPrecisionFunctionEvaluator *precisionEvaluator;
@property (strong, nonatomic, readonly) NSSet *safeHighPrecisionFunctions;
@end

@implementation _DDPragmaticFunctionEvaluator

- (id)initWithMathEvaluator:(DDMathEvaluator *)evaluator {
    self = [super initWithMathEvaluator:evaluator];
    if (self) {
        _precisionEvaluator = [[_DDPrecisionFunctionEvaluator alloc] initWithMathEvaluator:evaluator];
        
        // These are the high precision functions that I feel confident to include in production
        NSArray *functions = @[@"add",
                               @"subtract",
                               @"multiply",
                               @"divide",
                               @"negate",
//                               @"factorial", // this guy is really unbounded for large numbers, can become stuck forever, I believe there is a better algorithm
                               @"pow",
                               @"nthroot",
                               @"cuberoot",
//                               @"mod", // failed tests
                               @"sqrt",
                               
                               // skipping because I don't use these, but might be OK, haven't tested
//                               @"rshift",
//                               @"lshift",
                               
                               // skipping the aggregate functions since I don't use them and haven't tested yet, but should be OK I guess
//                               @"average",
//                               @"sum",
//                               @"count",
//                               @"median",
//                               @"stddev",
                               

                               // these are flagged as FIXME and not implemented in the HP evaluator yet
//                               @"log",//
//                               @"ln",//
//                               @"log2",//
//                               @"exp",//
                               
                               @"ceil",
                               @"abs",
                               @"fabs",
                               @"floor",
                               @"percent",
                               
                               // going to skip all the trig functions since their results were sketchy
//                               @"sin",
//                               @"cos",
//                               @"tan",
//                               @"asin",
//                               @"acos",
//                               @"atan",
//                               @"sinh",
//                               @"cosh",
//                               @"tanh",
//                               @"asinh",
//                               @"acosh",
//                               @"atanh",
//                               @"csc",
//                               @"sec",
//                               @"cotan",
//                               @"acsc",
//                               @"asec",
//                               @"acotan",
//                               @"csch",
//                               @"sech",
//                               @"cotanh",
//                               @"acsch",
//                               @"asech",
//                               @"acotanh",
//                               @"versin",
//                               @"vercosin",
//                               @"coversin",
//                               @"covercosin",
//                               @"haversin",
//                               @"havercosin",
//                               @"hacoversin",
//                               @"hacovercosin",
//                               @"exsec",
//                               @"excsc",
//                               @"crd",
//                               @"dtor",
//                               @"rtod",
                               
                               // constants should be ok, haven't checked though
                               @"phi",
                               @"pi",
                               @"pi_2",
                               @"pi_4",
                               @"tau",
                               @"sqrt2",
                               @"e",
                               @"log2e",
                               @"log10e",
                               @"ln2",
                               @"ln10",
                               ];
        _safeHighPrecisionFunctions = [NSSet setWithArray:functions];
    }
    return self;
}

- (DDExpression *)evaluateFunction:(_DDFunctionExpression *)expression variables:(NSDictionary *)variables error:(NSError **)error {
    NSString *functionName = [[expression function] lowercaseString];
    if ([self.safeHighPrecisionFunctions containsObject:functionName]) {
        return [self.precisionEvaluator evaluateFunction:expression variables:variables error:error];
    } else {
        return [super evaluateFunction:expression variables:variables error:error];
    }
}


@end
