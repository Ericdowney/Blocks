
public enum BlockResult<Output> {
    case done(Output)
    case failed(Error?)
}
