export default {
  input: './source/javascripts/manifest.js',
  output: {
    file: './.tmp/dist/javascripts/main.js',
    sourcemap: true,
    format: 'iife',
    name: 'squirrelstories_fm',
  }
}
