import Foundation
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
    @Environment(\.pokemonStatChartLabelStyle) private var labelStyle

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
                    maxValue: resolvedMaxValue,
                    labelStyle: labelStyle
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
        kind.formatted()
    }

    init(kind: PokemonStatKind, value: Double) {
        self.kind = kind
        self.value = value
    }
}

/// A standard Pokemon stat.
public enum PokemonStatKind: CaseIterable, Hashable, Sendable {
    case hp
    case attack
    case defense
    case specialAttack
    case specialDefense
    case speed
}

public extension PokemonStatKind {
    /// A format style for Pokemon stat labels.
    struct FormatStyle: Foundation.FormatStyle, Hashable, Codable, Sendable {
        /// The amount of detail to include in formatted stat labels.
        public enum Width: Hashable, Codable, Sendable {
            /// One-letter labels: H, A, B, C, D, and S.
            case abbreviated

            /// Compact localized labels, such as Atk or 特攻.
            case short

            /// Full localized stat names, such as Attack or こうげき.
            case wide
        }

        public typealias FormatInput = PokemonStatKind
        public typealias FormatOutput = String

        /// The label width to use.
        public var width: Width

        /// The locale used for localized labels.
        public var locale: Locale

        /// Creates a Pokemon stat label format style.
        ///
        /// - Parameters:
        ///   - width: The amount of detail to include in formatted labels.
        ///   - locale: The locale used for localized labels.
        public init(width: Width = .abbreviated, locale: Locale = .autoupdatingCurrent) {
            self.width = width
            self.locale = locale
        }

        /// Formats a Pokemon stat kind.
        public func format(_ value: PokemonStatKind) -> String {
            switch width {
            case .abbreviated:
                value.abbreviatedLabel
            case .short:
                value.shortLabel(locale: locale)
            case .wide:
                value.wideLabel(locale: locale)
            }
        }

        /// Returns a copy that uses the given label width.
        public func width(_ width: Width) -> Self {
            var copy = self
            copy.width = width
            return copy
        }

        /// Returns a copy that uses the given locale.
        public func locale(_ locale: Locale) -> Self {
            var copy = self
            copy.locale = locale
            return copy
        }
    }

    /// Formats this stat kind with the given format style.
    ///
    /// The default format uses one-letter labels: H, A, B, C, D, and S.
    func formatted(_ formatStyle: FormatStyle = .abbreviated) -> String {
        formatStyle.format(self)
    }
}

public extension PokemonStatKind.FormatStyle {
    /// One-letter labels: H, A, B, C, D, and S.
    static var abbreviated: Self {
        Self(width: .abbreviated)
    }

    /// Compact localized labels, such as Atk or 特攻.
    static var short: Self {
        Self(width: .short)
    }

    /// Full localized stat names, such as Attack or こうげき.
    static var wide: Self {
        Self(width: .wide)
    }
}

public extension Foundation.FormatStyle where Self == PokemonStatKind.FormatStyle {
    /// A Pokemon stat label format style.
    static var pokemonStatKind: Self {
        Self()
    }

    /// A Pokemon stat label format style.
    ///
    /// - Parameters:
    ///   - width: The amount of detail to include in formatted labels.
    ///   - locale: The locale used for localized labels.
    static func pokemonStatKind(
        width: PokemonStatKind.FormatStyle.Width = .abbreviated,
        locale: Locale = .autoupdatingCurrent
    ) -> Self {
        Self(width: width, locale: locale)
    }
}

private extension PokemonStatKind {
    var abbreviatedLabel: String {
        switch self {
        case .hp:
            "H"
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

    func shortLabel(locale: Locale) -> String {
        if locale.usesJapaneseStatLabels {
            switch self {
            case .hp:
                "HP"
            case .attack:
                "攻撃"
            case .defense:
                "防御"
            case .specialAttack:
                "特攻"
            case .specialDefense:
                "特防"
            case .speed:
                "素早さ"
            }
        } else {
            switch self {
            case .hp:
                "HP"
            case .attack:
                "Atk"
            case .defense:
                "Def"
            case .specialAttack:
                "Sp. Atk"
            case .specialDefense:
                "Sp. Def"
            case .speed:
                "Spe"
            }
        }
    }

    func wideLabel(locale: Locale) -> String {
        if locale.usesJapaneseStatLabels {
            switch self {
            case .hp:
                "HP"
            case .attack:
                "こうげき"
            case .defense:
                "ぼうぎょ"
            case .specialAttack:
                "とくこう"
            case .specialDefense:
                "とくぼう"
            case .speed:
                "すばやさ"
            }
        } else {
            switch self {
            case .hp:
                "HP"
            case .attack:
                "Attack"
            case .defense:
                "Defense"
            case .specialAttack:
                "Special Attack"
            case .specialDefense:
                "Special Defense"
            case .speed:
                "Speed"
            }
        }
    }
}

private extension Locale {
    var usesJapaneseStatLabels: Bool {
        let normalizedIdentifier = identifier.replacingOccurrences(of: "-", with: "_")
        return normalizedIdentifier.split(separator: "_").first == "ja"
    }
}

/// The values and scale passed from a ``PokemonStatChart`` to its style.
///
/// Custom styles receive this configuration from
/// ``PokemonStatChartStyle/makeBody(configuration:)``. Values are exposed both
/// as individual properties and as ordered entries for repeated rendering.
public struct PokemonStatChartStyleConfiguration: Sendable {
    let stats: PokemonStatValues

    /// The value used as the full scale of the chart.
    public let maxValue: Double

    /// The format style used for stat labels.
    public let labelStyle: PokemonStatKind.FormatStyle

    init(
        stats: PokemonStatValues,
        maxValue: Double,
        labelStyle: PokemonStatKind.FormatStyle = .abbreviated
    ) {
        self.stats = stats
        self.maxValue = max(maxValue, 1)
        self.labelStyle = labelStyle
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
        formattedEntries(labelStyle)
    }

    /// Returns stat entries whose labels are formatted with the given style.
    ///
    /// Use this from custom chart styles when you need localized or differently
    /// abbreviated stat labels.
    public func formattedEntries(
        _ formatStyle: PokemonStatKind.FormatStyle = .abbreviated
    ) -> [(label: String, value: Double)] {
        statEntries.map { entry in
            (label: entry.kind.formatted(formatStyle), value: entry.value)
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

    /// Sets the label style used by ``PokemonStatChart`` views in this view
    /// hierarchy.
    ///
    /// - Parameter labelStyle: The label style to apply.
    func pokemonStatChartLabelStyle(_ labelStyle: PokemonStatKind.FormatStyle) -> some View {
        environment(\.pokemonStatChartLabelStyle, labelStyle)
    }
}

private struct PokemonStatChartStyleKey: EnvironmentKey {
    static let defaultValue: any PokemonStatChartStyle = HexagonPokemonStatChartStyle()
}

private struct PokemonStatChartLabelStyleKey: EnvironmentKey {
    static let defaultValue: PokemonStatKind.FormatStyle = .abbreviated
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

    var pokemonStatChartLabelStyle: PokemonStatKind.FormatStyle {
        get {
            self[PokemonStatChartLabelStyleKey.self]
        }
        set {
            self[PokemonStatChartLabelStyleKey.self] = newValue
        }
    }
}

#Preview {
    PokemonStatChart(HP: 108, A: 130, B: 95, C: 80, D: 85, S: 102)
        .pokemonStatChartStyle(.hexagon)

    PokemonStatChart(HP: 108, A: 130, B: 95, C: 80, D: 85, S: 102)
        .pokemonStatChartStyle(.bar)
        .pokemonStatChartLabelStyle(.short)
}
