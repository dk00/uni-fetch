import
  \rollup-plugin-babel : babel
  \rollup-plugin-node-resolve : resolve

targets =
  * \src/index.ls \dist/index.esm.js \es
  * \src/index.ls \dist/index.js \iife
  * \src/index.ls \lib/index.js \cjs

config-list = targets.map ([input, output, format]) ->
  input: input
  output: {file: output, format, sourcemap: true strict: false}
  plugins:
    resolve jsnext: true extensions: <[.ls]>
    babel!

  external: Object.keys <| require \./package.json .dependencies

export default: config-list
