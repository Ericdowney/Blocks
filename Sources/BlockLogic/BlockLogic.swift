
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

extension Block where Input: StateContainer {
    
    func eraseToAnyBlockWithContainer() -> AnyBlock {
        AnyBlock { input, completion in
            guard let nextInput = input as? Input else { throw BlockError.unmatchedInputTypes }
            
            try run(nextInput) { result in
                print("Result", result)
                switch result {
                case .done(let output):
                    try completion(.done(BlockStateContainer(state: nextInput.state, value: output)))
                case .failed(let error):
                    try completion(.failed(error))
                }
            }
        }
    }
}

enum BlockError: Error {
    case emptyBlockSequence, unmatchedInputTypes, unmatchedOutputTypes
}

public struct AnyBlock: Block {
    
    private var block: (Any, @escaping (BlockResult<Any>) throws -> Void) throws -> Void
    
    public init(block: @escaping (Any, @escaping (BlockResult<Any>) throws -> Void) throws -> Void) {
        self.block = block
    }
    
    public func run(_ input: Any, _ completion: @escaping (BlockResult<Any>) throws -> Void) throws {
        try block(input, completion)
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
            print("Input", nextInput)
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

func --><B1: Block, B2: Block, Input, Output>(previousBlock: B1, nextBlock: B2) -> BlockSequence<Input, Output> {
    BlockSequence<Input, Output>([previousBlock.eraseToAnyBlock(), nextBlock.eraseToAnyBlock()])
}

func --><Input, Output, B: Block>(sequence: BlockSequence<Input, Output>, nextBlock: B) -> BlockSequence<Input, Output> where B.Input: StateContainer {
    BlockSequence<Input, Output>(sequence.blocks + [nextBlock.eraseToAnyBlockWithContainer()])
}

func --><B1: Block, B2: Block, Input, Output>(previousBlock: B1, nextBlock: B2) -> BlockSequence<Input, Output> where B1.Input: StateContainer, B2.Input: StateContainer {
    BlockSequence<Input, Output>([previousBlock.eraseToAnyBlockWithContainer(), nextBlock.eraseToAnyBlockWithContainer()])
}
