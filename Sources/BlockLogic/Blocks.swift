
public protocol Block {
    associatedtype Input
    associatedtype Output
    typealias Completion = (BlockResult<Output>) throws -> Void
    
    func run(_ input: Input, _ completion: @escaping Completion) throws
}

public protocol StateBlock: Block {
    associatedtype State
    
    var _state: AssuredValue<State> { get }
}

public extension StateBlock {
    
    var state: State {
        _state.wrappedValue
    }
}

extension Block {
    
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

extension StateBlock {
    
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
