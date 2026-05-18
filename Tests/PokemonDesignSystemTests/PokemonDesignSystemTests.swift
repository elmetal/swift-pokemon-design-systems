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
}
