<script lang="ts">
	import { onMount } from 'svelte';
	import { Elm } from '$lib/elm-sample/src/Main.elm'

	let elmRoot: Node;
	onMount(() => {
		Elm.Main.init({
			node: elmRoot,
		});
	});
</script>

<div bind:this={elmRoot} />
