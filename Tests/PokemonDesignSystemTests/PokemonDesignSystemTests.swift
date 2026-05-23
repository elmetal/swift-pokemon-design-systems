import Foundation
import PokemonTypes
import SwiftUI
import Testing
@testable import PokemonDesignSystem

@Test func everyPokemonTypeHasTintColor() {
    for pokemonType in PokemonType.allCases {
        _ = pokemonType.tintColor
    }

    #expect(PokemonType.allCases.count == 18)
}

@Test func moveCategoryTintColorsAreAvailable() {
    _ = Color.pokemonPhysicalMoveTint
    _ = Color.pokemonSpecialMoveTint
    _ = Color.pokemonStatusMoveTint
}

@MainActor @Test func pokemonStatChartStylesAreAvailable() {
    _ = PokemonStatChart(HP: 108, A: 130, B: 95, C: 80, D: 85, S: 102)
        .pokemonStatChartStyle(.bar)

    _ = PokemonStatChart(HP: 108, A: 130, B: 95, C: 80, D: 85, S: 102)
        .pokemonStatChartStyle(.hexagon)
        .tint(.pokemonFireTint)

    _ = PokemonStatChart(HP: 108, A: 130, B: 95, C: 80, D: 85, S: 102)
        .pokemonStatChartStyle(.bar)
        .pokemonStatChartLabelStyle(.wide.locale(Locale(identifier: "ja_JP")))
}

@Test func pokemonStatKindFormatStyleFormatsLabels() {
    let englishShortFormatStyle = PokemonStatKind.FormatStyle(width: .short, locale: Locale(identifier: "en_US"))
    let englishWideFormatStyle = PokemonStatKind.FormatStyle(width: .wide, locale: Locale(identifier: "en_US"))
    #expect(PokemonStatKind.hp.formatted() == "H")
    #expect(PokemonStatKind.attack.formatted() == "A")
    #expect(PokemonStatKind.hp.formatted(englishShortFormatStyle) == "HP")
    #expect(PokemonStatKind.specialAttack.formatted(englishShortFormatStyle) == "Sp. Atk")
    #expect(PokemonStatKind.specialDefense.formatted(englishWideFormatStyle) == "Special Defense")

    let japaneseFormatStyle = PokemonStatKind.FormatStyle(width: .wide, locale: Locale(identifier: "ja_JP"))

    #expect(PokemonStatKind.attack.formatted(japaneseFormatStyle) == "こうげき")
    #expect(PokemonStatKind.speed.formatted(.short.locale(Locale(identifier: "ja_JP"))) == "素早さ")
}

@Test func pokemonStatChartConfigurationCanReturnFormattedEntries() {
    let configuration = PokemonStatChartStyleConfiguration(
        stats: PokemonStatValues(
            hp: 1,
            attack: 2,
            defense: 3,
            specialAttack: 4,
            specialDefense: 5,
            speed: 6
        ),
        maxValue: 6,
        labelStyle: PokemonStatKind.FormatStyle(width: .short, locale: Locale(identifier: "en_US"))
    )

    let labels = configuration.entries.map(\.label)

    #expect(labels == ["HP", "Atk", "Def", "Sp. Atk", "Sp. Def", "Spe"])
}
