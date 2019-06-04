// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import App from './App';
import router from './router';

import VuePrism from 'vue-prism';
Vue.use(VuePrism);

import VueClipboard from 'vue-clipboard2';
Vue.use(VueClipboard);

import 'prismjs/themes/prism.css';
Vue.config.productionTip = false;

Vue.filter("numeral", function (value) {
  return require("numeral")(value).format("0,2"); // displaying other groupings/separators is possible, look at the docs
});

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  template: '<App/>',
  components: { App }
});
