/* eslint no-console: 0 */
import Vue from "vue";
import store from "../vuexStore.js";
import Layout from "../components/Layout.vue";
import router from "../router";
import Autocomplete from "buefy/dist/components/autocomplete";
import "buefy/dist/buefy.css";
Vue.use(Autocomplete);

document.addEventListener("DOMContentLoaded", () => {
  const el = document.querySelector("#vue-app");
  const app = new Vue({
    el,
    store: store,
    router,
    render: (h) => h(Layout),
  });
});
