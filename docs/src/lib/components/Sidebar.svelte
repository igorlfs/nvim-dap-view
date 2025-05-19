<script lang="ts">
    import { title } from '$lib/config';
    import { CATEGORIES, type PostMetadata } from '$lib/types';

    let { posts }: { posts: PostMetadata[] } = $props();

    const topLevelPosts = posts.filter(
        (p) => p.category === undefined && p.title !== title && !p.hidden
    );

    const postsGroupedByCategory = $state(
        CATEGORIES.map((c) => ({
            category: c,
            posts: posts.filter((p) => p.category === c && !p.hidden),
            collapsed: true
        }))
    );
</script>

<div class="flex flex-row justify-start items-start min-w-[20vw]">
    <div class={`bg-crust h-full flex w-[90%] pt-4`}>
        <div class="flex flex-col gap-4 pr-4">
            <div class="flex flex-col gap-4">
                {#each topLevelPosts as post}
                    <div class="ml-11 text-xl">
                        <a href={post.slug}>
                            {post.title}
                        </a>
                    </div>
                {/each}
            </div>
            <div class="flex flex-col">
                {#each postsGroupedByCategory as { posts, category, collapsed }, i}
                    <div class="flex flex-row gap-2">
                        <button
                            class="ml-5 text-primary hover:text-accent hover:cursor-pointer font-bold text-xl"
                            onclick={() => (postsGroupedByCategory[i].collapsed = !collapsed)}
                            ><i
                                class="nf {collapsed
                                    ? 'nf-fa-chevron_right'
                                    : 'nf-fa-chevron_down'}"
                            ></i>
                            {category}</button
                        >
                    </div>
                    {#if !collapsed}
                        <div class="flex flex-col gap-2 pt-1">
                            {#each posts as post}
                                <div class="ml-16 text-md">
                                    <a href={post.slug}>
                                        {post.title}
                                    </a>
                                </div>
                            {/each}
                        </div>
                    {/if}
                {/each}
            </div>
        </div>
    </div>
</div>
