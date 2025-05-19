export const prerender = true;

import type { PostMetadata } from '$lib/types';
import { json } from '@sveltejs/kit';

async function getPosts() {
    let posts: PostMetadata[] = [];

    const paths = import.meta.glob('/src/posts/*.md', { eager: true });

    for (const path in paths) {
        const file = paths[path];
        const slug = path.split('/').at(-1)?.replace('.md', '');

        if (file && typeof file === 'object' && 'metadata' in file && slug) {
            const metadata = file.metadata as Omit<PostMetadata, 'slug'>;
            const post = { ...metadata, slug } satisfies PostMetadata;
            posts.push(post);
        }
    }

    return posts;
}

export async function GET() {
    const posts = await getPosts();
    return json(posts);
}
