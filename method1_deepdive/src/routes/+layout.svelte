<script lang="ts">
  import "@picocss/pico";
  import { base } from "$app/paths";
  import { page } from "$app/stores";

  type Menu = {
    url: `/${string}`;
    title: string;
  };

  const menus: Array<Menu> = [
    {
      url: `${base}/`,
      title: "Home",
    },
    {
      url: `${base}/one-elm-js`,
      title: "Example 1",
    },
    {
      url: `${base}/js-per-module`,
      title: "Example 2",
    },
  ];
</script>

<nav class="container">
  <ul>
    <li>How to Embed Elm into Svelte with TypeScript Setup</li>
  </ul>
  <ul>
    <li>
      <a href="https://github.com/lenntil/elm-in-svelte"
        ><strong>GitHub</strong></a
      >
    </li>
  </ul>
</nav>

<nav class="container">
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
</nav>

<main class="container">
  <slot />
</main>
