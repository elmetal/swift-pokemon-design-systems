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
        VStack(spacing: 8) {
            ForEach(configuration.statEntries) { entry in
                HStack(spacing: 8) {
                    Text(entry.kind.formatted(configuration.labelStyle))
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(labelColor)
                        .frame(width: 28, alignment: .leading)

                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(trackColor)

                            filledBar()
                                .frame(width: proxy.size.width * CGFloat(configuration.normalizedValue(for: entry)))
                        }
                    }
                    .frame(height: 8)

                    Text(valueText(for: entry.value))
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(valueColor)
                        .frame(width: 36, alignment: .trailing)
                }
            }
        }
    }

    private func valueText(for value: Double) -> String {
        if value.rounded() == value {
            return String(Int(value))
        }

        return String(format: "%.1f", value)
    }

    @ViewBuilder
    private func filledBar() -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(.tint)
    }
}

public extension PokemonStatChartStyle where Self == BarPokemonStatChartStyle {
    /// A horizontal bar chart style.
    static var bar: Self {
        Self()
    }
}
