<script lang="ts">
  import "@picocss/pico";
  import { page } from "$app/stores";
    import { base } from "$app/paths";

  type Menu = {
    url: `/${string}`;
    title: string;
  };

  const menus: Array<Menu> = [
    {
      url: `/`,
      title: "Home",
    },
    {
      url: `/one-elm-js`,
      title: "Example 1",
    },
    {
      url: `/js-per-module`,
      title: "Example 2",
    },
  ];

</script>

<svelte:head>
  <title>How to Embed Elm into Svelte with TypeScript Setup</title>
</svelte:head>

<header class="container">
  <hgroup>
    <h1>Elm in Svelte</h1>
    <h2>How to Embed Elm into Svelte with TypeScript Setup</h2>
  </hgroup>

  <nav>
    <ul>
      {#each menus as menu (menu)}
        <li>
          <a
            href={menu.url}
            class:primary={$page.url.pathname !== menu.url}
            class:secondary={$page.url.pathname === menu.url}
          >
            {#if $page.url.pathname === menu.url}
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
    <ul>
      <li>
        <a
          href={`https://github.com/lenntil/${base}`}
          aria-label="GitHub repository for Elm in Svelte"
        >
          <strong>GitHub Repository</strong>
        </a>
      </li>
    </ul>
  </nav>
</header>

<main class="container">
  <slot />
</main>
