
public extension Block {
    
    func eraseToAnyBlock() -> AnyBlock {
        AnyBlock { input, completion in
            guard let nextInput = input as? Input else { return completion(.failed(BlockError.unmatchedInputTypes)) }
            
            run(nextInput) { result in
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
    
    func run(_ completion: @escaping Completion) throws {
        run((), completion)
    }
    
    func eraseToAnyVoidBlock() -> AnyBlock {
        AnyBlock { input, completion in
            run(()) { result in
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

public extension StateBlock {
    
    var state: State {
        _state.wrappedValue
    }
    
    func eraseToAnyStateBlock() -> AnyStateBlock {
        AnyStateBlock { state, input, completion in
            guard let nextInput = input as? Input else { return completion(.failed(BlockError.unmatchedInputTypes)) }
            self._state.wrappedValue = state as? State
            
            run(nextInput) { result in
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

public extension StateBlock where Input == Void {
    
    func eraseToAnyVoidStateBlock() -> AnyStateBlock {
        AnyStateBlock { state, input, completion in
            self._state.wrappedValue = state as? State
            
            run(()) { result in
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
