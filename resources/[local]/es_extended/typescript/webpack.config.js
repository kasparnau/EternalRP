const path = require("path");
const WebpackObfuscator = require("webpack-obfuscator");

module.exports = function (env, argv) {
  let pPlugins = [];
  console.log(`ENV: ${JSON.stringify(env)}`);
  if (env.obfuscate === `true`) {
    pPlugins.push(
      new WebpackObfuscator( // LOW rc4
        {
          compact: true,
          controlFlowFlattening: false,
          deadCodeInjection: false,
          debugProtection: false,
          debugProtectionInterval: false,
          disableConsoleOutput: true,
          identifierNamesGenerator: "hexadecimal",
          log: false,
          numbersToExpressions: false,
          renameGlobals: false,
          selfDefending: true,
          simplify: true,
          splitStrings: false,
          stringArray: true,
          stringArrayEncoding: ["rc4"],
          stringArrayIndexShift: true,
          stringArrayRotate: true,
          stringArrayShuffle: true,
          stringArrayWrappersCount: 1,
          stringArrayWrappersChainedCalls: true,
          stringArrayWrappersParametersMaxCount: 2,
          stringArrayWrappersType: "variable",
          stringArrayThreshold: 1,
          unicodeEscapeSequence: false,
        },
        ["server/**.js"]
      )
    );
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
