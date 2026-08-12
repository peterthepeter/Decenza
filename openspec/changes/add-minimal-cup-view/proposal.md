## Why

The existing `CupFillView` is intentionally rich: a rendered glass cup, crema, waves, ripples,
steam and lighting effects. That animation is useful, but it does not fit restrained themes and
cannot be simplified through theme colours alone because most of its character comes from image
assets and procedural effects.

## What Changes

- Add a third extraction view, **Minimal Cup**, without replacing Shot Chart or Cup Fill.
- Draw a responsive matte ceramic cup directly in QML, based on the approved D4 design.
- Map weight to fill height and live flow to a thin stream while keeping ceramic and espresso
  colours fixed.
- Reuse Cup Fill's pre-flow-empty and post-shot-held-weight behaviour.
- Use a neutral phase pill and slightly desaturated measurement colours while Minimal Cup is
  selected.

## Capabilities

### New Capabilities

- `minimal-cup-view`: selectable minimal extraction visualization and its data/visual contract.

## Impact

- `qml/components/MinimalCupFillView.qml` — new asset-free responsive visualization.
- `qml/pages/EspressoPage.qml` — loader integration and Minimal Cup presentation adjustments.
- `qml/components/ExtractionViewSelector.qml` — third view choice.
- `qml/pages/settings/SettingsMachineTab.qml` — third persistent preference choice.
- `CMakeLists.txt` — register the new QML type.
- `docs/CLAUDE_MD/CUP_FILL_VIEW.md` — document both cup renderers.
- No C++ changes, BLE changes, schema migration, or replacement of existing views.
