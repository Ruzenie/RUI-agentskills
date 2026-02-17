export interface UiLibrary {
  id: string;
  name: string;
  framework: 'react' | 'vue' | 'agnostic';
  strengths: string[];
  risks: string[];
}

/**
 * Reference-only seed used when project-local selector data is unavailable.
 */
export const uiLibraries: UiLibrary[] = [
  {
    id: 'shadcn-ui',
    name: 'shadcn/ui',
    framework: 'react',
    strengths: ['Composable', 'Token-friendly', 'Headless-first'],
    risks: ['Needs discipline to keep design consistency'],
  },
  {
    id: 'mantine',
    name: 'Mantine',
    framework: 'react',
    strengths: ['Rich component set', 'Good DX'],
    risks: ['Requires planning for deep theme customization'],
  },
];
