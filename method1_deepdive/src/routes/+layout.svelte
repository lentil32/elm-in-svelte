<nav class="navbar">
  <ul class="nav-links">
    <li><a href="/">Home</a></li>
    <li><a href="/one-elm-js">Elm Example 1</a></li>
    <li><a href="/js-per-module">Elm Example 2</a></li>
  </ul>
</nav>

<main>
  <slot></slot>
</main>

<style>
  .navbar {
    background-color: #333;
    color: white;
    padding: 1rem;
  }

  .nav-links {
    list-style: none;
    padding: 0;
    display: flex;
    justify-content: space-around;
  }

  .nav-links li {
    margin-right: 20px;
  }

  .nav-links a {
    color: white;
    text-decoration: none;
  }

  .nav-links a:hover {
    text-decoration: underline;
  }

  main {
    margin-top: 20px;
  }
</style>

