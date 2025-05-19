<script lang="ts">
    import Sidebar from '$lib/components/Sidebar.svelte';
    import type { Post, PostMetadata } from '$lib/types';

    let { data }: { data: { post: Post; posts: PostMetadata[] } } = $props();

    let post = $derived(data.post);
    let metadata = $derived(post.metadata);
</script>

<svelte:head>
    <title>{metadata.title}</title>
    <meta property="og:type" content="article" />
    <meta property="og:title" content={metadata.title} />
</svelte:head>

<div class="flex">
    <div class="sticky top-16 flex h-[93.5vh]">
        <div class="flex xl:basis-1/5 basis-1/3">
            <Sidebar posts={data.posts} />
        </div>
    </div>

    <div class="flex xl:basis-4/5 basis-2/3 w-full">
        <div class="mt-10 mb-32 flex justify-center">
            <article class="xl:mx-56 mx-16 size-full">
                <h1 class="capitalize sm:text-5xl text-3xl font-bold text-primary mb-5">
                    {metadata.title}
                </h1>
                <div class="prose lg:prose-xl max-w-none">
                    <post.default />
                </div>
            </article>
        </div>
    </div>
</div>
