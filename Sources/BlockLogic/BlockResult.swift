
public enum BlockResult<Output> {
    case done(Output)
    case `break`(Output)
    case failed(Error?)
}
