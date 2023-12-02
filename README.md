## How to Embed Elm into Svelte with TypeScript Setup

### Method 1. Using `<script>` tag:

1. Install `@types/elm`:
```shell
npm i -D @types/elm
```
2. Run `elm make src/Main.elm --output=elm.js`
3. Place `elm.js` in the assets directory, e.g., `/static` for SvelteKit.
4. Modify `+page.svelte` to embed `elm.js`:
```html
<script context="module" lang="ts">
	declare let Elm: ElmInstance;
</script>

<script lang="ts">
	import { onMount } from 'svelte';

	let elmRoot: Node;
	onMount(() => {
		Elm.Main.init({
			node: elmRoot,
		});
	});
</script>

<svelte:head>
	<script src="/elm.js">
	</script>
</svelte:head>
<div bind:this={elmRoot} />
```


## Method 2. Using [vite-plugin-elm](https://github.com/hmsk/vite-plugin-elm):

1. Install `vite-plugin-elm`:
```shell
npm i -D vite-plugin-elm
```
2. Place the Elm project, including the `elm.json` file, in the library directory, e.g., `/src/lib` in SvelteKit."
3. Modify `vite.config.ts`:
```ts
// vite.config.ts

import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import { plugin as elm } from 'vite-plugin-elm';

export default defineConfig({
	plugins: [sveltekit(), elm()],
});
```
4. Modify `+page.svelte` to embed `Main.elm`:
```html
<script lang="ts">
	import { onMount } from 'svelte';
	import { Elm } from '$lib/elm/src/Main.elm'

	let elmRoot: Node;
	onMount(() => {
		Elm.Main.init({
			node: elmRoot,
		});
	});
</script>

<div bind:this={elmRoot} />
```

## Running Examples
1. Go to folder:
```shell
cd method1 # or method2
```

2. Install npm packages:
```shell
npm i
```

3. Run dev server:
```shell
npm run dev
```
