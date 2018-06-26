const { environment } = require('@rails/webpacker')

environment.config.externals = {
    jquery: 'jQuery',
    'rails-ujs': 'Rails'
}

const webpack = require('webpack');
environment.plugins.append('Provide', new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery'
}));

module.exports = environment
