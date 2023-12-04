<script lang="ts">
  import Elm from "$lib/elm/Elm.svelte";

  const elmJsFilenames = ["Hello", "Bye", "Welcome"] as const;
</script>

<hgroup>
  <h2>
    Example 2. Using multiple `moduleName.js` files containing a module as same
    name as filename.
  </h2>
  <h3>Modules are used 3 times each.</h3>
</hgroup>
<div>
  {#each elmJsFilenames as elmJsFilename}
    {#each Array(3) as _, index (`${elmJsFilename}-${index * 3}`)}
      <Elm {elmJsFilename} />
    {/each}
  {/each}
</div>
