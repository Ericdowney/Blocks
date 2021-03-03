
public extension Block {
    
    func eraseToAnyBlock() -> AnyBlock {
        AnyBlock { input, completion in
            guard let nextInput = input as? Input else { throw BlockError.unmatchedInputTypes }
            
            try run(nextInput) { result in
                switch result {
                case .done(let output):
                    try completion(.done(output))
                case .break(let output):
                    try completion(.break(output))
                case .failed(let error):
                    try completion(.failed(error))
                }
            }
        }
    }
}

public extension Block where Input == Void {
    
    func run(_ completion: @escaping Completion) throws {
        try run((), completion)
    }
    
    func eraseToAnyVoidBlock() -> AnyBlock {
        AnyBlock { input, completion in
            try run(()) { result in
                switch result {
                case .done(let output):
                    try completion(.done(output))
                case .break(let output):
                    try completion(.break(output))
                case .failed(let error):
                    try completion(.failed(error))
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
            guard let nextInput = input as? Input else { throw BlockError.unmatchedInputTypes }
            self._state.wrappedValue = state as? State
            
            try run(nextInput) { result in
                switch result {
                case .done(let output):
                    try completion(.done(output))
                case .break(let output):
                    try completion(.break(output))
                case .failed(let error):
                    try completion(.failed(error))
                }
            }
        }
    }
}

public extension StateBlock where Input == Void {
    
    func eraseToAnyVoidStateBlock() -> AnyStateBlock {
        AnyStateBlock { state, input, completion in
            self._state.wrappedValue = state as? State
            
            try run(()) { result in
                switch result {
                case .done(let output):
                    try completion(.done(output))
                case .break(let output):
                    try completion(.break(output))
                case .failed(let error):
                    try completion(.failed(error))
                }
            }
        }
    }
}
