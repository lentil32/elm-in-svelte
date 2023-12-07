<script lang="ts">
  import Elm from "$lib/elm/Elm.svelte";

  const moduleNames = ["Hello", "Bye", "Welcome"] as const;
</script>

<hgroup>
  <h4>Using multiple `moduleName.js` files each containing one module</h4>
  <h5>
    Each module is used 3 times.
  </h5>
</hgroup>
<div>
  {#each moduleNames as moduleName}
    {#each Array(3) as _, index (`${moduleName}-${index * 3}`)}
      <Elm elmJsFilename={`${moduleName}.min.js`} {moduleName} />
    {/each}
  {/each}
</div>
