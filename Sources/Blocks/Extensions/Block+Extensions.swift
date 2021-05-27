
public extension Block {
    
    func eraseToAnyBlock() -> AnyBlock {
        AnyBlock { input, context, completion in
            guard let nextInput = input as? Input else { return completion(.failed(BlockError.unmatchedInputTypes)) }
            
            run(nextInput, BlockContext(state: context._state)) { result in
                switch result {
                case .done(let output):
                    completion(.done(output))
                case .break(let output):
                    completion(.break(output))
                case .failed(let error):
                    completion(.failed(error))
                }
            }
        }
    }
}

public extension Block where Input == Void {
    
    func run(_ context: BlockContext, _ completion: @escaping Completion) throws {
        run((), context, completion)
    }
    
    func eraseToAnyVoidBlock() -> AnyBlock {
        AnyBlock { input, context, completion in
            run((), BlockContext(state: context._state)) { result in
                switch result {
                case .done(let output):
                    completion(.done(output))
                case .break(let output):
                    completion(.break(output))
                case .failed(let error):
                    completion(.failed(error))
                }
            }
        }
    }
}
