import type { Post, PostMetadata } from '$lib/types';
import { error } from '@sveltejs/kit';
import type { Load } from '@sveltejs/kit';

export const load: Load = async ({ params, fetch }) => {
    try {
        const post: Post = await import(`../../posts/${params.slug}.md`);

        const response = await fetch('api/posts');
        const posts: PostMetadata[] = await response.json();

        return { posts, post };
    } catch {
        error(404, `Could not find ${params.slug}`);
    }
};
