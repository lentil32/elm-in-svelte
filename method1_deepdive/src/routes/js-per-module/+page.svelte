<script lang="ts">
  import Elm from "$lib/elm/Elm.svelte";

  const elmJsFilenames = ["Hello", "Bye", "Welcome"] as const;
</script>

<hgroup>
  <h2>Using multiple `moduleName.js` files</h2>
  <h3>
    Each module is used 3 times.
  </h3>
</hgroup>
<div>
  {#each elmJsFilenames as elmJsFilename}
    {#each Array(3) as _, index (`${elmJsFilename}-${index * 3}`)}
      <Elm {elmJsFilename} />
    {/each}
  {/each}
</div>
