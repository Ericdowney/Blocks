
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
                case .break(let output):
                    if let output = output as? SequenceOutput {
                        try completion(.done(output))
                    } else {
                        throw BlockError.unmatchedOutputTypes
                    }
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
                case .break(let output):
                    if let output = output as? SequenceOutput {
                        try completion(.done(output))
                    } else {
                        throw BlockError.unmatchedOutputTypes
                    }
                case .failed(let error):
                    try completion(.failed(error))
                }
            }
        } else if let block = blocks.value(at: index).flatMap({ $0 as? AnyBlock }) {
            try block.run(nextInput) { result in
                switch result {
                case .done(let nextInput):
                    try run(at: index + 1, nextInput, completion)
                case .break(let output):
                    if let output = output as? SequenceOutput {
                        try completion(.done(output))
                    } else {
                        throw BlockError.unmatchedOutputTypes
                    }
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
