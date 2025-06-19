import Testing
@testable import SwiftTesting

struct SwiftTestingSuiteTrait: SuiteTrait, TestScoping {
    func provideScope(for test: Test, testCase: Test.Case?, performing function: () async throws -> Void) async throws {
        guard let name = test.displayName else {
            return
        }

        print("[DEBUG] before suite: \(name))")
        try await function()
        print("[DEBUG] after suite: \(name))")
    }
}

extension Trait where Self == SwiftTestingSuiteTrait {
    static var swiftTestingSuiteTrait: Self { Self() }
}

struct SwiftTestingTestTrait: SuiteTrait, TestTrait, TestScoping {
    // since we apply this to the suite ensure that tests inherit the trait
    // it does not run before the suite, only before each test
    let isRecursive: Bool = true

    func provideScope(for test: Test, testCase: Test.Case?, performing function: () async throws -> Void) async throws {
        print("[DEBUG] before test")
        try await function()
        print("[DEBUG] after test")
    }
}

extension Trait where Self == SwiftTestingTestTrait {
    static var swiftTestingTestTrait: Self { Self() }
}

@Suite("Swift Testing Tests", .serialized, .swiftTestingSuiteTrait)
final class SwiftTestingTests {
    @Suite("Child One", .swiftTestingTestTrait) class ChildOne {
        init() {
            print("[DEBUG] child one init")
        }

        deinit {
            print("[DEBUG] child one deinit")
        }
    }

    @Suite("Child Two") class ChildTwo {
        init() {
            print("[DEBUG] child two init")
        }

        deinit {
            print("[DEBUG] child two deinit")
        }
    }
}

extension SwiftTestingTests.ChildOne {
    @Test func testOne() async throws {
        print("[DEBUG] child one test one")
    }

    @Test func testTwo() async throws {
        print("[DEBUG] child one test two")
    }
}

extension SwiftTestingTests.ChildTwo {
    @Test func testOne() async throws {
        print("[DEBUG] child two test one")
    }

    @Test func testTwo() async throws {
        print("[DEBUG] child two test two")
    }
}
