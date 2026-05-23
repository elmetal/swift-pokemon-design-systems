import SwiftUI

/// A horizontal bar chart style for ``PokemonStatChart``.
///
/// Apply this style with ``SwiftUICore/View/pokemonStatChartStyle(_:)`` or the
/// shorthand ``PokemonStatChartStyle/bar`` member.
///
/// ```swift
/// PokemonStatChart(HP: 108, A: 130, B: 95, C: 80, D: 85, S: 102)
///     .pokemonStatChartStyle(.bar)
///     .tint(.pokemonFightingTint)
/// ```
public struct BarPokemonStatChartStyle: PokemonStatChartStyle {
    /// The color used for the unfilled portion of each bar.
    public var trackColor: Color

    /// The color used for stat labels.
    public var labelColor: Color

    /// The color used for stat values.
    public var valueColor: Color

    /// Creates a bar stat chart style.
    ///
    /// - Parameters:
    ///   - trackColor: The color used for the unfilled portion of each bar.
    ///   - labelColor: The color used for stat labels.
    ///   - valueColor: The color used for stat values.
    public init(
        trackColor: Color = Color.secondary.opacity(0.16),
        labelColor: Color = .secondary,
        valueColor: Color = .primary
    ) {
        self.trackColor = trackColor
        self.labelColor = labelColor
        self.valueColor = valueColor
    }

    /// Creates the bar chart body.
    public func makeBody(configuration: PokemonStatChartStyleConfiguration) -> some View {
        BarPokemonStatChartLayout(columnSpacing: 8, rowSpacing: 8) {
            ForEach(configuration.statEntries) { entry in
                Text(entry.kind.formatted(configuration.labelStyle))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(labelColor)
                    .lineLimit(1)

                BarPokemonStatChartBar(
                    normalizedValue: configuration.normalizedValue(for: entry),
                    trackColor: trackColor
                )

                Text(valueText(for: entry.value))
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(valueColor)
                    .lineLimit(1)
            }
        }
    }

    private func valueText(for value: Double) -> String {
        if value.rounded() == value {
            return String(Int(value))
        }

        return String(format: "%.1f", value)
    }
}

private struct BarPokemonStatChartLayout: Layout {
    var columnSpacing: CGFloat
    var rowSpacing: CGFloat

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let metrics = metrics(for: subviews, proposal: proposal)
        return CGSize(width: metrics.width, height: metrics.height)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        let metrics = metrics(
            for: subviews,
            proposal: ProposedViewSize(width: bounds.width, height: bounds.height)
        )
        var y = bounds.minY

        for row in metrics.rows {
            let label = subviews[row.labelIndex]
            let bar = subviews[row.barIndex]
            let value = subviews[row.valueIndex]
            let labelY = y + (row.height - row.labelSize.height) / 2
            let barY = y + (row.height - metrics.barHeight) / 2
            let valueY = y + (row.height - row.valueSize.height) / 2
            let barX = bounds.minX + metrics.labelWidth + columnSpacing
            let valueX = barX + metrics.barWidth + columnSpacing

            label.place(
                at: CGPoint(x: bounds.minX, y: labelY),
                proposal: ProposedViewSize(width: metrics.labelWidth, height: row.labelSize.height)
            )
            bar.place(
                at: CGPoint(x: barX, y: barY),
                proposal: ProposedViewSize(width: metrics.barWidth, height: metrics.barHeight)
            )
            value.place(
                at: CGPoint(x: valueX + metrics.valueWidth, y: valueY),
                anchor: .topTrailing,
                proposal: ProposedViewSize(width: metrics.valueWidth, height: row.valueSize.height)
            )

            y += row.height + rowSpacing
        }
    }

    private func metrics(for subviews: Subviews, proposal: ProposedViewSize) -> Metrics {
        var rows: [Row] = []
        var labelWidth: CGFloat = 0
        var valueWidth: CGFloat = 0

        for labelIndex in stride(from: 0, to: subviews.count, by: 3) {
            let barIndex = labelIndex + 1
            let valueIndex = labelIndex + 2
            guard valueIndex < subviews.count else {
                break
            }

            let labelSize = subviews[labelIndex].sizeThatFits(.unspecified)
            let valueSize = subviews[valueIndex].sizeThatFits(.unspecified)
            labelWidth = max(labelWidth, labelSize.width)
            valueWidth = max(valueWidth, valueSize.width)
            rows.append(
                Row(
                    labelIndex: labelIndex,
                    barIndex: barIndex,
                    valueIndex: valueIndex,
                    labelSize: labelSize,
                    valueSize: valueSize
                )
            )
        }

        let availableWidth = if let proposedWidth = proposal.width, proposedWidth.isFinite {
            proposedWidth
        } else {
            CGFloat(160)
        }
        let barWidth = max(0, availableWidth - labelWidth - valueWidth - columnSpacing * 2)
        let totalWidth = labelWidth + barWidth + valueWidth + columnSpacing * 2
        let rowsWithHeights = rows.map { row in
            Row(
                labelIndex: row.labelIndex,
                barIndex: row.barIndex,
                valueIndex: row.valueIndex,
                labelSize: row.labelSize,
                valueSize: row.valueSize,
                height: max(row.labelSize.height, row.valueSize.height, barHeight)
            )
        }
        let totalHeight = rowsWithHeights.map(\.height).reduce(0, +)
            + rowSpacing * CGFloat(max(rowsWithHeights.count - 1, 0))

        return Metrics(
            rows: rowsWithHeights,
            labelWidth: labelWidth,
            barWidth: barWidth,
            valueWidth: valueWidth,
            width: totalWidth,
            height: totalHeight,
            barHeight: barHeight
        )
    }

    private var barHeight: CGFloat {
        8
    }

    private struct Metrics {
        var rows: [Row]
        var labelWidth: CGFloat
        var barWidth: CGFloat
        var valueWidth: CGFloat
        var width: CGFloat
        var height: CGFloat
        var barHeight: CGFloat
    }

    private struct Row {
        var labelIndex: Int
        var barIndex: Int
        var valueIndex: Int
        var labelSize: CGSize
        var valueSize: CGSize
        var height: CGFloat = 0
    }
}

private struct BarPokemonStatChartBar: View {
    var normalizedValue: Double
    var trackColor: Color

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(trackColor)

                RoundedRectangle(cornerRadius: 4)
                    .fill(.tint)
                    .frame(width: proxy.size.width * CGFloat(normalizedValue))
            }
        }
    }
}

public extension PokemonStatChartStyle where Self == BarPokemonStatChartStyle {
    /// A horizontal bar chart style.
    static var bar: Self {
        Self()
    }
}
