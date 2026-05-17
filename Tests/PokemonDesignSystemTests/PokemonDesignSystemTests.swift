import PokemonTypes
import Testing
@testable import PokemonDesignSystem

@Test func everyPokemonTypeHasTintColor() {
    for pokemonType in PokemonType.allCases {
        _ = pokemonType.tintColor
    }

    #expect(PokemonType.allCases.count == 18)
}
