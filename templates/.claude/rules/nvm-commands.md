# NVM/PNPM Command Policy

**ALWAYS use `nvm` for Node version management and `pnpm` as the package manager.**

## Command Replacements

| Wrong | Correct |
|-------|---------|
| `npm install` | `pnpm install` |
| `npm run dev` | `pnpm dev` |
| `npm run build` | `pnpm build` |
| `npm test` | `pnpm test` |
| `npx create-app` | `pnpm dlx create-app` |
| `npm install -g pkg` | `pnpm add -g pkg` |

## Version Management

- Always check for `.nvmrc` file in project root
- Use `nvm use` before running Node commands if version mismatch
- Default to LTS version when no .nvmrc exists
- The shell auto-switches versions via `load-nvmrc` hook

## Rationale

- NVM ensures correct Node version per project
- pnpm is faster and more disk-efficient than npm
- Consistent across macOS, WSL, and Linux

## This Applies To

- All Node.js script execution
- All package installations
- All npm scripts (use pnpm equivalents)
- All global tool installations

**No exceptions. Always use nvm/pnpm.**
