//
//  ParserCombinator.swift
//  HLSCore
//
//  Created by Fabian Canas on 9/3/16.
//  Adapted from https://github.com/objcio/s01e13-parsing-techniques
//

import Foundation


struct Parser<A> {
    typealias Stream = Substring
    let parse: (Stream) -> (A, Stream)?
}


extension Parser {
    func run(_ x: String) -> (A, Stream)? {
        return parse(x[x.fullRange])
    }
    
    func map<Result>(_ f: @escaping (A) -> Result) -> Parser<Result> {
        return Parser<Result> { stream in
            guard let (result, newStream) = self.parse(stream) else { return nil }
            return (f(result), newStream)
        }
    }
    
    func flatMap<Result>(_ f: @escaping (A) -> Result?) -> Parser<Result> {
        return Parser<Result> { stream in
            guard let (result, newStream) = self.parse(stream) else { return nil }
            guard let mappedResult = f(result) else { return nil }
            return (mappedResult, newStream)
        }
    }

    /// Parses zero or more consecutive elements into an array
    var many: Parser<[A]> {
        return Parser<[A]> { stream in
            var result: [A] = []
            var remainder = stream
            while let (element, newRemainder) = self.parse(remainder) {
                remainder = newRemainder
                result.append(element)
            }
            return (result, remainder)
        }
    }

    /// Parses one or more consecutive elements into an array
    var many1: Parser<[A]> {
        return Parser<[A]> { stream in
            var result: [A] = []
            var remainder = stream
            while let (element, newRemainder) = self.parse(remainder) {
                remainder = newRemainder
                result.append(element)
            }
            if result.count == 0 {
                return nil
            }
            return (result, remainder)
        }
    }
    
    func or(_ other: Parser<A>) -> Parser<A> {
        return Parser { stream in
            return self.parse(stream) ?? other.parse(stream)
        }
    }
    
    func followed<B, C>(by other: Parser<B>, combine: @escaping (A, B) -> C) -> Parser<C> {
        return Parser<C> { stream in
            guard let (result, remainder) = self.parse(stream) else { return nil }
            guard let (result2, remainder2) = other.parse(remainder) else { return nil }
            return (combine(result,result2), remainder2)
        }
    }
    
    func followed<B>(by other: Parser<B>) -> Parser<(A, B)> {
        return followed(by: other, combine: { ($0, $1) })
    }
    
    func group<B, C>(into other: Parser<(B, C)>) -> Parser<(B, C, A)> {
        return Parser<(B, C, A)> { stream in
            guard let (resultBC, remainderBC) = other.parse(stream) else { return nil }
            guard let (result, remainder) = self.parse(remainderBC) else { return nil }
            return ((resultBC.0, resultBC.1, result), remainder)
        }
    }
    
    func group<B, C, D>(into other: Parser<(B, C, D)>) -> Parser<(B, C, D, A)> {
        return Parser<(B, C, D, A)> { stream in
            guard let (resultBCD, remainderBCD) = other.parse(stream) else { return nil }
            guard let (result, remainder) = self.parse(remainderBCD) else { return nil }
            return ((resultBCD.0, resultBCD.1, resultBCD.2, result), remainder)
        }
    }
    
    init(result: A) {
        parse = { stream in (result, stream) }
    }
    
    var optional: Parser<A?> {
        return self.map({ .some($0) }).or(Parser<A?>(result: nil))
    }
}


func curry<A, B, C>(_ f: @escaping (A, B) -> C) -> (A) -> (B) -> C {
    return { x in { y in f(x, y) } }
}

precedencegroup ParserPrecedence {
    associativity: left
    higherThan: ParserConjuctionPrecedence
}

precedencegroup ParserConjuctionPrecedence {
    associativity: left
    lowerThan: LogicalDisjunctionPrecedence
    higherThan: ParserMapPrecedence
}

precedencegroup ParserMapPrecedence {
    associativity: left
    higherThan: ParserGroupPrecendence
}

precedencegroup ParserGroupPrecendence {
    associativity: left
}


infix operator <^> : ParserMapPrecedence
infix operator <^!> : ParserMapPrecedence
infix operator <*> : ParserPrecedence
infix operator <&> : ParserPrecedence
infix operator *>  : ParserPrecedence
infix operator <*  : ParserPrecedence
infix operator <|> : ParserConjuctionPrecedence
infix operator <<&  : ParserGroupPrecendence

func <^><A, B>(f: @escaping (A) -> B, rhs: Parser<A>) -> Parser<B> {
    return rhs.map(f)
}

func <^!><A, B>(f: @escaping (A) -> B?, rhs: Parser<A>) -> Parser<B> {
    return rhs.flatMap(f)
}

func <^><A, B, R>(f: @escaping (A, B) -> R, rhs: Parser<A>) -> Parser<(B) -> R> {
    return Parser(result: curry(f)) <*> rhs
}

func <*><A, B>(lhs: Parser<(A) -> B>, rhs: Parser<A>) -> Parser<B> {
    return lhs.followed(by: rhs, combine: { $0($1) })
}

func <&><A, B>(lhs: Parser<A>, rhs: Parser<B>) -> Parser<(A,B)> {
    return lhs.followed(by: rhs, combine: { ($0, $1) })
}

/// Returns a parser matching the lhs following the rhs, only returning the 
/// value matched by the lhs parser in the case both match.
///
/// - Parameters:
///   - lhs: The first matching parser, the result of the expression
///   - rhs: The second matching parser
/// - Returns: The lhs parser in the case both lhs and rhs match
func <*<A, B>(lhs: Parser<A>, rhs: Parser<B>) -> Parser<A> {
    return lhs.followed(by: rhs, combine: { x, _ in x })
}

/// Returns a parser matching the lhs following the rhs, only returning the
/// value matched by the rhs parser in the case both match.
///
/// - Parameters:
///   - lhs: The first matching parser
///   - rhs: The second matching parser, the result of the expression
/// - Returns: The rhs parser in the case both lhs and rhs match
func *><A, B>(lhs: Parser<A>, rhs: Parser<B>) -> Parser<B> {
    return lhs.followed(by: rhs, combine: { _, x in x })
}

func <|><A>(lhs: Parser<A>, rhs: Parser<A>) -> Parser<A> {
    return lhs.or(rhs)
}

func <<&<A, B, C>(lhs: Parser<(A, B)>, rhs: Parser<C>) -> Parser<(A, B, C)> {
    return rhs.group(into:lhs)
}

func <<&<A, B, C, D>(lhs: Parser<(A, B, C)>, rhs: Parser<D>) -> Parser<(A, B, C, D)> {
    return rhs.group(into:lhs)
}

