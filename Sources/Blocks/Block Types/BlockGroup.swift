
public protocol BlockGroup {
    associatedtype Input
    associatedtype Output
    associatedtype State
    
    var state: State { get }
    @BlockSetBuilder var set: BlockSet<Input, Output> { get }
}

extension BlockGroup {
    
    public func callAsFunction(input: Input) async throws -> Output {
        try await set.run(input, .init(state: state))
    }
    
    public func run(_ input: Input) async throws -> Output {
        try await set.run(input, .init(state: state))
    }
    
    func eraseToAnyBlock() -> AnyBlock {
        AnyBlock { input, context in
            guard let nextInput = input as? Input else { throw BlockError.unmatchedInputTypes }

            return try await run(nextInput, state)
        }
    }
    
    private func run(_ input: Input, _ state: State) async throws -> Output {
        try await set.run(input, .init(state: state))
    }
}

extension BlockGroup where Input == Void {
    
    public func callAsFunction() async throws -> Output {
        try await set.run((), .init(state: state))
    }
    
    public func run() async throws -> Output {
        try await set.run((), .init(state: state))
    }
}

extension BlockGroup where State == EmptyState {
    
    public var state: EmptyState { .init() }
}

@resultBuilder
public struct BlockSetBuilder {
    
    public static func buildBlock<B1: Block>(_ block1: B1) -> BlockSet<B1.Input, B1.Output> {
        BlockSet([block1.eraseToAnyBlock()])
    }
    
    public static func buildBlock<B1: Block, B2: Block>(_ block1: B1, _ block2: B2) -> BlockSet<B1.Input, B2.Output> where B1.Output == B2.Input {
        BlockSet([block1.eraseToAnyBlock(), block2.eraseToAnyBlock()])
    }
    
    public static func buildBlock<B1: Block, B2: Block, B3: Block>(_ block1: B1, _ block2: B2, _ block3: B3) -> BlockSet<B1.Input, B3.Output> where B1.Output == B2.Input, B2.Output == B3.Input {
        BlockSet([block1.eraseToAnyBlock(), block2.eraseToAnyBlock(), block3.eraseToAnyBlock()])
    }
    
    public static func buildBlock<B1: Block, B2: Block, B3: Block, B4: Block>(_ block1: B1, _ block2: B2, _ block3: B3, _ block4: B4) -> BlockSet<B1.Input, B4.Output> where B1.Output == B2.Input, B2.Output == B3.Input, B3.Output == B4.Input {
        BlockSet([block1.eraseToAnyBlock(), block2.eraseToAnyBlock(), block3.eraseToAnyBlock(), block4.eraseToAnyBlock()])
    }
    
    public static func buildBlock<B1: Block, B2: Block, B3: Block, B4: Block, B5: Block>(_ block1: B1, _ block2: B2, _ block3: B3, _ block4: B4, _ block5: B5) -> BlockSet<B1.Input, B5.Output> where B1.Output == B2.Input, B2.Output == B3.Input, B3.Output == B4.Input, B4.Output == B5.Input {
        BlockSet([block1.eraseToAnyBlock(), block2.eraseToAnyBlock(), block3.eraseToAnyBlock(), block4.eraseToAnyBlock(), block5.eraseToAnyBlock()])
    }
    
    public static func buildEither<Input, Output, B1: Block>(first: B1) -> BlockSet<Input, Output> where B1.Input == Input, B1.Output == Output {
        BlockSet([first.eraseToAnyBlock()])
    }
    
    public static func buildEither<Input, Output, B1: Block>(second: B1) -> BlockSet<Input, Output> where B1.Input == Input, B1.Output == Output {
        BlockSet([second.eraseToAnyBlock()])
    }
    
    // MARK: - Build BlockSets
    
    public static func buildBlock<Input, BridgeOutputInput, Output>(_ blockSet1: BlockSet<Input, BridgeOutputInput>, _ blockSet2: BlockSet<BridgeOutputInput, Output>) -> BlockSet<Input, Output> {
        BlockSet([blockSet1.eraseToAnyBlock(), blockSet2.eraseToAnyBlock()])
    }
    
    public static func buildEither<Input, Output>(first: BlockSet<Input, Output>) -> BlockSet<Input, Output> {
        BlockSet([first.eraseToAnyBlock()])
    }
    
    public static func buildEither<Input, Output>(second: BlockSet<Input, Output>) -> BlockSet<Input, Output> {
        BlockSet([second.eraseToAnyBlock()])
    }
    
    // MARK: - Build BlockGroups
    
    public static func buildBlock<BG1: BlockGroup, BG2: BlockGroup>(_ blockGroup1: BG1, _ blockGroup2: BG2) -> BlockSet<BG1.Input, BG2.Output> where BG1.Output == BG2.Input, BG1.State == BG2.State {
        BlockSet([blockGroup1.eraseToAnyBlock(), blockGroup2.eraseToAnyBlock()])
    }
}
