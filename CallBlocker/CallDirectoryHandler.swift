import CallKit
import Foundation

class CallDirectoryHandler: CXCallDirectoryProvider {
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        if context.isIncremental { context.removeAllBlockingEntries() }
        guard let url = Bundle.main.url(forResource: "blocklist", withExtension: "txt"),
              let text = try? String(contentsOf: url, encoding: .utf8) else {
            context.completeRequest(); return
        }
        var added: Int64 = 0
        outer: for iv in BlockListEngine.intervals(from: text) {
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
