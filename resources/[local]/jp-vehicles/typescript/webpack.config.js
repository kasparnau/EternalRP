const path = require("path");

module.exports = {
  entry: {
    server: { import: "./src/server/index.ts", filename: "server/server.js" },
    client: { import: "./src/client/index.ts", filename: "client/client.js" },
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
};
