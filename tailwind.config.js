/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./views/**/*.{ejs,html,js}",
    "./public/**/*.html"
  ],
  theme: {
    extend: {
      colors: {
        horriver: {
          dark: "#050805",
          red: "#0b6b2a",
          orange: "#f5b21b",
          light: "#fff8e8",
          gray: "#d7d2c4"
        }
      },
      fontFamily: {
        sans: ["Inter", "system-ui", "sans-serif"],
        title: ["Oswald", "system-ui", "sans-serif"]
      },
      boxShadow: {
        card: "0 4px 12px rgba(0, 0, 0, 0.25)",
        glow: "0 0 10px rgba(245, 178, 27, 0.5)"
      },
      backgroundImage: {
        "gradient-horriver": "linear-gradient(135deg, #0b6b2a 0%, #f5b21b 100%)"
      },
      borderRadius: {
        xl: "1rem",
        "2xl": "1.5rem"
      },
      transitionDuration: {
        DEFAULT: "300ms"
      },
      screens: {
        xs: "480px"
      },
      container: {
        center: true,
        padding: "1rem"
      },
      keyframes: {
        fadeIn: {
          "0%": { opacity: 0, transform: "translateY(10px)" },
          "100%": { opacity: 1, transform: "translateY(0)" }
        }
      },
      animation: {
        fadeIn: "fadeIn 0.6s ease-in-out"
      }
    }
  },
  plugins: [
    require("@tailwindcss/forms"),
    require("@tailwindcss/typography"),
    require("@tailwindcss/aspect-ratio")
  ]
};
