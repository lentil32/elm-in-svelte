import { writable } from 'svelte/store';

export const scriptsLoaded = writable(new Set<string>());

