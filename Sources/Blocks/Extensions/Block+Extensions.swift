
public extension Block {
    
    func eraseToAnyBlock() -> AnyBlock {
        AnyBlock { input, context, completion in
            guard let nextInput = input as? Input else { return completion(.failed(BlockError.unmatchedInputTypes)) }
            guard let state = context.state as? State else { return completion(.failed(BlockError.unmatchedContextTypes)) }
            
            do {
                try run(nextInput, BlockContext(state: state)) { result in
                    switch result {
                    case .done(let output):
                        completion(.done(output))
                    case .break(let output):
                        completion(.break(output))
                    case .failed(let error):
                        completion(.failed(error))
                    }
                }
            } catch {
                completion(.failed(error))
            }
        }
    }
}

public extension Block where Input == Void {
    
    func run(_ context: BlockContext<State>, _ completion: @escaping Completion) throws {
        try run((), context, completion)
    }
    
    func eraseToAnyVoidBlock() -> AnyBlock {
        AnyBlock { input, context, completion in
            guard let state = context.state as? State else { return completion(.failed(BlockError.unmatchedContextTypes)) }
            
            do {
                try run((), BlockContext(state: state)) { result in
                    switch result {
                    case .done(let output):
                        completion(.done(output))
                    case .break(let output):
                        completion(.break(output))
                    case .failed(let error):
                        completion(.failed(error))
                    }
                }
            } catch {
                completion(.failed(error))
            }
        }
    }
}
