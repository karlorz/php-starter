/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./assets/**/*.js",
    "./templates/**/*.html.twig",
  ],
  theme: {
    extend: {
      lineHeight: {
        'full-h': '100vh',
      },
    },
  },
  plugins: [],
}

