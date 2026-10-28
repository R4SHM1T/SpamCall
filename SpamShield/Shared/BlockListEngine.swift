import Foundation

struct Interval { var lo: Int64; var hi: Int64; var count: Int64 { hi - lo + 1 } }

enum BlockListEngine {
    static let maxEntries: Int64 = 1_800_000

    static func parse(_ text: String) -> (blocks: [Interval], allows: [Interval]) {
        var b = [Interval](), a = [Interval]()
        for raw in text.split(whereSeparator: \.isNewline) {
            var line = String(raw)
            if let h = line.firstIndex(of: "#") { line = String(line[..<h]) }
            let parts = line.split(maxSplits: 1, whereSeparator: { $0.isWhitespace }).map(String.init)
            guard parts.count == 2 else { continue }
            let nums = parts[1].split(separator: "-").map { $0.filter(\.isNumber) }
            guard let lo = nums.first.flatMap({ Int64($0) }) else { continue }
            let hi = nums.count > 1 ? (Int64(nums[1]) ?? lo) : lo
            guard hi >= lo else { continue }
            switch parts[0].lowercased() {
            case "block": b.append(Interval(lo: lo, hi: hi))
            case "allow": a.append(Interval(lo: lo, hi: hi))
            default: break
            }
        }
        return (b, a)
    }

    static func merged(_ xs: [Interval]) -> [Interval] {
        var out = [Interval]()
        for x in xs.sorted(by: { $0.lo < $1.lo }) {
            if let last = out.last, x.lo <= last.hi + 1 { out[out.count - 1].hi = max(last.hi, x.hi) }
            else { out.append(x) }
        }
        return out
    }

    static func subtract(_ blocks: [Interval], _ allows: [Interval]) -> [Interval] {
        var out = [Interval]()
        let al = merged(allows)
        for b in merged(blocks) {
            var lo = b.lo
            for a in al {
                if a.hi < lo { continue }
                if a.lo > b.hi { break }
                if a.lo > lo { out.append(Interval(lo: lo, hi: a.lo - 1)) }
                lo = a.hi + 1
                if lo > b.hi { break }
            }
            if lo <= b.hi { out.append(Interval(lo: lo, hi: b.hi)) }
        }
        return out
    }

    static func intervals(from text: String) -> [Interval] {
        let p = parse(text)
        return subtract(p.blocks, p.allows)
    }

    static func total(_ iv: [Interval]) -> Int64 { iv.reduce(0) { $0 + $1.count } }
    static func contains(_ iv: [Interval], _ n: Int64) -> Bool { iv.contains { $0.lo <= n && n <= $0.hi } }
}
