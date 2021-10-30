const path = require("path");
const WebpackObfuscator = require("webpack-obfuscator");

module.exports = {
  entry: {
    server: { import: "./src/server/server.ts", filename: "server/sv_main.js" },
    shared: { import: "./src/shared/shared.ts", filename: "shared/sh_main.js" },
    client: { import: "./src/client/client.ts", filename: "client/cl_main.js" },
  },
  mode: "production",
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: "ts-loader",
        exclude: /node_modules/,
      },
    ],
  },
  resolve: {
    extensions: [".tsx", ".ts", ".js"],
  },
  output: {
    filename: "[name].js",
    path: path.resolve(__dirname, "../"),
  },
  plugins: [new WebpackObfuscator({}, ["server/**.js"])],
  target: "node",
};
