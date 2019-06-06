import Vue from 'vue';
import Router from 'vue-router';
import XCF from '@/components/XCF';

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/xcf',
      alias: '/',
      name: 'XCF',
      component: XCF
    }
  ]
});
