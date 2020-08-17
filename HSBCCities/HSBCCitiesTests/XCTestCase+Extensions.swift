import Foundation
import XCTest

extension XCTestCase {
    func waitUntil(timeout: TimeInterval = 0.5, isInverted: Bool = false, block: @escaping () -> Bool) {
        // https://bou.io/CTTRunLoopRunUntil.html
        var fulfilled = false
        
        let beforeWaiting: (CFRunLoopObserver?, CFRunLoopActivity) -> Void = { _, _ in
            assert(!fulfilled)
            fulfilled = block()
            if fulfilled {
                CFRunLoopStop(CFRunLoopGetCurrent())
            } else {
                CFRunLoopWakeUp(CFRunLoopGetCurrent())
            }
        }
        
        let observer = CFRunLoopObserverCreateWithHandler(nil, CFRunLoopActivity.beforeWaiting.rawValue, true, 0, beforeWaiting)
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, .defaultMode)
        CFRunLoopRunInMode(.defaultMode, timeout, false)
        CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), observer, .defaultMode)
        
        if !fulfilled && !isInverted {
            XCTFail("Waiting timed out")
        }
        if fulfilled && isInverted {
            XCTFail("Should not fulfill when inverted")
        }
    }
}
