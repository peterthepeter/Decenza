## Context

The live extraction page already swaps `ShotGraph` and `CupFillView` through a Loader and passes
the latter weight, target weight, flow and machine phase. The new view can use the same boundary
without changing shot control or telemetry.

## Decisions

### Add a view instead of skinning CupFillView

The existing view has a documented image/shader fidelity contract. Keeping it untouched avoids
regressions and makes the minimal treatment an opt-in choice that is suitable for an upstream PR.

### Use code-native geometry

The ceramic body, lower handle, sectional liquid, short target notch and stream are Qt Quick
Shapes and rectangles. This makes the D4 proportions responsive and lets live values alter
geometry without raster scaling or new shader work.

### Encode only weight and flow in the cup

Weight controls fill height. Flow controls stream width and its eased response. Phase stays in
the existing phase label, and pressure remains in the existing bottom statistic, so the cup and
espresso never change colour.

### Preserve extraction lifecycle semantics

Minimal Cup copies the existing view's extraction-seen latch, peak-weight hold and new-cycle
reset. Preheating is empty; after extraction the final cup remains until navigation destroys the
view.

## Visual System

- Archetype: Minimalist / Refined.
- Differentiator: a matte ceramic sectional cup that communicates progress without graph-like
  decoration.
- Geometry: D4's approximately 90% cup scale, slim handle enlarged 5% and placed slightly low.
- Palette: warm graphite ceramic, fixed dark-brown espresso, off-white labels, neutral charcoal
  surfaces, existing measurement hues mixed 20% toward the secondary text colour.
- Motion: 220 ms eased fill changes and 160 ms eased stream-width changes; no steam, splashes,
  glow, colour state, or completion animation.

## Risks

- Dynamic Shape paths must remain within the QML frame budget on the target tablet. The view has
  no timer and updates only when weight, flow, phase or dimensions change, reducing work compared
  with the 30 fps rich animation.
- Very small landscape windows could compress the cup. Width and height constraints both bound
  the body, and tablet-size visual verification is required before release.
