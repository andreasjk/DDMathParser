//
//  _DDPragmaticFunctionEvaluator.h
//  DDMathParser
//
//  Created by Andreas Karlsson on 2014-01-29.
//
//

#import "_DDFunctionEvaluator.h"

/**
 *  Evaulates using high precision for functions that we are confident about the result and the execution time has a O(1) upper bound.
 */
@interface _DDPragmaticFunctionEvaluator : _DDFunctionEvaluator

@end
