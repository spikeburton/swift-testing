import Testing
@testable import SwiftTesting

struct SwiftTestingTrait: SuiteTrait, TestScoping {
    func provideScope(for test: Test, testCase: Test.Case?, performing function: () async throws -> Void) async throws {
        guard let name = test.displayName else {
            return
        }

        print("[DEBUG] starting suite: \(name))")
        try await function()
        print("[DEBUG] finished suite: \(name))")
    }
}

extension Trait where Self == SwiftTestingTrait {
    static var swiftTestingTrait: Self { Self() }
}

@Suite("Swift Testing Tests", .serialized, .swiftTestingTrait)
final class SwiftTestingTests {
    @Suite("Child One") class ChildOne {
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
