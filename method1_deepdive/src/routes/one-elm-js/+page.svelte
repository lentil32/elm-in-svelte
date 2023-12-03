<script lang="ts">
  import Elm from "$lib/elm/Elm.svelte";

  const elmJsFilename = "elm";
  const moduleNames = ["Counter", "TextField"] as const;
</script>

<section>
  <h2>Example 1. Using one `elm.js` file containing multiple modules</h2>
  <div class="elm-container">
    {#each moduleNames as moduleName, index (`${elmJsFilename}-${moduleName}-${index}`)}
      <Elm {elmJsFilename} {moduleName} />
    {/each}
    {#each moduleNames as moduleName, index}
      {#key `${moduleName}-${index * 3}`}
        <Elm {elmJsFilename} {moduleName} />
      {/key}
      {#key `${moduleName}-${index * 3 + 1}`}
        <Elm {elmJsFilename} {moduleName} />
      {/key}
      {#key `${moduleName}-${index * 3 + 2}`}
        <Elm {elmJsFilename} {moduleName} />
      {/key}
    {/each}
  </div>
</section>
