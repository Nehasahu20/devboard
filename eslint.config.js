import js from "@eslint/js";
import globals from "globals";
import { defineConfig } from "eslint/config";

export default defineConfig([
  // Apply settings to all JavaScript files
  { 
    files: ["**/*.js", "**/*.mjs", "**/*.cjs"], 
    languageOptions: { 
      globals: globals.browser // Adds browser-specific global variables
    } 
  },
  // Apply standard recommended linting rules
  { 
    files: ["**/*.js"], 
    plugins: { js }, 
    rules: {
      ...js.configs.recommended.rules,
      "no-unused-vars": "error", // Throws an error for unused variables
      "prefer-const": "warn"     // Warns when 'let' can be 'const'
    } 
  },
]);
