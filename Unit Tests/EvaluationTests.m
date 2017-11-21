//
//  EvaluationTests.m
//  DDMathParser
//
//  Created by Dave DeLong on 11/18/10.
//  Copyright 2010 Home. All rights reserved.
//

#import "UnitTestMacros.h"
#import "EvaluationTests.h"
#import "DDMathParser.h"
#import "NSExpression+EasyParsing.h"
#import "DDMathEvaluator.h"

@implementation EvaluationTests

- (void)testSimple {
    TEST(@"1", 1);
    TEST(@"1000000000000000", 1000000000000000);
}

- (void)testAddition {
    TEST(@"1+1", 2);
    TEST(@"1+1+1", 3);
    TEST(@"1+1+1+1", 4);
    TEST(@"1+1+1+1+1", 5);
}

- (void)testSubtraction {
    TEST(@"1-1", 0);
    TEST(@"1-1-1", -1);
    TEST(@"1-1-1-1", -2);
    TEST(@"1-1-1-1-1", -3);
}

- (void)testMultiplication {
    TEST(@"2*2", 4);
    TEST(@"2*2*2", 8);
    TEST(@"2*2*2*2", 16);
    TEST(@"2*2*2*2*2", 32);
}

- (void)testDivision {
    TEST(@"2/2", 1);
    TEST(@"2/2/2", 0.5);
    TEST(@"2/2/2/2", 0.25);
    TEST(@"2/2/2/2/2", 0.125);
}

- (void)testPower {
    TEST(@"2**2", 4);
    TEST(@"2**2**2", 16);
    TEST(@"2**3**2", 512);
}

- (void)testSquareRoot {
    TEST(@"sqrt(9)", 3);
    TEST(@"sqrt(100)", 10);
//    TEST(@"sqrt(-3)", NAN);
}

- (void)testCubeRoot {
    TEST(@"cuberoot(27)", 3);
    TEST(@"cuberoot(27)", 3);
    TEST(@"cuberoot(27)", 3);
}

- (void)testNegation {
    TEST(@"-1", -1);
    TEST(@"1+-1", 0);
    TEST(@"-1+1", 0);
}

- (void)testFactorial {
    TEST(@"4!", 24);
    TEST(@"-4!", -24);
    TEST(@"3!!", 720);
    TEST(@"2!!!!!!!!!", 2);
}

- (void)testPercent {
    TEST(@"100+percent(5)", 105);
    TEST(@"100-percent(5)", 95);
    TEST(@"100*percent(5)", 5);
    TEST(@"100/percent(5)", 2000);
}

- (void)testFloatAbsolute {
    TEST(@"fabs(-1)", 1);
    TEST(@"fabs(1)", 1);
    TEST(@"fabs(-1.33)", 1.33);
    TEST(@"fabs(1.33)", 1.33);
}

@end