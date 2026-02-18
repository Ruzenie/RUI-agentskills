export interface UiLibrary {
  id: string;
  name: string;
  framework: 'react' | 'vue' | 'agnostic';
  strengths: string[];
  risks: string[];
}

/**
 * Reference-only seed used by selector skills when project-local data is unavailable.
 */
export const uiLibraries: UiLibrary[] = [
  {
    id: 'shadcn-ui',
    name: 'shadcn/ui',
    framework: 'react',
    strengths: ['Composable', 'Token-friendly', 'Headless-first'],
    risks: ['Requires engineering discipline for consistency'],
  },
  {
    id: 'mantine',
    name: 'Mantine',
    framework: 'react',
    strengths: ['Rich component set', 'Good DX'],
    risks: ['Theme customization depth needs planning'],
  },
];
