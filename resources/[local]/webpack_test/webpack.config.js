const path = require("path");
var WebpackObfuscator = require("webpack-obfuscator");

module.exports = {
  entry: "./src/client.js",
  output: {
    filename: "client.js",
    path: path.resolve(__dirname, ""),
  },
  plugins: [
    new WebpackObfuscator({
      rotateStringArray: true,
    }),
  ],
  watch: true,
};
