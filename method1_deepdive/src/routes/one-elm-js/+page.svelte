<script lang="ts">
  import Elm from "$lib/elm/Elm.svelte";

  const elmJsFilename = "elm";
  const moduleNames = ["Counter", "TextField"] as const;
</script>

<hgroup>
  <h2>Using one `elm.js` file containing multiple modules</h2>
  <h3>Each module is used 3 times.</h3>
</hgroup>
<div>
  {#each moduleNames as moduleName}
    {#each Array(3) as _, index (`${moduleName}-${index * 3}`)}
      <div>
        <Elm {elmJsFilename} {moduleName} />
      </div>
    {/each}
  {/each}
</div>
