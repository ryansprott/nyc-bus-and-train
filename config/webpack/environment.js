const { environment } = require('@rails/webpacker')
const vue = require('./loaders/vue')

environment.loaders.append('vue', vue)

const VueLoaderPlugin = require('vue-loader/lib/plugin');
environment.plugins.append(
  'VueLoaderPlugin',
  new VueLoaderPlugin()
);

module.exports = environment
