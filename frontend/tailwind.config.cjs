/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{js,ts,jsx,tsx}"],
  daisyui: {
    themes: [
      {
        mytheme: {
          // eslint-disable-next-line @typescript-eslint/no-var-requires
          ...require("daisyui/src/colors/themes")["[data-theme=dark]"],
          primary: "#F50029",
          secondary: "#f6d860",
          accent: "#37cdbe",
          neutral: "#3d4451",
          "base-100": "#ffffff",
        },
      },
    ],
  },
  theme: {
    extend: {
      colors: {
        "neutral-dark": "#14171A",
        "neutral-medium": "#1A1E23",
        "neutral-light": "#68778D",
        primary: "#F50029",
        white: "#FFF",
      },
    },
  },
  plugins: [require("daisyui")],
};
