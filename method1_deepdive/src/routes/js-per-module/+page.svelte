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
