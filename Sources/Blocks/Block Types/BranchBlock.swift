
public func branch<B1: Block, B2: Block>(true: B1, false: B2, condition: @escaping (B1.Input) -> Bool) -> BranchBlock<B1, B2> where B1.Input == B2.Input, B1.Output == B2.Output {
    BranchBlock(true: `true`, false: `false`, condition)
}

public func branch<B1: StateBlock, B2: StateBlock>(true: B1, false: B2, condition: @escaping (B1.Input) -> Bool) -> BranchStateBlock<B1, B2> where B1.State == B2.State, B1.Input == B2.Input, B1.Output == B2.Output {
    BranchStateBlock(true: `true`, false: `false`, condition)
}

public struct BranchBlock<B1: Block, B2: Block>: Block where B1.Input == B2.Input, B1.Output == B2.Output {
    public typealias Input = B1.Input
    public typealias Output = B1.Output
    
    // MARK: - Properties
    
    private var blockA: B1
    private var blockB: B2
    
    private var condition: (Input) -> Bool
    
    // MARK: - Lifecycle
    
    init(
        true blockA: B1,
        false blockB: B2,
        _ condition: @escaping (Input) -> Bool) {
        self.blockA = blockA
        self.blockB = blockB
        self.condition = condition
    }
    
    // MARK: - Methods
    
    public func run(_ input: Input, _ completion: @escaping Completion) throws {
        if condition(input) {
            try blockA.run(input, completion)
        } else {
            try blockB.run(input, completion)
        }
    }
}

public struct BranchStateBlock<B1: StateBlock, B2: StateBlock>: StateBlock where B1.State == B2.State, B1.Input == B2.Input, B1.Output == B2.Output {
    public typealias Input = B1.Input
    public typealias Output = B1.Output
    
    // MARK: - Properties
    
    public var _state: AssuredValue<B1.State>
    
    private var blockA: B1
    private var blockB: B2
    
    private var condition: (Input) -> Bool
    
    // MARK: - Lifecycle
    
    init(
        true blockA: B1,
        false blockB: B2,
        _ condition: @escaping (Input) -> Bool) {
        self._state = .init()
        self.blockA = blockA
        self.blockB = blockB
        self.condition = condition
    }
    
    // MARK: - Methods
    
    public func run(_ input: Input, _ completion: @escaping Completion) throws {
        if condition(input) {
            blockA._state.wrappedValue = _state.wrappedValue
            try blockA.run(input, completion)
        } else {
            blockB._state.wrappedValue = _state.wrappedValue
            try blockB.run(input, completion)
        }
    }
}
