<script lang="ts">
  import { base } from "$app/paths";
</script>

<h3>Elm Integration Examples</h3>
<ul>
  <li>
    <a href="{base}/one-elm-js">
      Example 1: Single 'elm.js' file with multiple modules
    </a>
  </li>
  <li>
    <a href="{base}/js-per-module">
      Example 2: Multiple '.js' files, each containing a separate module
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
