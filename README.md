## How to Embed Elm into Svelte with TypeScript Setup

### Method 1. Using `<script>` tag:

1. Install `@types/elm`:

```sh
npm i -D @types/elm
```

2. Compile `.elm` into `.js` `elm make src/Main.elm --output=sample.js`
3. Place `sample.js` in the assets directory, e.g., `/static/elm` for SvelteKit.
4. Modify `+page.svelte` to embed `elm.js`:

```svelte
<script context="module" lang="ts">
  declare let Elm: ElmInstance;
</script>

<script lang="ts">
  import { onMount } from "svelte";

  let elmRoot: Node;
  onMount(() => {
    Elm.Main.init({
      node: elmRoot,
    });
  });
</script>

<svelte:head>
  <script src="/elm/sample.js"></script>
</svelte:head>
<div bind:this="{elmRoot}" />

```

## Method 2. Using [vite-plugin-elm](https://github.com/hmsk/vite-plugin-elm):

1. Install `vite-plugin-elm`:

```sh
npm i -D vite-plugin-elm
```

2. Place the Elm project, including the `elm.json` file, in the library directory, e.g., `/src/lib` in SvelteKit."

3. Modify `vite.config.ts`:

```ts
// vite.config.ts

import { sveltekit } from "@sveltejs/kit/vite";
import { defineConfig } from "vite";
import { plugin as elm } from "vite-plugin-elm";

export default defineConfig({
  plugins: [sveltekit(), elm()],
});

```

4. Modify `+page.svelte` to embed `Main.elm`:

```svelte
<script lang="ts">
  import { onMount } from "svelte";
  import { Elm } from "$lib/elm/src/Main.elm";

  let elmRoot: Node;
  onMount(() => {
    Elm.Main.init({
      node: elmRoot,
    });
  });
</script>

<div bind:this="{elmRoot}" />

```

## Method 1 deep-dive. Embedding multiple Elm modules with script lifecycle management

### Key Considerations

1. States are separated for each component.
2. Programmatic loading of scripts for enhanced performance.
3. Prevention of multiple script loads that can cause errors in Elm and affect performance.

File `Elm.svelte`:

```svelte
<script context="module" lang="ts">
  declare let Elm: ElmInstance;

  type Callback = () => void;

  const scriptsLoaded = new Set<string>();
  const loadingPromises: Record<string, Promise<void>> = {};

  const loadScript = (src: string, callback: Callback): void => {
    if (scriptsLoaded.has(src)) {
      callback();
      return;
    }

    if (!loadingPromises[src]) {
      loadingPromises[src] = new Promise((resolve, reject) => {
        const script = document.createElement("script");
        script.src = src;
        script.async = true;

        script.onload = () => {
          scriptsLoaded.add(src);
          resolve();
        };

        script.onerror = (event) => {
          console.error(`Error loading script ${src}:`, event);
          reject(new Error(`Script load error: ${src}`));
        };

        document.head.appendChild(script);
      });
    }

    loadingPromises[src]?.then(callback).catch(() => {
      console.error(`Failed to load script: ${src}`);
    });
  };
</script>

<script lang="ts">
  import { onMount } from "svelte";
  import { assets } from "$app/paths";

  export let elmJsFilename: string;
  export let moduleName: string = elmJsFilename;

  const elmAssetsDirectory: string = `${assets}/elm`;
  const elmJsPath: string = `${elmAssetsDirectory}/${elmJsFilename}.js`;

  let elmRoot: Node;
  const handleLoad: Callback = () => {
    if (Elm && Elm[moduleName]) {
      Elm[moduleName].init({ node: elmRoot });
    } else {
      console.error("Elm module not found or not loaded: ", moduleName);
    }
  };

  onMount(() => {
    loadScript(elmJsPath, handleLoad);
  });
</script>

<div bind:this={elmRoot} />

```

File `elm-build.sh`:

```sh
#!/bin/sh

project_root=$(pwd)
elm_root=$project_root/src/lib/elm

build_example1() {
	cd $elm_root/examples1
	elm make src/* --output=$project_root/static/elm/elm.js --optimize
}

build_example2() {
	cd $elm_root/examples2

	for elm_file in src/*.elm; do
		base_name=$(basename "$elm_file" .elm)
		js_out_path="${project_root}/static/elm/${base_name}.js"
		elm make "$elm_file" --output="$js_out_path" --optimize
	done
}

if [ "$1" = "1" ]; then
	build_example1
elif [ "$1" = "2" ]; then
	build_example2
fi

```

### Example 1. Using one `elm.js` file containing multiple modules

```svelte
<script lang="ts">
  import Elm from "$lib/elm/Elm.svelte";

  const elmJsFilename = "elm";
  const moduleNames = ["Counter", "TextField"] as const;
</script>

<section>
  <hgroup>
    <h4>Using one `elm.js` file containing multiple modules</h4>
    <h5>Each module is used 3 times.</h5>
  </hgroup>
</section>
<section>
  {#each moduleNames as moduleName}
    {#each Array(3) as _, index (`${moduleName}-${index * 3}`)}
      <div>
        <Elm {elmJsFilename} {moduleName} />
      </div>
    {/each}
  {/each}
</section>

```

### Example 2. Using multiple `_moduleName_.js` files containing a module as same name as filename.

```svelte
<script lang="ts">
  import Elm from "$lib/elm/Elm.svelte";

  const elmJsFilenames = ["Hello", "Bye", "Welcome"] as const;
</script>

<hgroup>
  <h4>Using multiple `moduleName.js` files each containing one module</h4>
  <h5>
    Each module is used 3 times.
  </h5>
</hgroup>
<div>
  {#each elmJsFilenames as elmJsFilename}
    {#each Array(3) as _, index (`${elmJsFilename}-${index * 3}`)}
      <Elm {elmJsFilename} />
    {/each}
  {/each}
</div>

```

## See also

- [joakin/elm-node: Run Elm + JS programs easily in node](https://github.com/joakin/elm-node)

## Reference

- [JavaScript Interop · An Introduction to Elm](https://guide.elm-lang.org/interop/)
- [example of multiple elm apps on a single page](https://gist.github.com/epequeno/2d12d021bd865582b0fcb1509373ba25)

---

## Running examples - Method 1, 2

1. Go to `method(1|2)` directory:

```sh
cd method1 # or method2
```

2. Install npm packages:

```sh
npm i
```

3. (Only for Method 1) Compile `.elm` into `.js`:

```sh
# The command is equivalent to
# `cd ./src/lib/elm/elm-sample \
# && elm make src/Main.elm --output=../../../../static/elm.js`.
npm run elm:build
```

`elm:make` npm script is defined in `package.json`.

4. Run dev server:

```sh
npm run dev
```

## Running examples - Method 1 deep-dive

1. Go to `method1_deepdive` directory:

```sh
cd method1_deepdive
```

2. Install npm packages:

```sh
npm i
```

3. Compile `.elm` into `.js`:

```sh
npm run elm:build
# Equivalent to `npm run elm:build:examples1`
# && npm run elm:build:examples2`
```

4. Run dev server:

```sh
npm run dev
```
