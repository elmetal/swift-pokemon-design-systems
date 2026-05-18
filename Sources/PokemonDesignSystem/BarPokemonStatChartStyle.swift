import SwiftUI

public struct BarPokemonStatChartStyle: PokemonStatChartStyle {
    public var trackColor: Color
    public var labelColor: Color
    public var valueColor: Color

    public init(
        trackColor: Color = Color.secondary.opacity(0.16),
        labelColor: Color = .secondary,
        valueColor: Color = .primary
    ) {
        self.trackColor = trackColor
        self.labelColor = labelColor
        self.valueColor = valueColor
    }

    public func makeBody(configuration: PokemonStatChartStyleConfiguration) -> some View {
        VStack(spacing: 8) {
            ForEach(configuration.statEntries) { entry in
                HStack(spacing: 8) {
                    Text(entry.label)
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
    static var bar: Self {
        Self()
    }
}
