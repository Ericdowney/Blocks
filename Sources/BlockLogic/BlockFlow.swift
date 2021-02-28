
import Foundation

public struct BlockStatefulFlow<State: BlockState, Input, Output>: Block {
    
    // MARK: - Properties
    
    public private(set) var state: State
    public private(set) var sequence: BlockSequence<BlockStateContainer<State, Input>, Output>
    
    // MARK: - Lifecycle
    
    public init(state: State, sequence: BlockSequence<BlockStateContainer<State, Input>, Output>) {
        self.state = state
        self.sequence = sequence
    }
    
    // MARK: - Methods
    
    public func run(_ input: Input, _ completion: @escaping Completion) throws {
        try sequence.run(BlockStateContainer(state: state, value: input), completion)
    }
}

public struct BlockStatelessFlow<Input, Output>: Block {
    
    // MARK: - Properties
    
    public private(set) var sequence: BlockSequence<Input, Output>
    
    // MARK: - Lifecycle
    
    public init(sequence: BlockSequence<Input, Output>) {
        self.sequence = sequence
    }
    
    // MARK: - Methods
    
    public func run(_ input: Input, _ completion: @escaping Completion) throws {
        try sequence.run(input, completion)
    }
}
