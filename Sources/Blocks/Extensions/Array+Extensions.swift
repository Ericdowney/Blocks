
extension Array {
    
    func value(at index: Index) -> Element? {
        guard index >= 0 && index < endIndex else { return nil }
        return self[index]
    }
}
