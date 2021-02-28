
import Foundation
import Blocks

// MARK: - StateLess Blocks

struct Add4Block: Block {
    typealias Output = Int
    
    func run(_ input: Int, _ completion: @escaping Completion) throws {
        try completion(.done(input + 4))
    }
}

struct StringToIntBlock: Block {
    typealias Output = Int
    
    func run(_ input: String, _ completion: @escaping Completion) throws {
        guard let result = Int(input) else {
            return try completion(.failed(nil))
        }
        try completion(.done(result))
    }
}

struct IntToStringBlock: Block {
    typealias Output = String
    
    func run(_ input: Int, _ completion: @escaping Completion) throws {
        try completion(.done("\(input)"))
    }
}

struct ConcatenateStringBlock: Block {
    typealias Output = String
    
    func run(_ input: String, _ completion: @escaping Completion) throws {
        try completion(.done(input + "-123"))
    }
}

struct IntFailWithErrorBlock: Block {
    typealias Output = String
    
    func run(_ input: Int, _ completion: @escaping Completion) throws {
        try completion(.failed(NSError(domain: "", code: 0, userInfo: nil)))
    }
}

struct IntFailWithoutErrorBlock: Block {
    typealias Output = String
    
    func run(_ input: Int, _ completion: @escaping Completion) throws {
        try completion(.failed(nil))
    }
}

struct StringBreakBlock: Block {
    typealias Output = String
    
    func run(_ input: Int, _ completion: @escaping Completion) throws {
        try completion(.break("\(input)-END"))
    }
}

// MARK: - Stateful Blocks

struct TestState: BlockState, ExpressibleByNilLiteral {
    var multiplier: Int = 2
    
    init() { self = nil }
    init(nilLiteral: ()) {}
}

struct Add4StateBlock: StateBlock {
    typealias Output = Int
    
    var _state: AssuredValue<TestState> = .init()
    
    func run(_ input: Int, _ completion: @escaping Completion) throws {
        try completion(.done(input * state.multiplier + 4))
    }
}

struct StringToIntStateBlock: StateBlock {
    typealias Output = Int
    
    var _state: AssuredValue<TestState> = .init()
    
    func run(_ input: String, _ completion: @escaping Completion) throws {
        guard let result = Int(input) else {
            return try completion(.failed(nil))
        }
        try completion(.done(result))
    }
}

struct IntFailWithErrorStateBlock: StateBlock {
    typealias Output = String
    
    var _state: AssuredValue<TestState> = .init()
    
    func run(_ input: Int, _ completion: @escaping Completion) throws {
        try completion(.failed(NSError(domain: "", code: 0, userInfo: nil)))
    }
}

struct IntFailWithoutErrorStateBlock: StateBlock {
    typealias Output = String
    
    var _state: AssuredValue<TestState> = .init()
    
    func run(_ input: Int, _ completion: @escaping Completion) throws {
        try completion(.failed(nil))
    }
}
