<script lang="ts">
  import { base } from "$app/paths";
</script>

<h2>Elm Integration Examples</h2>
<ul>
  <li>
    <a href="{base}/one-elm-js">
      Example 1: Single 'elm.js' File with Multiple Modules
    </a>
  </li>
  <li>
    <a href="{base}/js-per-module">
      Example 2: Multiple '.js' Files, Each Containing a Separate Module
    </a>
  </li>
</ul>

<div>
  <h3>Key Considerations</h3>
  <ul>
    <li>1. States are separated for each component.</li>
    <li>2. Programmatic loading of scripts for enhanced performance.</li>
    <li>
      3. Prevention of multiple script loads that can cause errors in Elm and
      affect performance.
    </li>
  </ul>
</div>
