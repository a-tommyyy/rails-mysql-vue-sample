import Vue from 'vue/dist/vue.esm.js'
import Router from './router/index'
import Header from './components/Header'

var app = new Vue({
  router: Router,
  el: '#app',
  components: {
    'navbar': Header,
  }
})
