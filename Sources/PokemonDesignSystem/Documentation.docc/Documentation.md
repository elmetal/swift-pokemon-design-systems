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

- ``SwiftUICore/Color/pokemonNormalTint``
- ``SwiftUICore/Color/pokemonFireTint``
- ``SwiftUICore/Color/pokemonWaterTint``
- ``SwiftUICore/Color/pokemonElectricTint``
- ``SwiftUICore/Color/pokemonGrassTint``
- ``SwiftUICore/Color/pokemonIceTint``
- ``SwiftUICore/Color/pokemonFightingTint``
- ``SwiftUICore/Color/pokemonPoisonTint``
- ``SwiftUICore/Color/pokemonGroundTint``
- ``SwiftUICore/Color/pokemonFlyingTint``
- ``SwiftUICore/Color/pokemonPsychicTint``
- ``SwiftUICore/Color/pokemonBugTint``
- ``SwiftUICore/Color/pokemonRockTint``
- ``SwiftUICore/Color/pokemonGhostTint``
- ``SwiftUICore/Color/pokemonDragonTint``
- ``SwiftUICore/Color/pokemonDarkTint``
- ``SwiftUICore/Color/pokemonSteelTint``
- ``SwiftUICore/Color/pokemonFairyTint``

### Pokemon Move Category Colors

- ``SwiftUICore/Color/pokemonPhysicalMoveTint``
- ``SwiftUICore/Color/pokemonSpecialMoveTint``
- ``SwiftUICore/Color/pokemonStatusMoveTint``

### Pokemon Type Extensions

- ``PokemonTypes/PokemonType/tintColor``
