<script lang="ts">
  import Elm from "$lib/elm/Elm.svelte";

  const elmJsFilename = "elm.js";
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
