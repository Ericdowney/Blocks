
public enum BlockResult<Output> {
    case done(Output)
    case failed(Error?)
}

public protocol Block {
    associatedtype Input
    associatedtype Output
    typealias Completion = (BlockResult<Output>) throws -> Void
    
    func run(_ input: Input, _ completion: @escaping Completion) throws
}

public protocol StateBlock: Block {
    associatedtype State
    
    var _state: AssuredValue<State> { get }
}

public extension StateBlock {
    
    var state: State {
        _state.wrappedValue
    }
}

extension Block {
    
    func eraseToAnyBlock() -> AnyBlock {
        AnyBlock { input, completion in
            guard let nextInput = input as? Input else { throw BlockError.unmatchedInputTypes }
            
            try run(nextInput) { result in
                switch result {
                case .done(let output):
                    try completion(.done(output))
                case .failed(let error):
                    try completion(.failed(error))
                }
            }
        }
    }
}

extension StateBlock {
    
    func eraseToAnyStateBlock() -> AnyStateBlock {
        AnyStateBlock { state, input, completion in
            guard let nextInput = input as? Input else { throw BlockError.unmatchedInputTypes }
            self._state.wrappedValue = state as? State
            
            try run(nextInput) { result in
                switch result {
                case .done(let output):
                    try completion(.done(output))
                case .failed(let error):
                    try completion(.failed(error))
                }
            }
        }
    }
}

public enum BlockError: Error {
    case emptyBlockSequence, unmatchedInputTypes, unmatchedOutputTypes
}

protocol TypeErasedBlock {}

public struct AnyBlock: Block, TypeErasedBlock {
    
    private var block: (Any, @escaping (BlockResult<Any>) throws -> Void) throws -> Void
    
    public init(block: @escaping (Any, @escaping (BlockResult<Any>) throws -> Void) throws -> Void) {
        self.block = block
    }
    
    public func run(_ input: Any, _ completion: @escaping (BlockResult<Any>) throws -> Void) throws {
        try block(input, completion)
    }
}

public struct AnyStateBlock: StateBlock, TypeErasedBlock {
    
    public internal(set) var _state: AssuredValue<Any>
    private var block: (Any, Any, @escaping (BlockResult<Any>) throws -> Void) throws -> Void
    
    public init(block: @escaping (Any, Any, @escaping (BlockResult<Any>) throws -> Void) throws -> Void) {
        self._state = .init()
        self.block = block
    }
    
    public init(state: Any, block: @escaping (Any, Any, @escaping (BlockResult<Any>) throws -> Void) throws -> Void) {
        self._state = .init(state)
        self.block = block
    }
    
    public func run(_ input: Any, _ completion: @escaping (BlockResult<Any>) throws -> Void) throws {
        try block(_state.wrappedValue as Any, input, completion)
    }
}

public struct BlockSequence<SequenceInput, SequenceOutput>: Block, ExpressibleByArrayLiteral {
    
    var blocks: [AnyBlock]
    
    public init(arrayLiteral elements: AnyBlock...) {
        self.blocks = elements
    }
    
    public init(_ elements: [AnyBlock] = []) {
        self.blocks = elements
    }
    
    public mutating func append<B: Block>(_ block: B) {
        blocks.append(block.eraseToAnyBlock())
    }
    
    public func run(_ input: SequenceInput, _ completion: @escaping (BlockResult<SequenceOutput>) throws -> Void) throws {
        guard blocks.count > 0 else { throw BlockError.emptyBlockSequence }
        
        try run(at: 0, input, completion)
    }
    
    private func run(at index: Int, _ nextInput: Any, _ completion: @escaping (BlockResult<SequenceOutput>) throws -> Void) throws {
        if let block = blocks.value(at: index) {
            try block.run(nextInput) { result in
                switch result {
                case .done(let nextInput):
                    try run(at: index + 1, nextInput, completion)
                case .failed(let error):
                    try completion(.failed(error))
                }
            }
        } else if let output = nextInput as? SequenceOutput {
            try completion(.done(output))
        } else {
            throw BlockError.unmatchedOutputTypes
        }
    }
}

public struct StateBlockSequence<State: BlockState, SequenceInput, SequenceOutput>: StateBlock, ExpressibleByArrayLiteral {
    
    public private(set) var _state: AssuredValue<State>
    var blocks: [TypeErasedBlock]
    
    public init(arrayLiteral elements: AnyStateBlock...) {
        self._state = .init()
        self.blocks = elements
    }
    
    public init(_ state: State, _ elements: [AnyStateBlock] = []) {
        self._state = .init(state)
        self.blocks = elements
    }
    
    init(arrayLiteral elements: TypeErasedBlock...) {
        self._state = .init()
        self.blocks = elements
    }
    
    init(_ state: State, _ elements: [TypeErasedBlock] = []) {
        self._state = .init(state)
        self.blocks = elements
    }
    
    public mutating func append<B: StateBlock>(_ block: B) {
        blocks.append(block.eraseToAnyStateBlock())
    }
    
    public func run(_ input: SequenceInput, _ completion: @escaping (BlockResult<SequenceOutput>) throws -> Void) throws {
        guard blocks.count > 0 else { throw BlockError.emptyBlockSequence }
        blocks.compactMap { $0 as? AnyStateBlock }.forEach { $0._state.wrappedValue = _state.wrappedValue }
        
        try run(at: 0, input, completion)
    }
    
    private func run(at index: Int, _ nextInput: Any, _ completion: @escaping (BlockResult<SequenceOutput>) throws -> Void) throws {
        if let block = blocks.value(at: index).flatMap({ $0 as? AnyStateBlock }) {
            try block.run(nextInput) { result in
                switch result {
                case .done(let nextInput):
                    try run(at: index + 1, nextInput, completion)
                case .failed(let error):
                    try completion(.failed(error))
                }
            }
        } else if let block = blocks.value(at: index).flatMap({ $0 as? AnyBlock }) {
            try block.run(nextInput) { result in
                switch result {
                case .done(let nextInput):
                    try run(at: index + 1, nextInput, completion)
                case .failed(let error):
                    try completion(.failed(error))
                }
            }
        } else if let output = nextInput as? SequenceOutput {
            try completion(.done(output))
        } else {
            throw BlockError.unmatchedOutputTypes
        }
    }
}

fileprivate extension Array {
    func value(at index: Index) -> Element? {
        guard index >= 0 && index < endIndex else { return nil }
        return self[index]
    }
}

infix operator -->: AdditionPrecedence

func --><Input, Output, B: Block>(sequence: BlockSequence<Input, Output>, nextBlock: B) -> BlockSequence<Input, Output> {
    BlockSequence<Input, Output>(sequence.blocks + [nextBlock.eraseToAnyBlock()])
}

func --><B1: Block, B2: Block, Input, Output>(previousBlock: B1, nextBlock: B2) -> BlockSequence<Input, Output> where B1.Output == B2.Input {
    BlockSequence<Input, Output>([previousBlock.eraseToAnyBlock(), nextBlock.eraseToAnyBlock()])
}

func --><Input, Output, B: StateBlock>(sequence: StateBlockSequence<B.State, Input, Output>, nextBlock: B) -> StateBlockSequence<B.State, Input, Output> {
    StateBlockSequence<B.State, Input, Output>(nil, sequence.blocks + [nextBlock.eraseToAnyStateBlock()])
}

func --><State, Input, Output, B: Block>(sequence: StateBlockSequence<State, Input, Output>, nextBlock: B) -> StateBlockSequence<State, Input, Output> {
    StateBlockSequence<State, Input, Output>(nil, sequence.blocks + [nextBlock.eraseToAnyBlock()])
}

func --><B1: StateBlock, B2: StateBlock, Input, Output>(previousBlock: B1, nextBlock: B2) -> StateBlockSequence<B1.State, Input, Output> where B1.Output == B2.Input, B1.State == B2.State {
    StateBlockSequence<B1.State, Input, Output>(nil, [previousBlock.eraseToAnyStateBlock(), nextBlock.eraseToAnyStateBlock()])
}

func --><B1: Block, B2: StateBlock, Input, Output>(previousBlock: B1, nextBlock: B2) -> StateBlockSequence<B2.State, Input, Output> where B1.Output == B2.Input {
    StateBlockSequence<B2.State, Input, Output>(nil, [previousBlock.eraseToAnyBlock(), nextBlock.eraseToAnyStateBlock()])
}

func --><B1: StateBlock, B2: Block, Input, Output>(previousBlock: B1, nextBlock: B2) -> StateBlockSequence<B1.State, Input, Output> where B1.Output == B2.Input {
    StateBlockSequence<B1.State, Input, Output>(nil, [previousBlock.eraseToAnyStateBlock(), nextBlock.eraseToAnyBlock()])
}
