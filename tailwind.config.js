/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/views/**/*.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/components/**/*.{erb,rb}'
  ],
  theme: {
    extend: {
      fontFamily: {
        'rounded': ['M PLUS Rounded 1c', 'sans-serif'],
      },
    },
  },
  plugins: [],
} 