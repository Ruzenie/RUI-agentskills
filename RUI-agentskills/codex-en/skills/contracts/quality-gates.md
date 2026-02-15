# UI Fullflow Quality Gates

Turns the quality requirements from `AI_UI_Skill_Design_Document.md` and the frontend development specification document (Chinese source file in repo) into a unified gate system.

## Five-Phase Lifecycle Gates

1. Phase 1: Requirement analysis and design exploration
- Required inputs: `brief`, `framework`, `project_type`
- Outputs: requirement summary, stack candidates, design direction candidates
- Extra required field for style tasks: `style_target`
- Recommendation: 8-dimension completeness score `>= 70`

2. Phase 2: Architecture planning and component design
- Outputs: structure recommendation, component hierarchy, extraction strategy
- Gate: clear boundaries and single responsibility

3. Phase 3: Code generation and implementation
- Outputs: runnable code, dependency list
- Gates: type safety, accessibility baseline, style consistency
- Icon tasks also require icon manifest/spec with consistent naming and sizing

4. Phase 4: Self-review and refactor
- Refactor triggers:
  - single file > 200 lines
  - render logic > 30 lines
  - repeated pattern >= 3
  - prop drilling depth > 3

5. Phase 5: Acceptance and delivery
- Outputs: acceptance conclusion, issue list, release recommendation
- Recommendation dimensions: function, visual, code, performance, security/compatibility

## Style-Scope Gates (Mandatory)

1. Pre-lock
- Must generate `style.scope.lock.json` with `scope_locked=true`
- Must define `style_target`

2. File boundaries
- Should provide `allowed_files`
- Pre-submit check must confirm changes are limited to target style files/sections

3. Block conditions
- Changes outside the target area
- Changes to business logic/API/routing/state model
- Dependency changes unrelated to style work

## Icon Gates (On Demand)

1. Trigger
- Brief includes icon/svg/canvas related requirements

2. Required artifacts
- `icon.manifest.json`
- `icon.spec.md`
- `icon.sprite.svg` (SVG path) or `canvas.icon.demo.js` (Canvas path)

3. Consistency checks
- Size ladder consistency (16/20/24)
- Stroke/cap/join consistency
- Naming consistency (`icon-<category>-<name>`)

## Acceptance Matrix

1. Function: core flows, error handling, state, routing/navigation
2. Visual: hierarchy, spacing rhythm, typography, contrast, feedback
3. Code: naming, componentization, no `any`, low duplication, maintainability
4. Performance: first paint, rerender control, asset optimization, long-list strategy
5. Security/compatibility: escaping, sensitive data exposure, mainstream browser support

## Self-Evaluation Weights

- Completeness: 30%
- Aesthetics: 25%
- Maintainability: 25%
- Performance: 20%

## Quantitative Thresholds (mimoskills aligned)

- aesthetic score: `>= 4.0 / 5.0`
- component reuse ratio: `>= 40%`
- average cyclomatic complexity: `<= 10`
- TS coverage: `>= 90%`
- color contrast: `>= 4.5:1` (WCAG AA)

## Grade Bands

- 90-100: excellent (promotable)
- 80-89: good (deliverable)
- 70-79: pass (deliverable after recommended optimization)
- 60-69: needs improvement (must optimize before delivery)
- 0-59: fail (rework required)
