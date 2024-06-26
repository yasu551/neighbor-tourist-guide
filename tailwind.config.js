import daisyui from "daisyui"
module.exports = {
  content: [
    './app/views/**/*.html.haml',
    './app/views/**/*.turbo_stream.haml',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [
      daisyui,
  ],
  daisyui: {
    themes: ["retro"],
  },
}
