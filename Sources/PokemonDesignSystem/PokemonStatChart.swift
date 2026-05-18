import SwiftUI

/// A SwiftUI view that draws six Pokemon stat values.
///
/// Use `PokemonStatChart` with one of the built-in chart styles, or provide a
/// custom ``PokemonStatChartStyle``. The chart color follows SwiftUI's standard
/// `tint(_:)` modifier.
///
/// ```swift
/// PokemonStatChart(HP: 108, A: 130, B: 95, C: 80, D: 85, S: 102)
///     .pokemonStatChartStyle(.hexagon)
///     .tint(.pokemonFireTint)
/// ```
public struct PokemonStatChart: View {
    private let stats: PokemonStatValues
    private let maxValue: Double?

    @Environment(\.pokemonStatChartStyle) private var style

    /// Creates a stat chart with the conventional Pokemon stat abbreviations.
    ///
    /// - Parameters:
    ///   - HP: Hit points.
    ///   - A: Attack.
    ///   - B: Defense.
    ///   - C: Special attack.
    ///   - D: Special defense.
    ///   - S: Speed.
    ///   - maxValue: The value used as the full scale of the chart. When `nil`,
    ///     the chart uses the largest supplied stat value.
    public init(
        HP: Double,
        A: Double,
        B: Double,
        C: Double,
        D: Double,
        S: Double,
        maxValue: Double? = nil
    ) {
        self.init(
            stats: PokemonStatValues(
                hp: HP,
                attack: A,
                defense: B,
                specialAttack: C,
                specialDefense: D,
                speed: S
            ),
            maxValue: maxValue
        )
    }

    /// Creates a stat chart with descriptive stat parameter names.
    ///
    /// - Parameters:
    ///   - hp: Hit points.
    ///   - attack: Attack.
    ///   - defense: Defense.
    ///   - specialAttack: Special attack.
    ///   - specialDefense: Special defense.
    ///   - speed: Speed.
    ///   - maxValue: The value used as the full scale of the chart. When `nil`,
    ///     the chart uses the largest supplied stat value.
    public init(
        hp: Double,
        attack: Double,
        defense: Double,
        specialAttack: Double,
        specialDefense: Double,
        speed: Double,
        maxValue: Double? = nil
    ) {
        self.init(
            stats: PokemonStatValues(
                hp: hp,
                attack: attack,
                defense: defense,
                specialAttack: specialAttack,
                specialDefense: specialDefense,
                speed: speed
            ),
            maxValue: maxValue
        )
    }

    init(stats: PokemonStatValues, maxValue: Double? = nil) {
        self.stats = stats
        self.maxValue = maxValue
    }

    /// The chart content.
    public var body: some View {
        AnyView(
            style.makeBody(
                configuration: PokemonStatChartStyleConfiguration(
                    stats: stats,
                    maxValue: resolvedMaxValue
                )
            )
        )
    }

    private var resolvedMaxValue: Double {
        max(maxValue ?? stats.maximumValue, 1)
    }
}

struct PokemonStatValues: Hashable, Sendable {
    var hp: Double
    var attack: Double
    var defense: Double
    var specialAttack: Double
    var specialDefense: Double
    var speed: Double

    init(
        hp: Double,
        attack: Double,
        defense: Double,
        specialAttack: Double,
        specialDefense: Double,
        speed: Double
    ) {
        self.hp = hp
        self.attack = attack
        self.defense = defense
        self.specialAttack = specialAttack
        self.specialDefense = specialDefense
        self.speed = speed
    }

    var entries: [PokemonStatEntry] {
        [
            PokemonStatEntry(kind: .hp, value: hp),
            PokemonStatEntry(kind: .attack, value: attack),
            PokemonStatEntry(kind: .defense, value: defense),
            PokemonStatEntry(kind: .specialAttack, value: specialAttack),
            PokemonStatEntry(kind: .specialDefense, value: specialDefense),
            PokemonStatEntry(kind: .speed, value: speed),
        ]
    }

    var maximumValue: Double {
        entries.map(\.value).max() ?? 1
    }
}

struct PokemonStatEntry: Identifiable, Hashable, Sendable {
    var kind: PokemonStatKind
    var value: Double

    var id: PokemonStatKind {
        kind
    }

    var label: String {
        kind.label
    }

    init(kind: PokemonStatKind, value: Double) {
        self.kind = kind
        self.value = value
    }
}

enum PokemonStatKind: CaseIterable, Hashable, Sendable {
    case hp
    case attack
    case defense
    case specialAttack
    case specialDefense
    case speed

    var label: String {
        switch self {
        case .hp:
            "HP"
        case .attack:
            "A"
        case .defense:
            "B"
        case .specialAttack:
            "C"
        case .specialDefense:
            "D"
        case .speed:
            "S"
        }
    }
}

/// The values and scale passed from a ``PokemonStatChart`` to its style.
///
/// Custom styles receive this configuration from
/// ``PokemonStatChartStyle/makeBody(configuration:)``. Values are exposed both
/// as individual properties and as ordered entries for repeated rendering.
public struct PokemonStatChartStyleConfiguration {
    let stats: PokemonStatValues

    /// The value used as the full scale of the chart.
    public let maxValue: Double

    init(stats: PokemonStatValues, maxValue: Double) {
        self.stats = stats
        self.maxValue = max(maxValue, 1)
    }

    /// Hit points.
    public var hp: Double {
        stats.hp
    }

    /// Attack.
    public var attack: Double {
        stats.attack
    }

    /// Defense.
    public var defense: Double {
        stats.defense
    }

    /// Special attack.
    public var specialAttack: Double {
        stats.specialAttack
    }

    /// Special defense.
    public var specialDefense: Double {
        stats.specialDefense
    }

    /// Speed.
    public var speed: Double {
        stats.speed
    }

    /// The stat entries in HP, Attack, Defense, Special Attack, Special Defense,
    /// Speed order.
    public var entries: [(label: String, value: Double)] {
        statEntries.map { entry in
            (label: entry.label, value: entry.value)
        }
    }

    var statEntries: [PokemonStatEntry] {
        stats.entries
    }

    /// Returns `value` normalized against ``maxValue`` and clamped to `0...1`.
    public func normalizedValue(for value: Double) -> Double {
        min(max(value / maxValue, 0), 1)
    }

    func normalizedValue(for entry: PokemonStatEntry) -> Double {
        min(max(entry.value / maxValue, 0), 1)
    }
}

/// A type that defines the visual representation of a ``PokemonStatChart``.
///
/// Implement this protocol to create custom chart styles. Users apply a style
/// with ``SwiftUICore/View/pokemonStatChartStyle(_:)``.
public protocol PokemonStatChartStyle: Sendable {
    /// The view produced by this style.
    associatedtype Body: View

    /// Creates the styled chart body.
    ///
    /// - Parameter configuration: The stat values and scale supplied by the chart.
    @ViewBuilder
    func makeBody(configuration: PokemonStatChartStyleConfiguration) -> Body
}

public extension View {
    /// Sets the style used by ``PokemonStatChart`` views in this view hierarchy.
    ///
    /// - Parameter style: The chart style to apply.
    func pokemonStatChartStyle(_ style: some PokemonStatChartStyle) -> some View {
        environment(\.pokemonStatChartStyle, style)
    }
}

private struct PokemonStatChartStyleKey: EnvironmentKey {
    static let defaultValue: any PokemonStatChartStyle = HexagonPokemonStatChartStyle()
}

private extension EnvironmentValues {
    var pokemonStatChartStyle: any PokemonStatChartStyle {
        get {
            self[PokemonStatChartStyleKey.self]
        }
        set {
            self[PokemonStatChartStyleKey.self] = newValue
        }
    }
}

#Preview {
    PokemonStatChart(HP: 108, A: 130, B: 95, C: 80, D: 85, S: 102)
        .pokemonStatChartStyle(.hexagon)

    PokemonStatChart(HP: 108, A: 130, B: 95, C: 80, D: 85, S: 102)
        .pokemonStatChartStyle(.bar)
}
