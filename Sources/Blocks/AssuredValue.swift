
@propertyWrapper
public final class AssuredValue<Value> {
    
    public var wrappedValue: Value!
    
    public init(_ value: Value? = nil) {
        self.wrappedValue = value
    }
}

extension AssuredValue: CustomStringConvertible {
    public var description: String {
        if let value = wrappedValue {
            return "AssuredValue<\(Value.self)>: \(value)"
        }
        return "AssuredValue<\(Value.self)>: nil"
    }
}
