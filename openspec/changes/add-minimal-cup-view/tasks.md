## 1. Minimal cup component

- [x] 1.1 Add a responsive QML cup matching the approved D4 proportions and fixed materials.
- [x] 1.2 Map weight to fill height, target weight to a short notch, and flow to stream width.
- [x] 1.3 Preserve pre-flow empty, post-shot peak-weight hold and new-shot reset semantics.

## 2. Extraction view integration

- [x] 2.1 Add Minimal Cup to the live extraction Loader and selector.
- [x] 2.2 Add Minimal Cup to the persistent Extraction View preference.
- [x] 2.3 Keep the phase pill neutral and desaturate existing live measurement colours only in
  Minimal Cup mode.
- [x] 2.4 Register the new QML file in CMake.

## 3. Documentation

- [x] 3.1 Document the renderer and behaviour in `docs/CLAUDE_MD/CUP_FILL_VIEW.md`.
- [ ] 3.2 Add a short Minimal Cup entry to the wiki Manual before publishing an upstream PR.

## 4. Validation

- [ ] 4.1 Run strict OpenSpec validation.
- [ ] 4.2 Build through Qt Creator MCP and review QML diagnostics.
- [ ] 4.3 Run simulated preheating, preinfusion, pouring, ending and post-shot hold states.
- [ ] 4.4 Verify landscape layout and frame behaviour on the Samsung Galaxy Tab A9+.
