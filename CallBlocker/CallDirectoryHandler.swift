import CallKit
import Foundation

class CallDirectoryHandler: CXCallDirectoryProvider {
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        if context.isIncremental { context.removeAllBlockingEntries() }
        var added: Int64 = 0
        outer: for iv in BlockList.active {
            var n = iv.lo
            while n <= iv.hi {
                if added >= BlockListEngine.maxEntries { break outer }
                context.addBlockingEntry(withNextSequentialPhoneNumber: CXCallDirectoryPhoneNumber(n))
                added += 1; n += 1
            }
        }
        context.completeRequest()
    }
}
