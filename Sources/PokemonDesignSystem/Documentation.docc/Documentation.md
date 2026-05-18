# ``PokemonDesignSystem``

@Options(scope: local) {
    @TopicsVisualStyle(hidden)
}

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

## Design Tokens

@Links(visualStyle: compactGrid) {
    - <doc:Colors>
}

## Components

@Links(visualStyle: compactGrid) {
    - <doc:StatCharts>
}
