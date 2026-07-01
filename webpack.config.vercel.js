// Webpack config for Vercel deployment (static frontend)
// Builds the React bundle into /public/bundle.js (served as static asset)
const path = require('path');

module.exports = {
  entry: './frontend/infinite_px.jsx',
  output: {
    path: path.resolve(__dirname, "public"),
    filename: 'bundle.js'
  },
  devtool: 'source-map',
  resolve: {
    extensions: [".js", ".jsx", "*"]
  },
  module: {
    rules: [
      {
        test: /\.jsx?$/,
        exclude: /(node_modules)/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/env', '@babel/react']
          }
        }
      }
    ]
  }
};
