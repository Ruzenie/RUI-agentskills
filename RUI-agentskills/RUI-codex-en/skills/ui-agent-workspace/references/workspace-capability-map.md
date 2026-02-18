# UI Agent Workspace Capability Map

This reference maps the six source docs under `skills/ui-agent-workspace` into executable collaboration rules.

## Source Mapping

1. `01-core-concept.md`
- Defines the three-layer model: Workspace, Canvas, Modification Log.
- Establishes flow: user intent -> canvas -> code -> log -> state.

2. `02-workspace-manager.md`
- Standardizes `.workspace/`, `canvas/`, `docs/`, `logs/` directories.
- Defines `config.json`, `state.json`, `index.json`, and `sessions/*.json` schemas.

3. `03-ui-modification-log.md`
- Defines change taxonomy and record templates.
- Includes batch update, rollback, and experimental change templates.

4. `04-canvas-system.md`
- Standardizes page-level and component-level canvas files.
- Uses ASCII, Mermaid, spec tables, and code snippets together.

5. `05-markdown-graphics.md`
- Defines markdown drawing conventions for UI structures and states.

6. `06-component-library.md`
- Provides reusable component template structure, variants, and props schema.

## Minimum Deliverable Set

- Canvas artifact: `canvas/pages/*.md` or `canvas/components/*.md`
- State file: `.workspace/state.json`
- Index file: `.workspace/index.json`
- Change log: `logs/CHANGELOG.md`
- Session record: `.workspace/sessions/session_xxx.json`

## Quality Checks

1. Canvas spec matches implemented code.
2. Every UI change has a unique ID with intent/context.
3. `canvas -> code -> log` chain is traceable.
4. Rollback records can locate original change directly.
