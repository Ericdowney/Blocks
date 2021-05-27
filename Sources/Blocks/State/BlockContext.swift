
public final class BlockContext {
    
    // MARK: - Properties
    
    private(set) var _state: Any
    
    // MARK: - Lifecycle
    
    public init(state: Any) {
        self._state = state
    }
    
    // MARK: - Methods
    
    public func state<State>(_ type: State.Type = State.self) -> State? {
        _state as? State
    }
    
    public func state<State>(_ type: State.Type = State.self) -> State {
        _state as! State
    }
}
