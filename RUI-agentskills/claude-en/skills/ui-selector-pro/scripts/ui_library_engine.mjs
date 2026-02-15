#!/usr/bin/env node

import fs from 'node:fs';
import path from 'node:path';
import vm from 'node:vm';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const REPO_ROOT = path.resolve(__dirname, '../../..');
const DATA_FILE = path.join(REPO_ROOT, 'app/src/data/uiLibraries.ts');
const SEED_FILE = path.join(REPO_ROOT, 'skills/ui-selector-pro/data/uiLibraries.seed.json');

function usage() {
  return `UI Library Engine\n\nCommands:\n  recommend --framework <id> --project-type <id> [options]\n  evaluate --libraries <id1,id2,...> [options]\n  compare --libraries <id1,id2,...> [options]\n  export [--format json|markdown]\n\nRecommend options:\n  --framework react|vue|angular|svelte|universal|other\n  --project-type <useCaseId>\n  --priority <performance|accessibility|customization|ecosystem|dx|enterprise> (repeatable)\n  --design-style <styleId>\n  --team-size small|medium|large\n  --top <n>\n  --format json|markdown\n\nEvaluate options:\n  --libraries <id1,id2,...>\n  --dimensions <dim1,dim2,...>\n  --format json|markdown\n\nCompare options:\n  --libraries <id1,id2,...>\n  --format json|markdown\n`;
}

function parseArgs(argv) {
  const [, , command, ...rest] = argv;
  const options = {};
  for (let i = 0; i < rest.length; i += 1) {
    const token = rest[i];
    if (!token.startsWith('--')) {
      continue;
    }
    const key = token.slice(2);
    const next = rest[i + 1];
    if (!next || next.startsWith('--')) {
      options[key] = true;
    } else {
      if (options[key] === undefined) {
        options[key] = next;
      } else if (Array.isArray(options[key])) {
        options[key].push(next);
      } else {
        options[key] = [options[key], next];
      }
      i += 1;
    }
  }
  return { command, options };
}

function findArrayLiteral(source, constName) {
  const marker = `export const ${constName}`;
  const markerIndex = source.indexOf(marker);
  if (markerIndex < 0) {
    throw new Error(`Cannot find declaration for ${constName}`);
  }

  const eqIndex = source.indexOf('=', markerIndex);
  if (eqIndex < 0) {
    throw new Error(`Cannot parse declaration for ${constName}`);
  }

  const arrayStart = source.indexOf('[', eqIndex);
  if (arrayStart < 0) {
    throw new Error(`Cannot find array start for ${constName}`);
  }

  let depth = 0;
  let inString = false;
  let stringChar = '';
  let escaped = false;
  let inLineComment = false;
  let inBlockComment = false;

  for (let i = arrayStart; i < source.length; i += 1) {
    const ch = source[i];
    const next = source[i + 1] || '';

    if (inLineComment) {
      if (ch === '\n') {
        inLineComment = false;
      }
      continue;
    }

    if (inBlockComment) {
      if (ch === '*' && next === '/') {
        inBlockComment = false;
        i += 1;
      }
      continue;
    }

    if (inString) {
      if (escaped) {
        escaped = false;
      } else if (ch === '\\') {
        escaped = true;
      } else if (ch === stringChar) {
        inString = false;
        stringChar = '';
      }
      continue;
    }

    if (ch === '/' && next === '/') {
      inLineComment = true;
      i += 1;
      continue;
    }

    if (ch === '/' && next === '*') {
      inBlockComment = true;
      i += 1;
      continue;
    }

    if (ch === '\'' || ch === '"' || ch === '`') {
      inString = true;
      stringChar = ch;
      continue;
    }

    if (ch === '[') {
      depth += 1;
      continue;
    }

    if (ch === ']') {
      depth -= 1;
      if (depth === 0) {
        return source.slice(arrayStart, i + 1);
      }
    }
  }

  throw new Error(`Cannot find array end for ${constName}`);
}

function evalLiteral(literal) {
  const script = new vm.Script(`(${literal})`);
  return script.runInNewContext(Object.create(null), { timeout: 1000 });
}

function loadData() {
  if (fs.existsSync(DATA_FILE)) {
    const source = fs.readFileSync(DATA_FILE, 'utf8');
    const uiLibraries = evalLiteral(findArrayLiteral(source, 'uiLibraries'));
    const evaluationDimensions = evalLiteral(findArrayLiteral(source, 'evaluationDimensions'));
    const useCases = evalLiteral(findArrayLiteral(source, 'useCases'));
    const designTrends = evalLiteral(findArrayLiteral(source, 'designTrends'));
    return { uiLibraries, evaluationDimensions, useCases, designTrends, source: 'app' };
  }

  if (fs.existsSync(SEED_FILE)) {
    const payload = JSON.parse(fs.readFileSync(SEED_FILE, 'utf8'));
    return {
      uiLibraries: payload.uiLibraries || [],
      evaluationDimensions: payload.evaluationDimensions || [],
      useCases: payload.useCases || [],
      designTrends: payload.designTrends || [],
      source: 'seed',
    };
  }

  throw new Error(
    `missing data source: neither ${path.relative(REPO_ROOT, DATA_FILE)} nor ${path.relative(REPO_ROOT, SEED_FILE)} exists`,
  );
}

function asList(value) {
  if (value === undefined || value === true) {
    return [];
  }
  if (Array.isArray(value)) {
    return value.flatMap((item) => String(item).split(',')).map((x) => x.trim()).filter(Boolean);
  }
  return String(value)
    .split(',')
    .map((x) => x.trim())
    .filter(Boolean);
}

function toScoreLevel(value) {
  if (value === 'excellent') return 5;
  if (value === 'good') return 4;
  if (value === 'average') return 3;
  if (value === 'poor') return 2;
  if (value === 'high') return 5;
  if (value === 'medium') return 3;
  if (value === 'low') return 2;
  if (value === 'very-active') return 5;
  if (value === 'active') return 4;
  if (value === 'moderate') return 3;
  if (value === 'inactive') return 2;
  return 3;
}

function isCompactBundle(bundleSize) {
  return (bundleSize.includes('KB') && !bundleSize.includes('MB')) || bundleSize.includes('enen');
}

function matchScore(lib, prefs, useCaseMap) {
  let score = 0;
  let maxScore = 0;

  if (prefs.framework) {
    maxScore += 25;
    if (
      lib.framework.includes(prefs.framework) ||
      (prefs.framework === 'other' && lib.framework.includes('universal'))
    ) {
      score += 25;
    }
  }

  if (prefs.projectType) {
    maxScore += 25;
    const useCase = useCaseMap.get(prefs.projectType);
    if (useCase && useCase.recommendedLibraries.includes(lib.id)) {
      score += 25;
    } else if (prefs.projectType.includes('enterprise') && lib.enterpriseReady) {
      score += 20;
    } else if (
      (prefs.projectType.includes('rapid') || prefs.projectType.includes('startup')) &&
      (lib.learningCurve === 'easy' || isCompactBundle(lib.bundleSize))
    ) {
      score += 20;
    }
  }

  if (prefs.priorities.length > 0) {
    maxScore += 30;
    let priorityScore = 0;
    for (const priority of prefs.priorities) {
      if (priority === 'performance' && isCompactBundle(lib.bundleSize)) {
        priorityScore += 10;
      }
      if (priority === 'accessibility') {
        if (lib.accessibility === 'excellent') priorityScore += 10;
        else if (lib.accessibility === 'good') priorityScore += 7;
      }
      if (priority === 'customization' && lib.customization === 'high') {
        priorityScore += 10;
      }
      if (priority === 'ecosystem') {
        if (lib.community === 'very-active') priorityScore += 10;
        else if (lib.community === 'active') priorityScore += 7;
      }
      if (priority === 'dx' && lib.documentation === 'excellent' && lib.typescript) {
        priorityScore += 10;
      }
      if (priority === 'enterprise' && lib.enterpriseReady) {
        priorityScore += 10;
      }
    }
    score += Math.min(priorityScore, 30);
  }

  if (prefs.designStyle) {
    maxScore += 10;
    if (lib.designStyle.includes(prefs.designStyle)) {
      score += 10;
    }
  }

  if (prefs.teamSize) {
    maxScore += 10;
    if (prefs.teamSize === 'large' && lib.enterpriseReady) {
      score += 10;
    } else if (prefs.teamSize === 'small' && lib.learningCurve === 'easy') {
      score += 10;
    } else if (prefs.teamSize === 'medium') {
      score += 10;
    }
  }

  return maxScore > 0 ? (score / maxScore) * 100 : 50;
}

function buildReasons(lib, prefs, useCaseMap) {
  const reasons = [];

  if (
    prefs.framework &&
    (lib.framework.includes(prefs.framework) ||
      (prefs.framework === 'other' && lib.framework.includes('universal')))
  ) {
    reasons.push('enenenen');
  }

  const useCase = prefs.projectType ? useCaseMap.get(prefs.projectType) : null;
  if (useCase && useCase.recommendedLibraries.includes(lib.id)) {
    reasons.push('enenenen');
  }

  if (prefs.priorities.includes('performance') && isCompactBundle(lib.bundleSize)) {
    reasons.push('enenenen');
  }

  if (prefs.priorities.includes('accessibility') && lib.accessibility === 'excellent') {
    reasons.push('enenenenenen');
  }

  if (prefs.priorities.includes('customization') && lib.customization === 'high') {
    reasons.push('enenenen');
  }

  if (prefs.priorities.includes('ecosystem') && (lib.community === 'very-active' || lib.community === 'active')) {
    reasons.push('enenenen');
  }

  if (prefs.priorities.includes('dx') && lib.documentation === 'excellent' && lib.typescript) {
    reasons.push('enenenenen');
  }

  if (prefs.priorities.includes('enterprise') && lib.enterpriseReady) {
    reasons.push('enenenenen');
  }

  if (prefs.designStyle && lib.designStyle.includes(prefs.designStyle)) {
    reasons.push('styleenen');
  }

  if (lib.typescript) {
    reasons.push('TypeScriptenen');
  }

  if (lib.darkMode) {
    reasons.push('enenenenenen');
  }

  return reasons.slice(0, 4);
}

function autoDimensionScore(lib, dimensionId) {
  if (dimensionId === 'accessibility') {
    return toScoreLevel(lib.accessibility);
  }

  if (dimensionId === 'customization') {
    return toScoreLevel(lib.customization);
  }

  if (dimensionId === 'performance') {
    if (isCompactBundle(lib.bundleSize)) return 5;
    if (lib.bundleSize.includes('200KB')) return 4;
    if (lib.bundleSize.includes('300KB')) return 3;
    return 2;
  }

  if (dimensionId === 'developer-experience') {
    if (lib.documentation === 'excellent' && lib.typescript) return 5;
    if (lib.documentation === 'good' && lib.typescript) return 4;
    if (lib.documentation === 'good') return 3;
    return 2;
  }

  if (dimensionId === 'ecosystem') {
    return toScoreLevel(lib.community);
  }

  if (dimensionId === 'enterprise-readiness') {
    return lib.enterpriseReady ? 5 : 3;
  }

  return 3;
}

function totalWeightedScore(scoresByDim, dimensions) {
  let total = 0;
  let weightSum = 0;
  for (const dim of dimensions) {
    const score = scoresByDim[dim.id];
    if (score > 0) {
      total += score * dim.weight;
      weightSum += dim.weight;
    }
  }
  return weightSum > 0 ? (total / weightSum) * 20 : 0;
}

function markdownRecommend(results) {
  const lines = [];
  lines.push('# UIenenenenenenen');
  lines.push('');
  results.forEach((item, idx) => {
    const lib = item.library;
    lines.push(`## ${idx + 1}. ${lib.name} (${item.score.toFixed(1)}en)`);
    lines.push(`- enen: ${lib.category}`);
    lines.push(`- enen: ${lib.framework.join(', ')}`);
    lines.push(`- Stars: ${lib.githubStars.toLocaleString()}`);
    lines.push(`- enenen: ${lib.bundleSize}`);
    if (item.reasons.length > 0) {
      lines.push(`- enenenen: ${item.reasons.join(' / ')}`);
    }
    lines.push('');
  });
  return lines.join('\n');
}

function markdownEvaluate(result, dimensions) {
  const lines = [];
  lines.push('# UIenenenenenenen');
  lines.push('');
  lines.push(`- enen: ${dimensions.map((d) => d.id).join(', ')}`);
  lines.push('');
  result.forEach((entry, idx) => {
    lines.push(`## ${idx + 1}. ${entry.library.name} (${entry.totalScore.toFixed(1)}/100)`);
    for (const dim of dimensions) {
      lines.push(`- ${dim.name}: ${entry.scores[dim.id]}/5`);
    }
    lines.push('');
  });
  return lines.join('\n');
}

function markdownCompare(result) {
  const lines = [];
  lines.push('# UIenenenenen');
  lines.push('');
  for (const lib of result) {
    lines.push(`## ${lib.name}`);
    lines.push(`- category: ${lib.category}`);
    lines.push(`- framework: ${lib.framework.join(', ')}`);
    lines.push(`- accessibility: ${lib.accessibility}`);
    lines.push(`- customization: ${lib.customization}`);
    lines.push(`- bundleSize: ${lib.bundleSize}`);
    lines.push(`- typescript: ${lib.typescript}`);
    lines.push(`- enterpriseReady: ${lib.enterpriseReady}`);
    lines.push(`- githubStars: ${lib.githubStars}`);
    lines.push('');
  }
  return lines.join('\n');
}

function ensureCommand(command) {
  if (!command || command === 'help' || command === '--help' || command === '-h') {
    process.stdout.write(usage());
    process.exit(0);
  }
}

function main() {
  const { command, options } = parseArgs(process.argv);
  ensureCommand(command);

  const { uiLibraries, evaluationDimensions, useCases, designTrends, source } = loadData();
  const useCaseMap = new Map(useCases.map((item) => [item.id, item]));
  const format = String(options.format || 'markdown');

  if (command === 'recommend') {
    const prefs = {
      framework: options.framework ? String(options.framework) : '',
      projectType: options['project-type'] ? String(options['project-type']) : '',
      priorities: asList(options.priority),
      designStyle: options['design-style'] ? String(options['design-style']) : '',
      teamSize: options['team-size'] ? String(options['team-size']) : '',
    };

    if (!prefs.framework || !prefs.projectType) {
      throw new Error('recommend enen --framework en --project-type');
    }

    const top = Number(options.top || 5);
    const results = uiLibraries
      .map((library) => ({
        library,
        score: matchScore(library, prefs, useCaseMap),
        reasons: buildReasons(library, prefs, useCaseMap),
      }))
      .sort((a, b) => b.score - a.score)
      .slice(0, Math.max(top, 1));

    if (format === 'json') {
      process.stdout.write(`${JSON.stringify({ source, prefs, results }, null, 2)}\n`);
    } else {
      process.stdout.write(`${markdownRecommend(results)}\n`);
    }
    return;
  }

  if (command === 'evaluate') {
    const libraryIds = asList(options.libraries);
    if (libraryIds.length === 0) {
      throw new Error('evaluate enen --libraries');
    }

    const dims = asList(options.dimensions);
    const dimensions = dims.length > 0
      ? evaluationDimensions.filter((dim) => dims.includes(dim.id))
      : evaluationDimensions;

    const libraries = uiLibraries.filter((lib) => libraryIds.includes(lib.id));
    const result = libraries
      .map((library) => {
        const scores = {};
        for (const dim of dimensions) {
          scores[dim.id] = autoDimensionScore(library, dim.id);
        }
        return {
          library,
          scores,
          totalScore: totalWeightedScore(scores, dimensions),
        };
      })
      .sort((a, b) => b.totalScore - a.totalScore);

    if (format === 'json') {
      process.stdout.write(`${JSON.stringify({ source, dimensions, result }, null, 2)}\n`);
    } else {
      process.stdout.write(`${markdownEvaluate(result, dimensions)}\n`);
    }
    return;
  }

  if (command === 'compare') {
    const libraryIds = asList(options.libraries);
    if (libraryIds.length === 0) {
      throw new Error('compare enen --libraries');
    }

    const result = uiLibraries.filter((lib) => libraryIds.includes(lib.id));
    if (format === 'json') {
      process.stdout.write(`${JSON.stringify({ source, result }, null, 2)}\n`);
    } else {
      process.stdout.write(`${markdownCompare(result)}\n`);
    }
    return;
  }

  if (command === 'export') {
    const payload = { source, uiLibraries, evaluationDimensions, useCases, designTrends };
    if (format === 'json') {
      process.stdout.write(`${JSON.stringify(payload, null, 2)}\n`);
    } else {
      process.stdout.write('# UIendataenen\n\n');
      process.stdout.write(`- uiLibraries: ${uiLibraries.length}\n`);
      process.stdout.write(`- evaluationDimensions: ${evaluationDimensions.length}\n`);
      process.stdout.write(`- useCases: ${useCases.length}\n`);
      process.stdout.write(`- designTrends: ${designTrends.length}\n`);
    }
    return;
  }

  throw new Error(`Unknown command: ${command}`);
}

try {
  main();
} catch (error) {
  process.stderr.write(`Error: ${error.message}\n`);
  process.stderr.write(`\n${usage()}\n`);
  process.exit(1);
}
