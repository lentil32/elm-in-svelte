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

<div bind:this={elmRoot} />
