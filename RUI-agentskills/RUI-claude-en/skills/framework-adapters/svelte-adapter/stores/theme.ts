import { writable } from 'svelte/store';

export const themeMode = writable<'light' | 'dark'>('light');
