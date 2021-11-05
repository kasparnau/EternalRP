const path = require("path");
const WebpackObfuscator = require("webpack-obfuscator");

module.exports = function (env, argv) {
  let pPlugins = [];
  if (env.obfuscate === `true`) {
    pPlugins.push(new WebpackObfuscator({}, ["server/**.js"]));
  }
  return {
    entry: {
      server: {
        import: "./src/server/server.ts",
        filename: "server/sv_main.js",
      },
      shared: {
        import: "./src/shared/shared.ts",
        filename: "shared/sh_main.js",
      },
      client: {
        import: "./src/client/client.ts",
        filename: "client/cl_main.js",
      },
    },
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
    plugins: pPlugins,
    target: "node",
  };
};
