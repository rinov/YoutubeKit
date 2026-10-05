// Fractional seeking for the IFrame player, preserving the existing Int API.
extension YTSwiftyPlayer {
    /// Seeks to a finite fractional position. NaN and infinity are ignored.
    /// The generic overload keeps untyped method references bound to the Int API.
    public func seek<Seconds: BinaryFloatingPoint>(to seconds: Seconds, allowSeekAhead: Bool) {
        let position = Double(seconds)
        // Non-finite Swift values do not form valid numeric JavaScript arguments.
        guard position.isFinite else { return }
        evaluatePlayerCommand("seekTo(\(position),\(allowSeekAhead ? 1 : 0))")
    }
}
