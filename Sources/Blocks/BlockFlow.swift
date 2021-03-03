
public func flow<Input, Output>(for sequence: BlockSequence<Input, Output>) -> BlockStatelessFlow<Input, Output> {
    .init(sequence: sequence)
}

public func flow<State: BlockState, Input, Output>(for sequence: StateBlockSequence<State, Input, Output>, with state: State) -> BlockStatefulFlow<State, Input, Output> {
    .init(state: state, sequence: sequence)
}

public struct BlockStatefulFlow<State: BlockState, Input, Output>: StateBlock {
    
    // MARK: - Properties
    
    public private(set) var _state: AssuredValue<State>
    public private(set) var sequence: StateBlockSequence<State, Input, Output>
    
    // MARK: - Lifecycle
    
    public init(state: State, sequence: StateBlockSequence<State, Input, Output>) {
        self._state = .init(state)
        self.sequence = sequence
    }
    
    // MARK: - Methods
    
    public func run(_ input: Input, _ completion: @escaping Completion) {
        self.sequence._state.wrappedValue = _state.wrappedValue
        sequence.run(input, completion)
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
    
    public func run(_ input: Input, _ completion: @escaping Completion) {
        sequence.run(input, completion)
    }
}
