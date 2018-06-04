import
  \rollup-plugin-babel : babel
  \rollup-plugin-node-resolve : resolve

targets =
  * \src/index.ls \dist/index.esm.js \es
  * \src/index.ls \dist/index.js \iife
  * \src/index.ls \lib/index.js \cjs

name = \UniFetch

config-list = targets.map ([input, output, format]) ->
  input: input
  output: {name, file: output, format, sourcemap: true strict: false}
  plugins:
    resolve jsnext: true extensions: <[.ls]>
    babel!

export default: config-list
