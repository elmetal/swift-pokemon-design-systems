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
