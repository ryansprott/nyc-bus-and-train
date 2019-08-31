import Vue from 'vue'
import VueRouter from 'vue-router'
import Subway from './components/subway/Subway.vue'
import Bus from './components/bus/Bus.vue'
import Equipment from './components/equipment/Equipment.vue'
import Service from './components/service/Service.vue'

Vue.use(VueRouter)

const router = new VueRouter({
  mode: 'history',
  linkActiveClass: 'is-active',
  routes: [
  {
    path: '/',
    name: 'Redirect',
    redirect: (to) => {
      if (to.query.redirect) {
        // This will clear the ?redirect=<path> from the end URL
        var path = to.query.redirect
        delete to.query.redirect
        return {
          path: '/' + path,
          query: to.query
        }
      } else {
        return {
          path: '/index',
          query: to.query
        }
      }
    }
  },
  {
    path: '/equipment',
    name: 'Equipment',
    component: Equipment
  },
  {
    path: '/service',
    name: 'Service',
    component: Service
  },
  {
    path: '/subway',
    name: 'Subway',
    component: Subway
  },
  {
    path: '/index',
    name: 'Index',
    component: Bus
  }]
})

export default router
