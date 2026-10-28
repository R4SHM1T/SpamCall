// EDIT THIS FILE to change what gets blocked (on GitHub: open file, pencil icon, commit).
// Lines:  block <number or START-END>   |   allow <number or START-END>
// India = 91 + number. 0124-4579432 -> 91 124 4579432. Lines starting with # are ignored.
enum BlockList {
    static let text = """
    # Built from your call log (Oct 2026): sequential 1000-number call-centre blocks.
    block 91 124 4579000-4579999
    block 91 124 4730000-4730999
    block 91 124 6512000-6514999

    # Rotation buffer: uncomment (delete the #) if spam moves to neighbouring blocks.
    # block 91 124 4578000-4578999
    # block 91 124 4580000-4580999
    # block 91 124 4731000-4731999
    # block 91 124 6515000-6515999

    # Exceptions: a real caller caught by a range above.
    # allow 91 124 4579123
    """
}
