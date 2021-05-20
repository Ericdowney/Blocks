
public struct EmptyState: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {}
}

public protocol BlockGroup {
    associatedtype Input
    associatedtype Output
    associatedtype State: ExpressibleByNilLiteral
    
    var state: State { get }
    @BlockSetBuilder var set: BlockSet<Input, Output, State> { get }
}

extension BlockGroup {
    
    public func run(_ input: Input, _ completion: @escaping (BlockResult<Output>) -> Void) {
        set.run(input, .init(state: state), completion)
    }
}

extension BlockGroup where State == EmptyState {
    
    var state: EmptyState { nil }
}

@_functionBuilder
public struct BlockSetBuilder {
    
    public static func buildBlock<B1: Block>(_ block1: B1) -> BlockSet<B1.Input, B1.Output, B1.State> {
        BlockSet<B1.Input, B1.Output, B1.State>([block1.eraseToAnyBlock()])
    }
    
    public static func buildBlock<B1: Block, B2: Block>(_ block1: B1, _ block2: B2) -> BlockSet<B1.Input, B2.Output, B1.State> where B1.Output == B2.Input, B1.State == B2.State {
        BlockSet<B1.Input, B2.Output, B1.State>([block1.eraseToAnyBlock(), block2.eraseToAnyBlock()])
    }
    
    public static func buildBlock<B1: Block, B2: Block, B3: Block>(_ block1: B1, _ block2: B2, _ block3: B3) -> BlockSet<B1.Input, B3.Output, B1.State> where B1.Output == B2.Input, B2.Output == B3.Input, B1.State == B2.State, B1.State == B3.State {
        BlockSet<B1.Input, B3.Output, B1.State>([block1.eraseToAnyBlock(), block2.eraseToAnyBlock(), block3.eraseToAnyBlock()])
    }
    
    public static func buildBlock<B1: Block, B2: Block, B3: Block, B4: Block>(_ block1: B1, _ block2: B2, _ block3: B3, _ block4: B4) -> BlockSet<B1.Input, B4.Output, B1.State> where B1.Output == B2.Input, B2.Output == B3.Input, B3.Output == B4.Input, B1.State == B2.State, B1.State == B3.State, B1.State == B4.State {
        BlockSet<B1.Input, B4.Output, B1.State>([block1.eraseToAnyBlock(), block2.eraseToAnyBlock(), block3.eraseToAnyBlock(), block4.eraseToAnyBlock()])
    }
    
    public static func buildBlock<B1: Block, B2: Block, B3: Block, B4: Block, B5: Block>(_ block1: B1, _ block2: B2, _ block3: B3, _ block4: B4, _ block5: B5) -> BlockSet<B1.Input, B5.Output, B1.State> where B1.Output == B2.Input, B2.Output == B3.Input, B3.Output == B4.Input, B4.Output == B5.Input, B1.State == B2.State, B1.State == B3.State, B1.State == B4.State, B1.State == B5.State {
        BlockSet<B1.Input, B5.Output, B1.State>([block1.eraseToAnyBlock(), block2.eraseToAnyBlock(), block3.eraseToAnyBlock(), block4.eraseToAnyBlock(), block5.eraseToAnyBlock()])
    }
    
    public static func buildEither<Input, Output, State, B1: Block>(first: B1) -> BlockSet<Input, Output, State> where B1.Input == Input, B1.Output == Output, B1.State == State {
        return BlockSet<Input, Output, State>([first.eraseToAnyBlock()])
    }
    
    public static func buildEither<Input, Output, State, B1: Block>(second: B1) -> BlockSet<Input, Output, State> where B1.Input == Input, B1.Output == Output, B1.State == State {
        return BlockSet<Input, Output, State>([second.eraseToAnyBlock()])
    }
}

struct IntToString: Block {
    
    func run(_ input: Int, _ context: BlockContext<EmptyState>, _ completion: @escaping (BlockResult<String>) -> Void) throws {
        completion(.done("\(input)"))
    }
}

struct StringToInt: Block {
    
    func run(_ input: String, _ context: BlockContext<EmptyState>, _ completion: @escaping (BlockResult<Int>) -> Void) throws {
        completion(.done(Int(input) ?? 0))
    }
}

struct StringToString: Block {
    
    func run(_ input: String, _ context: BlockContext<EmptyState>, _ completion: @escaping (BlockResult<String>) -> Void) throws {
        completion(.done("\(input)123"))
    }
}

struct StringCustomStateToString: Block {
    
    func run(_ input: String, _ context: BlockContext<CustomState>, _ completion: @escaping (BlockResult<String>) -> Void) throws {
        completion(.done("\(context.state.prefix)\(input)"))
    }
}

func createSet<Input, Output, State>() -> BlockSet<Input, Output, State> {
    BlockSet<Input, Output, State>()
}

struct CustomState {
    var prefix: String = "prefix_"
}

struct Thing1: BlockGroup {
    
    var value: Bool = true
    var set: BlockSet<Int, String, EmptyState> {
        IntToString()
        StringToInt()
        IntToString()
        StringCustomStateToString()
        if value {
            StringToString()
            StringToInt()
            IntToString()
        }
        else {
            StringToString()
        }
    }
}
