
public extension Block {
    
    func eraseToAnyBlock() -> AnyBlock {
        AnyBlock { input, context in
            guard let nextInput = input as? Input else { throw BlockError.unmatchedInputTypes }
            
            return try await run(nextInput, BlockContext(state: context._state))
        }
    }
}

public extension Block where Input == Void {
    
    func run(_ context: BlockContext) async throws -> Output {
        try await run((), context)
    }
    
    func eraseToAnyVoidBlock() -> AnyBlock {
        AnyBlock { input, context in
            try await run((), BlockContext(state: context._state))
        }
    }
}
