import adapter from '@sveltejs/adapter-static';
import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';
import { mdsvex, escapeSvelte } from 'mdsvex';
import { getSingletonHighlighter } from 'shiki';
import remarkUnwrapImages from 'remark-unwrap-images';
import remarkFootNotes from 'remark-footnotes';
import rehypeAutolinkHeadings from 'rehype-autolink-headings';
import rehypeSlug from 'rehype-slug';

/** @type {import('mdsvex').MdsvexOptions} */
const mdsvexOptions = {
    extensions: ['.md'],
    layout: {
        _: './src/mdsvex.svelte'
    },
    remarkPlugins: [remarkFootNotes, remarkUnwrapImages],
    rehypePlugins: [
        rehypeSlug,
        [
            rehypeAutolinkHeadings,
            {
                behavior: 'wrap'
            }
        ]
    ],
    highlight: {
        highlighter: async (code, lang = 'text') => {
            const highlighter = await getSingletonHighlighter({
                themes: ['catppuccin-mocha'],
                langs: ['javascript', 'typescript', 'lua', 'jsonc']
            });
            await highlighter.loadLanguage('javascript', 'typescript', 'lua', 'jsonc');
            const html = escapeSvelte(
                highlighter.codeToHtml(code, { lang, theme: 'catppuccin-mocha' })
            );
            return `{@html \`${html}\` }`;
        }
    }
};

/** @type {import('@sveltejs/kit').Config} */
const config = {
    // Consult https://kit.svelte.dev/docs/integrations#preprocessors
    // for more information about preprocessors
    extensions: ['.svelte', '.md'],
    preprocess: [vitePreprocess(), mdsvex(mdsvexOptions)],

    kit: {
        adapter: adapter(),
        paths: {
            base: process.env.NODE_ENV === 'production' ? '/igorlfs.github.io/nvim-dap-view' : ''
        }
    }
};

export default config;
