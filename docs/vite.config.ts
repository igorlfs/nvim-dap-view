import { defaultTheme } from '@sveltepress/theme-default'
import { sveltepress } from '@sveltepress/vite'
import { defineConfig } from 'vite'
import { sidebar } from './sidebar'

const config = defineConfig({
    plugins: [
        sveltepress({
            theme: defaultTheme({
                logo: 'debug.svg',
                navbar: [
                    {
                        icon: `<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><rect width="24" height="24" fill="none"/><path fill="currentColor" d="m12 21.35l-1.45-1.32C5.4 15.36 2 12.27 2 8.5C2 5.41 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.08C13.09 3.81 14.76 3 16.5 3C19.58 3 22 5.41 22 8.5c0 3.77-3.4 6.86-8.55 11.53z"/></svg>`,
                        to: 'https://github.com/sponsors/igorlfs',
                        external: true,
                    }
                ],
                sidebar,
                docsearch: {
                    appId: 'IOFPBXHWVK',
                    indexName: 'nvim-dap-view docs',
                    apiKey: '47c105056687bc378984225a6d78acd1'
                },
                github: 'https://github.com/igorlfs/nvim-dap-view/',
                highlighter: {
                    languages: ['lua', 'jsonc'],
                    themeLight: 'catppuccin-mocha',
                    themeDark: 'catppuccin-mocha'
                },
                themeColor: {
                    dark: '#1e1e2e',
                    light: '#eff1f5',
                    hover: '#c6a0f6',
                    gradient: {
                        start: '#ff0000',
                        end: '#00ff00',
                    },
                    primary: '#89b4fa'
                }
            }),
            siteConfig: {
                title: 'NVIM DAP View',
                description: 'Modern debugging UI for neovim',
            },
        }),
    ],
})

export default config
