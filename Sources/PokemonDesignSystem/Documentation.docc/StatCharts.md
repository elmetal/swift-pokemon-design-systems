# Stat Charts

Display Pokemon HP, Attack, Defense, Special Attack, Special Defense, and Speed
values as SwiftUI charts.

## Overview

Use ``PokemonStatChart`` when you need a compact visual summary of the six
standard Pokemon stats. The chart accepts raw values and normalizes them against
the largest supplied value by default.

```swift
PokemonStatChart(HP: 108, A: 130, B: 95, C: 80, D: 85, S: 102)
```

Provide `maxValue` when multiple charts should use the same scale.

```swift
PokemonStatChart(HP: 108, A: 130, B: 95, C: 80, D: 85, S: 102, maxValue: 255)
```

### Choose a Style

The default style is a hexagon radar chart. You can also select styles
explicitly with ``SwiftUICore/View/pokemonStatChartStyle(_:)``.

```swift
PokemonStatChart(HP: 108, A: 130, B: 95, C: 80, D: 85, S: 102)
    .pokemonStatChartStyle(.hexagon)
```

```swift
PokemonStatChart(HP: 108, A: 130, B: 95, C: 80, D: 85, S: 102)
    .pokemonStatChartStyle(.bar)
```

### Format Stat Labels

Stat labels use ``PokemonStatKind/FormatStyle``. The default label format is
the compact H, A, B, C, D, and S notation. Built-in styles can also use
localized short or wide labels.

```swift
PokemonStatChart(HP: 108, A: 130, B: 95, C: 80, D: 85, S: 102)
    .pokemonStatChartLabelStyle(.wide.locale(Locale(identifier: "ja_JP")))
```

### Set the Chart Color

Stat chart fill and stroke colors follow SwiftUI's standard `tint(_:)`
modifier.

```swift
PokemonStatChart(HP: 108, A: 130, B: 95, C: 80, D: 85, S: 102)
    .pokemonStatChartStyle(.hexagon)
    .tint(.pokemonFireTint)
```

## Topics

### Creating Charts

- ``PokemonStatChart``
- ``PokemonStatKind``
- ``PokemonStatKind/FormatStyle``

### Styling Charts

- ``PokemonStatChartStyle``
- ``PokemonStatChartStyleConfiguration``
- ``SwiftUICore/View/pokemonStatChartStyle(_:)``
- ``SwiftUICore/View/pokemonStatChartLabelStyle(_:)``

### Built-in Styles

- ``HexagonPokemonStatChartStyle``
- ``PokemonStatChartStyle/hexagon``
- ``BarPokemonStatChartStyle``
- ``PokemonStatChartStyle/bar``
