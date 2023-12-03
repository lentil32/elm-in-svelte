## How to Embed Elm into Svelte with TypeScript Setup

### Method 1. Using `<script>` tag:

1. Install `@types/elm`:

```shell
npm i -D @types/elm
```

2. Compile `.elm` into `.js` `elm make src/Main.elm --output=sample.js`
3. Place `sample.js` in the assets directory, e.g., `/static/elm` for SvelteKit.
4. Modify `+page.svelte` to embed `elm.js`:

```html
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

```shell
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

```html
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

```html
<script context="module" lang="ts">
  import { writable, get } from "svelte/store";

  declare let Elm: ElmInstance;

  type Callback = () => void;

  const scriptsLoaded = writable(new Set<string>());
  const loadingPromises: Record<string, Promise<void>> = {};

  const loadScript = (src: string, callback: Callback): void => {
    const loadedScripts = get(scriptsLoaded);
    if (loadedScripts.has(src)) {
      callback();
      return;
    }

    if (!loadingPromises[src]) {
      loadingPromises[src] = new Promise((resolve, reject) => {
        const script = document.createElement("script");
        script.src = src;
        script.async = true;

        script.onload = () => {
          scriptsLoaded.update((s) => s.add(src));
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

  export let elmJsFilename: string;
  export let moduleName: string = elmJsFilename;

  const elmAssetsDirectory: string = "/elm";
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

<div bind:this="{elmRoot}" />
```

File `compileElm.cjs`:

```ts
const fs = require("fs");
const { exec } = require("child_process");
const path = require("path");

const projectRootDirectory = process.cwd();

const elmDirectory = path.join(projectRootDirectory, "src/lib/elm");
const srcDirectory = path.join(elmDirectory, "src");
const outputDirectory = path.join(projectRootDirectory, "static/elm");

process.chdir(elmDirectory);

fs.readdir(srcDirectory, (err, files) => {
  if (err) {
    console.error("Error reading directory:", err);
    return;
  }

  files
    .filter((file) => file.endsWith(".elm"))
    .forEach((file) => {
      const filePath = path.join(srcDirectory, file);
      const outputFilePath = path.join(
        outputDirectory,
        file.replace(".elm", ".js"),
      );
      exec(
        `elm make ${filePath} --output=${path.relative(
          process.cwd(),
          outputFilePath,
        )} --optimize`,
        (error, stdout, stderr) => {
          if (error) {
            console.error(`Error executing elm make for ${file}:`, error);
            return;
          }
          console.log(
            `Compiled ${file} to ${path.relative(
              projectRootDirectory,
              outputFilePath,
            )}`,
          );
          console.log(stdout);
        },
      );
    });
});
```

### Example 1. Using one `elm.js` file containing multiple modules

```html
<script lang="ts">
  import Elm from "$lib/elm/Elm.svelte";

  const elmJsFilename = "elm";
  const moduleNames = ["Counter", "TextField"] as const;
</script>

<section>
  <h2>Example 1. Using one `elm.js` file containing multiple modules</h2>
  <div class="elm-container">
    {#each moduleNames as moduleName, index
    (`${elmJsFilename}-${moduleName}-${index}`)}
    <Elm {elmJsFilename} {moduleName} />
    {/each} {#each moduleNames as moduleName, index} {#key
    `${moduleName}-${index * 3}`}
    <Elm {elmJsFilename} {moduleName} />
    {/key} {#key `${moduleName}-${index * 3 + 1}`}
    <Elm {elmJsFilename} {moduleName} />
    {/key} {#key `${moduleName}-${index * 3 + 2}`}
    <Elm {elmJsFilename} {moduleName} />
    {/key} {/each}
  </div>
</section>
```

## Example 2. Using multiple `_moduleName_.js` files containing a module as same name as filename.

```html
<script lang="ts">
  import Elm from "$lib/elm/Elm.svelte";

  const elmJsFilenames = ["Hello", "Bye", "Welcome"] as const;
</script>

<section>
  <h2>
    Example 2. Using multiple `moduleName.js` files containing a module as same
    name as filename
  </h2>
  <div class="elm-container">
    {#each elmJsFilenames as elmJsFilename, index (`${elmJsFilename}-${index}`)}
      <Elm {elmJsFilename} />
    {/each}
    {#each elmJsFilenames as elmJsFilename, index}
      {#key `${elmJsFilename}-${index * 3}`}
        <Elm {elmJsFilename} />
      {/key}
      {#key `${elmJsFilename}-${index * 3 + 1}`}
        <Elm {elmJsFilename} />
      {/key}
      {#key `${elmJsFilename}-${index * 3 + 2}`}
        <Elm {elmJsFilename} />
      {/key}
    {/each}
  </div>
</section>
```

## See also
- [joakin/elm-node: Run Elm + JS programs easily in node](https://github.com/joakin/elm-node)

## Reference
- [JavaScript Interop · An Introduction to Elm](https://guide.elm-lang.org/interop/)
- [example of multiple elm apps on a single page](https://gist.github.com/epequeno/2d12d021bd865582b0fcb1509373ba25)

---

## Running examples - Method 1, 2

1. Go to `method(1|2)` directory:

```shell
cd method1 # or method2
```

2. Install npm packages:

```shell
npm i
```

3. (Only for Method 1) Compile `.elm` into `.js`:

```shell
# The command is equivalent to
# `cd ./src/lib/elm/elm-sample \
# && elm make src/Main.elm --output=../../../../static/elm.js`.
npm run elm:build
```

`elm:make` npm script is defined in `package.json`.

4. Run dev server:

```shell
npm run dev
```

## Running examples - Method 1 deep-dive

1. Go to `method1_deepdive` directory:

```shell
cd method1_deepdive
```

2. Install npm packages:

```shell
npm i
```

3. Compile `.elm` into `.js`:

```shell
npm run elm:build:examples1
npm run elm:build:examples2
```

4. Run dev server:

```shell
npm run dev
```
