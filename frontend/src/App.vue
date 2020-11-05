<template>
  <div id="app">
    <div class="row">
      <div class="col-xs-12">
        <nav class="navbar navbar-default">
          <div class="container-fluid">
            <div class="navbar-header">
              <button
                type="button"
                class="navbar-toggle collapsed"
                data-toggle="collapse"
                data-target="#navbar"
                aria-expanded="false"
                aria-controls="navbar"
              >
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
              </button>
              <a class="navbar-brand" href="#">xc<em>f</em></a>
            </div>
          </div>
        </nav>
      </div>
    </div>
    <router-view></router-view>
    <div class="row">
      <div class="col-xs-12">
        <h4 class="text-right" style="padding-top:1em;">
          XCF powered by
          <a href="http://www.irt.de" target="_blank"
            ><img class="img" src="@/assets/static/irt.png"
          /></a>
          <a href="http://www.basexgmbh.de" target="_blank"
            ><img class="img" src="@/assets/static/BaseX_512px.png"
          /></a>
        </h4>
      </div>
    </div>
  </div>
</template>

<script>
import { store } from "./store/store.js";
import "@/assets/css/bootstrap.css";

export default {
  name: "app",
  store: store
};
</script>

<style>
button:focus,
button.btn:focus,
button.btn.active:focus {
  outline: 0;
}
img.img {
  max-width: 70px;
  max-height: 40px;
  border: 5px solid white;
  border-radius: 5px;
}
h1,
h2,
h3,
h4,
h5,
button {
  font-weight: normal;
  /* font-family: "Comfortaa", cursive !important; */
}

html,
body {
  overflow: auto;
  background-color: #eeeeee !important;
  overflow-y: auto;
  overflow-x: hidden;
}
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  margin-top: 0px;
  padding: 0.5em;
}
.router-link-active {
  font-weight: bold;
}
/* Base styles (regardless of theme) */
.bs-callout {
  padding: 20px;
  margin: 20px 0;
  border: 1px solid #eee;
  border-left-width: 5px;
  border-radius: 3px;
}
.bs-callout h4 {
  margin-top: 0;
  margin-bottom: 5px;
}
.bs-callout p:last-child {
  margin-bottom: 0;
}
.bs-callout code {
  border-radius: 3px;
}
.bs-callout + .bs-callout {
  margin-top: -5px;
}
.bs-callout-default {
  border-left-color: #777;
}
.bs-callout-default h4 {
  color: #777;
}
.bs-callout-primary {
  border-left-color: #428bca;
}
.bs-callout-primary h4 {
  color: #428bca;
}
.bs-callout-success {
  border-left-color: #5cb85c;
}
.bs-callout-success h4 {
  color: #5cb85c;
}
.bs-callout-danger {
  border-left-color: #d9534f;
}
.bs-callout-danger h4 {
  color: #d9534f;
}
.bs-callout-warning {
  border-left-color: #f0ad4e;
}
.bs-callout-warning h4 {
  color: #f0ad4e;
}
.bs-callout-info {
  border-left-color: #5bc0de;
}
.bs-callout-info h4 {
  color: #5bc0de;
}
</style>
