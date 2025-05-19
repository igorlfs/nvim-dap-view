<script lang="ts">
    import '../app.css';
    import Header from '$lib/components/Header.svelte';
    import type { Snippet } from 'svelte';

    let { children }: { children: Snippet } = $props();
</script>

<div class="flex flex-col min-h-screen justify-between">
    <div class="sticky top-0 w-screen">
        <Header />
    </div>

    <div class="flex flex-1">
        <main>
            {@render children()}
        </main>
    </div>
</div>
