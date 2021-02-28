import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AssuredValueTests.allTests),
        testCase(BlockStatefulFlowTests.allTests),
        testCase(BlockStateLessFlowTests.allTests),
    ]
}
#endif
