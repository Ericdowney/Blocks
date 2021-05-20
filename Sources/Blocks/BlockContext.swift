
public final class BlockContext<State> {
    
    // MARK: - Properties
    
    public internal(set) var state: State
    
    // MARK: - Lifecycle
    
    public init(state: State) {
        self.state = state
    }
    
    // MARK: - Methods
}
