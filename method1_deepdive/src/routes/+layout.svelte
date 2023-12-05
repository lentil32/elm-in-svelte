<script lang="ts">
  import "@picocss/pico";
  import { page } from "$app/stores";
  import { base } from "$app/paths";

  type Menu = {
    url: string;
    title: string;
  };

  const menus: Array<Menu> = [
    {
      url: base,
      title: "Home",
    },
    {
      url: "one-elm-js",
      title: "Example 1",
    },
    {
      url: "js-per-module",
      title: "Example 2",
    },
  ];

  let currentPathFromBase: string;

  $: currentPathFromBase =
    $page.url.pathname
      .split(base + "/")
      .slice(1)
      .join("/") || base;
</script>

<svelte:head>
  <title>How to Embed Elm into Svelte - Elm in Svelte</title>
  <meta
    name="description"
    content="Learn how to integrate Elm modules in a Svelte application."
  />
  <meta
    name="keywords"
    content="Svelte, Elm, SvelteKit, TypeScript, Functional Programming, Integration, Web Development"
  />
</svelte:head>

<header class="container-fluid">
  <a
    href={`https://github.com/lenntil${base}`}
    aria-label="Visit GitHub Repository"
    class="github-link"
  >
    <strong>{`←  Visit GitHub Repository`}</strong>
  </a>

  <div class="container">
    <hgroup>
        <small class="subtitle"> Elm in Svelte </small>
      <h2>How to Embed Elm into Svelte</h2>
      <h3>with TypeScript Setup</h3>
    </hgroup>
  </div>
</header>
<article>
  <main class="container">
    <nav>
      <ul>
        {#each menus as menu (menu)}
          <li>
            <a
              href={menu.url}
              class:primary={currentPathFromBase !== menu.url}
              class:secondary={currentPathFromBase === menu.url}
            >
              {#if currentPathFromBase === menu.url}
                <u>
                  {menu.title}
                </u>
              {:else}
                {menu.title}
              {/if}
            </a>
          </li>
        {/each}
      </ul>
    </nav>

    <hr />
    <slot />
  </main>
</article>

<footer />

<style>
  .container {
    max-width: 800px;
  }

  .subtitle {
  text-decoration: underline;
}

  hgroup {
    margin-top: 1rem;
  }

  header {
    padding: 1rem;
  }

  nav ul {
    display: flex;
    gap: 0.5rem;
  }

  main {
    padding-bottom: 2rem;
  }

  article {
    min-height: calc(100vh - 300px);
    margin-top: 0rem;
    padding: 1rem;
  }

  hr {
    margin-top: 1rem;
    margin-bottom: 1rem;
  }

  footer {
    margin-top: 5rem;
  }
</style>
