import type { Post, PostMetadata } from '$lib/types';
import { error } from '@sveltejs/kit';
import type { Load } from '@sveltejs/kit';
import { allPosts } from '../posts.svelte';

export const load: Load = async ({ params, fetch }) => {
    try {
        const post: Post = await import(`../../posts/${params.slug}.md`);

        const response = await fetch('api/posts');
        const posts: PostMetadata[] = await response.json();

        allPosts.update(() => posts)

        return { posts, post };
    } catch {
        error(404, `Could not find ${params.slug}`);
    }
};
