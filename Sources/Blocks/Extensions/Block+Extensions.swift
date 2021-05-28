
public extension Block {
    
    func eraseToAnyBlock() -> AnyBlock {
        AnyBlock { input, context, completor in
            guard let nextInput = input as? Input else { return completor.failed(BlockError.unmatchedInputTypes) }
            
            run(nextInput, BlockContext(state: context._state)) { result in
                switch result {
                case .done(let output):
                    completor.done(output)
                case .break(let output):
                    completor.break(output)
                case .failed(let error):
                    completor.failed(error)
                }
            }
        }
    }
}

public extension Block where Input == Void {
    
    func run(_ context: BlockContext, _ completion: @escaping (BlockResult<Output>) -> Void) throws {
        run((), context, completion)
    }
    
    func eraseToAnyVoidBlock() -> AnyBlock {
        AnyBlock { input, context, completor in
            run((), BlockContext(state: context._state)) { result in
                switch result {
                case .done(let output):
                    completor.done(output)
                case .break(let output):
                    completor.break(output)
                case .failed(let error):
                    completor.failed(error)
                }
            }
        }
    }
}
