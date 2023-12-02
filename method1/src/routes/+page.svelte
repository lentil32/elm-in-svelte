<script context="module" lang="ts">
	declare let Elm: ElmInstance;
</script>

<script lang="ts">
	import { onMount } from 'svelte';

	let elmRoot: Node;
	onMount(() => {
		Elm.Main.init({
			node: elmRoot,
		});
	});
</script>

<svelte:head>
	<script src="/elm.js">
	</script>
</svelte:head>
<div bind:this={elmRoot} />
