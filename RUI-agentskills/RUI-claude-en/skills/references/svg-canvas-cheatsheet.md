# SVG/Canvas Cheatsheet (Essential Version)

## 1. Selection Recommendations
- Prioritize SVG for regular UI icons.
- Consider Canvas for high-frequency redraws or complex animations.

## 2. SVG Baseline
- Unified viewBox
- Consistent stroke endpoints and join strategies
- Avoid meaningless path splitting

## 3. Canvas Baseline
- Scale by DPR (Device Pixel Ratio)
- Separate drawing logic from event logic
- Provide replayable rendering entry point

## Execution Checklist
- [ ] Input preconditions confirmed
- [ ] Key constraints documented
- [ ] Output format consumable by downstream skills
- [ ] Risk items and rollback approach clarified

## Common Pitfalls
- Providing conclusions without rationale
- Outputs that are not actionable or verifiable
- Ignoring boundary conditions and exception paths
