const { environment } = require('@rails/webpacker')
// #追記 5段階評価の実装
const webpack = require('webpack')

environment.plugins.prepend('Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    jquery: 'jquery/src/jquery',
  })
)
// #ここまで 5段階評価の実装
module.exports = environment
