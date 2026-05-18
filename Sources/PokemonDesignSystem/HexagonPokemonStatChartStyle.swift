import SwiftUI

/// A hexagon radar chart style for ``PokemonStatChart``.
///
/// Apply this style with ``SwiftUICore/View/pokemonStatChartStyle(_:)`` or the
/// shorthand ``PokemonStatChartStyle/hexagon`` member.
///
/// ```swift
/// PokemonStatChart(HP: 108, A: 130, B: 95, C: 80, D: 85, S: 102)
///     .pokemonStatChartStyle(.hexagon)
///     .tint(.pokemonDragonTint)
/// ```
public struct HexagonPokemonStatChartStyle: PokemonStatChartStyle {
    /// The color used for the radar grid.
    public var gridColor: Color

    /// The color used for stat labels and values.
    public var labelColor: Color

    /// The number of grid rings drawn inside the chart.
    public var ringCount: Int

    /// The label distance from the chart center, expressed as a fraction of the
    /// chart size.
    public var labelRadiusScale: CGFloat

    /// Creates a hexagon stat chart style.
    ///
    /// - Parameters:
    ///   - gridColor: The color used for the radar grid.
    ///   - labelColor: The color used for stat labels and values.
    ///   - ringCount: The number of grid rings drawn inside the chart.
    ///   - labelRadiusScale: The label distance from the chart center, expressed
    ///     as a fraction of the chart size.
    public init(
        gridColor: Color = Color.secondary.opacity(0.3),
        labelColor: Color = .secondary,
        ringCount: Int = 4,
        labelRadiusScale: CGFloat = 0.42
    ) {
        self.gridColor = gridColor
        self.labelColor = labelColor
        self.ringCount = ringCount
        self.labelRadiusScale = labelRadiusScale
    }

    /// Creates the hexagon chart body.
    public func makeBody(configuration: PokemonStatChartStyleConfiguration) -> some View {
        GeometryReader { proxy in
            let chartSize = min(proxy.size.width, proxy.size.height)
            let chartRect = CGRect(origin: .zero, size: CGSize(width: chartSize, height: chartSize))

            ZStack {
                PokemonStatHexagonGridShape(ringCount: ringCount)
                    .stroke(gridColor, lineWidth: 1)
                    .frame(width: chartSize, height: chartSize)

                filledHexagon(configuration: configuration)
                    .frame(width: chartSize, height: chartSize)

                strokedHexagon(configuration: configuration)
                    .frame(width: chartSize, height: chartSize)

                ForEach(Array(hexagonEntries(from: configuration).enumerated()), id: \.element.id) { index, entry in
                    VStack(spacing: 1) {
                        Text(entry.label)
                            .font(.caption)
                            .fontWeight(.semibold)

                        Text(valueText(for: entry.value))
                            .font(.caption2)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(labelColor)
                    .fixedSize()
                    .multilineTextAlignment(.center)
                    .position(labelPosition(index: index, in: chartRect))
                }
            }
            .frame(width: chartSize, height: chartSize)
            .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func hexagonEntries(from configuration: PokemonStatChartStyleConfiguration) -> [PokemonStatEntry] {
        [
            configuration.statEntries[0],
            configuration.statEntries[1],
            configuration.statEntries[2],
            configuration.statEntries[5],
            configuration.statEntries[4],
            configuration.statEntries[3],
        ]
    }

    @ViewBuilder
    private func filledHexagon(configuration: PokemonStatChartStyleConfiguration) -> some View {
        let shape = PokemonStatHexagonShape(
            entries: hexagonEntries(from: configuration),
            maxValue: configuration.maxValue
        )

        shape.fill(.tint.opacity(0.24))
    }

    @ViewBuilder
    private func strokedHexagon(configuration: PokemonStatChartStyleConfiguration) -> some View {
        let shape = PokemonStatHexagonShape(
            entries: hexagonEntries(from: configuration),
            maxValue: configuration.maxValue
        )

        shape.stroke(.tint, lineWidth: 2)
    }

    private func labelPosition(index: Int, in rect: CGRect) -> CGPoint {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) * labelRadiusScale
        let angle = Angle.degrees(Double(index) * 60 - 90).radians

        return CGPoint(
            x: center.x + cos(angle) * radius,
            y: center.y + sin(angle) * radius
        )
    }

    private func valueText(for value: Double) -> String {
        if value.rounded() == value {
            return String(Int(value))
        }

        return String(format: "%.1f", value)
    }
}

public extension PokemonStatChartStyle where Self == HexagonPokemonStatChartStyle {
    /// A hexagon radar chart style.
    static var hexagon: Self {
        Self()
    }
}

private struct PokemonStatHexagonGridShape: Shape {
    var ringCount: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let maximumRadius = min(rect.width, rect.height) * 0.36
        let rings = max(ringCount, 1)

        for ring in 1...rings {
            let radius = maximumRadius * CGFloat(ring) / CGFloat(rings)
            addHexagon(to: &path, center: center, radius: radius)
        }

        for point in polygonPoints(center: center, radius: maximumRadius) {
            path.move(to: center)
            path.addLine(to: point)
        }

        return path
    }

    private func addHexagon(to path: inout Path, center: CGPoint, radius: CGFloat) {
        let points = polygonPoints(center: center, radius: radius)
        guard let firstPoint = points.first else {
            return
        }

        path.move(to: firstPoint)
        points.dropFirst().forEach { path.addLine(to: $0) }
        path.closeSubpath()
    }

    private func polygonPoints(center: CGPoint, radius: CGFloat) -> [CGPoint] {
        (0..<6).map { index in
            let angle = Angle.degrees(Double(index) * 60 - 90).radians

            return CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )
        }
    }
}

private struct PokemonStatHexagonShape: Shape {
    var entries: [PokemonStatEntry]
    var maxValue: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let maximumRadius = min(rect.width, rect.height) * 0.36
        let points = entries.enumerated().map { index, entry in
            let angle = Angle.degrees(Double(index) * 60 - 90).radians
            let normalizedValue = min(max(entry.value / max(maxValue, 1), 0), 1)
            let radius = maximumRadius * CGFloat(normalizedValue)

            return CGPoint(
                x: center.x + cos(angle) * radius,
                y: center.y + sin(angle) * radius
            )
        }

        guard let firstPoint = points.first else {
            return path
        }

        path.move(to: firstPoint)
        points.dropFirst().forEach { path.addLine(to: $0) }
        path.closeSubpath()

        return path
    }
}
