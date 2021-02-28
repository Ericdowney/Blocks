
import BlockLogic

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

// MARK: - Stateful Blocks

struct TestState: BlockState {
    var multiplier: Int = 2
}

struct Add4StateBlock: Block {
    typealias Output = Int
    
    func run(_ input: BlockStateContainer<TestState, Int>, _ completion: @escaping Completion) throws {
        try completion(.done(input.value * input.state.multiplier + 4))
    }
}

struct StringToIntStateBlock: Block {
    typealias Output = Int
    
    func run(_ input: BlockStateContainer<TestState, String>, _ completion: @escaping Completion) throws {
        guard let result = Int(input.value) else {
            return try completion(.failed(nil))
        }
        try completion(.done(result))
    }
}
