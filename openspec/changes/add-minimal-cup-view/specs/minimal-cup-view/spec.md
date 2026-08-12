## ADDED Requirements

### Requirement: Minimal Cup Is An Optional Extraction View

The live espresso screen SHALL offer `Minimal Cup` alongside the existing `Shot Chart` and `Cup
Fill` modes, and SHALL persist the selected mode through the existing
`espresso/extractionView` setting.

#### Scenario: User selects Minimal Cup during extraction

- **WHEN** the user selects `Minimal Cup` from the extraction view selector
- **THEN** the live graph or rich cup SHALL be replaced by the minimal ceramic cup
- **AND** neither existing view SHALL be removed or changed

### Requirement: Minimal Cup Uses Restrained Data-Driven Geometry

The Minimal Cup view SHALL render a fixed-colour matte ceramic cup and fixed-colour dark-brown
espresso. Display weight SHALL control the liquid fill height, target weight SHALL be represented
by a short understated notch, and current flow SHALL control the thin stream width with an eased
transition. Pressure, pressure deviation and phase SHALL NOT recolour the cup or espresso.

#### Scenario: Weight and flow change during pouring

- **WHEN** weight rises and live flow changes during `Preinfusion` or `Pouring`
- **THEN** the liquid height SHALL rise in proportion to `weight / targetWeight`
- **AND** the stream SHALL widen or narrow in proportion to flow
- **AND** the ceramic and espresso colours SHALL remain unchanged

#### Scenario: Target is reached or exceeded

- **WHEN** display weight is at least target weight
- **THEN** the liquid SHALL stop at the target fill height
- **AND** no completion glow, colour change, steam or celebratory animation SHALL appear

### Requirement: Minimal Cup Follows The Espresso Lifecycle

Minimal Cup SHALL remain empty before a flow phase has been observed, SHALL track the peak weight
after extraction, and SHALL hold that fill and weight after the espresso cycle ends until the view
is destroyed. Entering a new espresso cycle on the same instance SHALL clear the prior hold.

#### Scenario: Espresso preheating

- **WHEN** the espresso page is in `EspressoPreheating` and no extraction phase has been observed
- **THEN** the ceramic cup SHALL render empty regardless of residual scale weight
- **AND** no stream SHALL be visible

#### Scenario: Post-shot hold

- **WHEN** extraction has been observed and the machine leaves the espresso cycle
- **THEN** Minimal Cup SHALL retain the peak extracted weight and matching fill height
- **AND** no animation loop SHALL run during the hold

### Requirement: Minimal Cup Uses A Neutral Supporting Interface

While Minimal Cup is active, the existing phase pill SHALL use a neutral surface and border with
a restrained primary-colour dot. Existing bottom measurement hues SHALL remain identifiable but
SHALL be mixed 20% toward the secondary text colour. Values, controls, accessible labels and page
layout SHALL otherwise remain unchanged.

#### Scenario: Minimal Cup is selected

- **WHEN** the espresso page presents live shot data in Minimal Cup mode
- **THEN** the phase pill SHALL not use phase-dependent fill colours
- **AND** pressure, flow, temperature, weight-flow and weight colours SHALL remain recognisable at
  reduced saturation
