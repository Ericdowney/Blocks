
import Foundation
import Blocks

// MARK: - StateLess Blocks

struct Add4Block: Block {
    typealias Output = Int
    
    func run(_ input: Int, _ completion: @escaping Completion) throws {
        completion(.done(input + 4))
    }
}

struct StringToIntBlock: Block {
    typealias Output = Int
    
    func run(_ input: String, _ completion: @escaping Completion) throws {
        guard let result = Int(input) else {
            return completion(.failed(nil))
        }
        completion(.done(result))
    }
}

struct IntToStringBlock: Block {
    typealias Output = String
    
    func run(_ input: Int, _ completion: @escaping Completion) throws {
        completion(.done("\(input)"))
    }
}

struct ConcatenateStringBlock: Block {
    typealias Output = String
    
    func run(_ input: String, _ completion: @escaping Completion) throws {
        completion(.done(input + "-123"))
    }
}

struct IntFailWithErrorBlock: Block {
    typealias Output = Int
    
    func run(_ input: Int, _ completion: @escaping Completion) throws {
        completion(.failed(NSError(domain: "", code: 0, userInfo: nil)))
    }
}

struct IntFailWithoutErrorBlock: Block {
    typealias Output = Int
    
    func run(_ input: Int, _ completion: @escaping Completion) throws {
        completion(.failed(nil))
    }
}

struct StringBreakBlock: Block {
    typealias Output = String
    
    func run(_ input: Int, _ completion: @escaping Completion) throws {
        completion(.break("\(input)-END"))
    }
}

struct VoidInputVoidOutputBlock: Block {
    typealias Output = Void
    
    func run(_: Void, _ completion: @escaping Completion) throws {
        completion(.done(()))
    }
}

struct VoidInputIntOutputBlock: Block {
    typealias Output = Int
    
    func run(_: Void, _ completion: @escaping Completion) throws {
        completion(.done(39))
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
        completion(.done(input * state.multiplier + 4))
    }
}

struct StringToIntStateBlock: StateBlock {
    typealias Output = Int
    
    var _state: AssuredValue<TestState> = .init()
    
    func run(_ input: String, _ completion: @escaping Completion) throws {
        guard let result = Int(input) else {
            return completion(.failed(nil))
        }
        completion(.done(result))
    }
}

struct IntFailWithErrorStateBlock: StateBlock {
    typealias Output = Int
    
    var _state: AssuredValue<TestState> = .init()
    
    func run(_ input: Int, _ completion: @escaping Completion) throws {
        completion(.failed(NSError(domain: "", code: 0, userInfo: nil)))
    }
}

struct IntFailWithoutErrorStateBlock: StateBlock {
    typealias Output = Int
    
    var _state: AssuredValue<TestState> = .init()
    
    func run(_ input: Int, _ completion: @escaping Completion) throws {
        completion(.failed(nil))
    }
}

struct VoidInputIntOutputStateBlock: StateBlock {
    typealias Output = Int
    
    var _state: AssuredValue<TestState> = .init()
    
    func run(_: Void, _ completion: @escaping Completion) throws {
        completion(.done(_state.wrappedValue.multiplier + 39))
    }
}

struct VoidInputVoidOutputStateBlock: StateBlock {
    typealias Output = Void
    
    var _state: AssuredValue<TestState> = .init()
    
    func run(_: Void, _ completion: @escaping Completion) throws {
        completion(.done(()))
    }
}
