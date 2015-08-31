//
//  LocalizedNumberExtractor.swift
//  DDMathParser
//
//  Created by Dave DeLong on 8/31/15.
//
//

import Foundation

import Foundation

internal struct LocalizedNumberExtractor: TokenExtractor {
    
    private let decimalNumberFormatter = NSNumberFormatter()
    private let scientificNumberFormatter = NSNumberFormatter()
    
    internal init(locale: NSLocale) {
        decimalNumberFormatter.locale = locale
        decimalNumberFormatter.numberStyle = .DecimalStyle
        
        scientificNumberFormatter.locale = locale
        scientificNumberFormatter.numberStyle = .ScientificStyle
    }
    
    func matchesPreconditions(buffer: TokenCharacterBuffer) -> Bool {
        return buffer.peekNext() != nil
    }
    
    func extract(buffer: TokenCharacterBuffer) -> TokenGenerator.Element {
        let start = buffer.currentIndex
        
        var soFar = ""
        while let peek = buffer.peekNext() {
            let test = soFar + String(peek)
            if canParseString(test) {
                soFar = test
                buffer.consume()
            } else {
                break
            }
        }
        
        let indexAfterNumber = buffer.currentIndex
        let range = start ..< indexAfterNumber
        
        guard start.distanceTo(indexAfterNumber) > 0 else {
            let error = TokenizerError(kind: .CannotParseNumber, sourceRange: range)
            return .Error(error)
        }
        
        let token = RawToken(kind: .LocalizedNumber, string: soFar, range: range)
        return .Value(token)
    }
    
    private func canParseString(string: String) -> Bool {
        if let _ = decimalNumberFormatter.numberFromString(string) { return true }
        if let _ = scientificNumberFormatter.numberFromString(string) { return true }
        return false
    }

}
