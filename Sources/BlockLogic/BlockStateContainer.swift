
public protocol BlockState {}

public protocol StateContainer {
    associatedtype State: BlockState
    associatedtype Value
    
    var state: State { get }
    var value: Value { get }
}

public struct BlockStateContainer<State: BlockState, Value>: StateContainer {
    
    public var state: State
    public var value: Value
}
