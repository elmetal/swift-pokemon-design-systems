# ``PokemonDesignSystem``

A small SwiftUI design system for Pokemon tools on Apple platforms.

## Overview

PokemonDesignSystem provides shared visual values for building Pokemon-related
tools for iOS, iPadOS, macOS, tvOS, watchOS, and visionOS.

Use the package as a foundation for consistent Pokemon-themed interfaces across
views, widgets, and platform-specific experiences.

```swift
import SwiftUI
import PokemonDesignSystem
import PokemonTypes

struct TypeBadge: View {
    let pokemonType: PokemonType = .fire

    var body: some View {
        Text("Fire")
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .foregroundStyle(.white)
            .background(Capsule().fill(pokemonType.tintColor))
    }
}
```

## Topics

### Pokemon Type Colors

- ``Color/pokemonNormalTint``
- ``Color/pokemonFireTint``
- ``Color/pokemonWaterTint``
- ``Color/pokemonElectricTint``
- ``Color/pokemonGrassTint``
- ``Color/pokemonIceTint``
- ``Color/pokemonFightingTint``
- ``Color/pokemonPoisonTint``
- ``Color/pokemonGroundTint``
- ``Color/pokemonFlyingTint``
- ``Color/pokemonPsychicTint``
- ``Color/pokemonBugTint``
- ``Color/pokemonRockTint``
- ``Color/pokemonGhostTint``
- ``Color/pokemonDragonTint``
- ``Color/pokemonDarkTint``
- ``Color/pokemonSteelTint``
- ``Color/pokemonFairyTint``

### Pokemon Type Extensions

- ``PokemonTypes/PokemonType/tintColor``
