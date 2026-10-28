// EDIT THIS FILE to change what gets blocked (GitHub: open file -> pencil icon -> commit).
// rng(prefix, from, to): India landline 0124-4579432 -> prefix 91124, number 4579432.
// Mobile/other numbers: use one("919876543210") for a single number.

private func rng(_ prefix: Int64, _ from: Int64, _ to: Int64) -> Interval {
    Interval(lo: prefix * 10_000_000 + from, hi: prefix * 10_000_000 + to)
}
private func one(_ n: Int64) -> Interval { Interval(lo: n, hi: n) }

enum BlockList {
    // From your call log (Oct 2026): sequential 1000-number call-centre blocks.
    static let block: [Interval] = [
        rng(91124, 4579000, 4579999),
        rng(91124, 4730000, 4730999),
        rng(91124, 6512000, 6514999),
        // Rotation buffer (remove the // to enable):
        // rng(91124, 4578000, 4578999),
        // rng(91124, 4580000, 4580999),
        // rng(91124, 4731000, 4731999),
        // rng(91124, 6515000, 6515999),
    ]

    // Exceptions: real callers caught by a range above.
    static let allow: [Interval] = [
        // one(911244579123),
    ]

    static var active: [Interval] { BlockListEngine.subtract(block, allow) }
}
