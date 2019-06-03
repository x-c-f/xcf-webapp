import Vue from 'vue';
import Router from 'vue-router';
import Subcheck from '@/components/Subcheck';

Vue.use(Router);

export default new Router({
  routes: [
    {
      path: '/subcheck',
      alias: '/',
      name: 'Subcheck',
      component: Subcheck
    },
    {
      path: '/about',
      name: 'Help',
      component: {
        template: require('../../help.html')
      }
    },
    {
      path: '/imprint',
      name: 'Imprint',
      component: {
        template: require('../../imprint.html')
      }
    }
  ]
});
