
infix operator -->: AdditionPrecedence

// MARK: - Sequences

public func --><Input1, SequenceBridgeInput, Output2>(sequence1: BlockSet<Input1, SequenceBridgeInput>, sequence2: BlockSet<SequenceBridgeInput, Output2>) -> BlockSet<Input1, Output2> {
    [sequence1.eraseToAnyBlock(), sequence2.eraseToAnyBlock()]
}

// MARK: - Blocks

public func --><B1: Block, B2: Block>(previousBlock: B1, nextBlock: B2) -> BlockSet<B1.Input, B2.Output> where B1.Output == B2.Input {
    if let sequence = previousBlock as? BlockSet<B1.Input, B1.Output> {
        return BlockSet<B1.Input, B2.Output>(sequence.blocks + [nextBlock.eraseToAnyBlock()])
    } else if let sequence = nextBlock as? BlockSet<B2.Input, B2.Output> {
        return BlockSet<B1.Input, B2.Output>([previousBlock.eraseToAnyBlock()] + sequence.blocks)
    }
    return BlockSet<B1.Input, B2.Output>([previousBlock.eraseToAnyBlock(), nextBlock.eraseToAnyBlock()])
}

public func --><B1: Block, B2: Block>(previousBlock: B1, nextBlock: B2) -> BlockSet<B1.Input, B2.Output> where B2.Input == Void {
    if let sequence = previousBlock as? BlockSet<B1.Input, B1.Output> {
        return BlockSet<B1.Input, B2.Output>(sequence.blocks + [nextBlock.eraseToAnyVoidBlock()])
    } else if let sequence = nextBlock as? BlockSet<B2.Input, B2.Output> {
        return BlockSet<B1.Input, B2.Output>([previousBlock.eraseToAnyBlock()] + sequence.blocks)
    }
    return BlockSet<B1.Input, B2.Output>([previousBlock.eraseToAnyBlock(), nextBlock.eraseToAnyVoidBlock()])
}

public func --><B1: Block, B2: Block>(previousBlock: B1, nextBlock: B2) -> BlockSet<B1.Input, B2.Output> where B1.Output == B2.Input, B2.Input == Void {
    if let sequence = previousBlock as? BlockSet<B1.Input, B1.Output> {
        return BlockSet<B1.Input, B2.Output>(sequence.blocks + [nextBlock.eraseToAnyVoidBlock()])
    } else if let sequence = nextBlock as? BlockSet<B2.Input, B2.Output> {
        return BlockSet<B1.Input, B2.Output>([previousBlock.eraseToAnyBlock()] + sequence.blocks)
    }
    return BlockSet<B1.Input, B2.Output>([previousBlock.eraseToAnyBlock(), nextBlock.eraseToAnyVoidBlock()])
}
