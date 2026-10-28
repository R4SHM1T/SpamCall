import SwiftUI
import CallKit

struct ContentView: View {
    @State private var status = "Checking…"
    @State private var message = ""
    @State private var test = ""
    @State private var intervals: [Interval] = []

    private var total: Int64 { BlockListEngine.total(intervals) }

    var body: some View {
        NavigationView {
            List {
                Section("Status") {
                    Text(status)
                    Text("Numbers in blocklist: \(total)")
                    if total > BlockListEngine.maxEntries {
                        Text("Over the iOS limit. Only the first \(BlockListEngine.maxEntries) (lowest numbers) load. Trim blocklist.txt.")
                            .foregroundColor(.red)
                    }
                    Button("Reload blocklist into iOS") { reload() }
                    if !message.isEmpty { Text(message).font(.footnote) }
                }
                Section("Would this number be blocked?") {
                    TextField("e.g. 0124 4123456 or +91 98xxxxxxxx", text: $test)
                        .keyboardType(.phonePad)
                    if let n = normalized(test) {
                        Text(BlockListEngine.contains(intervals, n) ? "BLOCKED" : "Allowed: rings normally")
                            .bold()
                    }
                }
                Section("Turn it on") {
                    Text("Settings → Apps → Phone → Call Blocking & Identification → switch on Spam Shield Blocker.")
                    Text("Edit blocklist.txt in your GitHub repo to change ranges; the build makes a new app.")
                        .font(.footnote)
                }
            }
            .navigationTitle("Spam Shield")
        }
        .onAppear { load(); refreshStatus() }
    }

    private func load() {
        if let u = Bundle.main.url(forResource: "blocklist", withExtension: "txt"),
           let t = try? String(contentsOf: u, encoding: .utf8) {
            intervals = BlockListEngine.intervals(from: t)
        }
    }

    private func normalized(_ s: String) -> Int64? {
        var d = s.filter(\.isNumber)
        if d.count == 11 && d.hasPrefix("0") { d.removeFirst() }
        if d.count == 10 { d = "91" + d }
        return Int64(d)
    }

    private var extensionID: String? {
        guard let dir = Bundle.main.builtInPlugInsURL,
              let items = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil),
              let appex = items.first(where: { $0.pathExtension == "appex" }) else { return nil }
        return Bundle(url: appex)?.bundleIdentifier
    }

    private func refreshStatus() {
        guard let id = extensionID else { status = "Extension not found"; return }
        CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(withIdentifier: id) { s, _ in
            DispatchQueue.main.async {
                switch s {
                case .enabled: status = "Protection is ON"
                case .disabled: status = "OFF. Enable it in Settings → Apps → Phone → Call Blocking & Identification"
                default: status = "Unknown" }
            }
        }
    }

    private func reload() {
        guard let id = extensionID else { return }
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: id) { e in
            DispatchQueue.main.async {
                message = e == nil ? "Reloaded." : "Error: \(e!.localizedDescription)"
                refreshStatus()
            }
        }
    }
}
