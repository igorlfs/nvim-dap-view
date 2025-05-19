<script lang="ts">
    import { base } from '$app/paths';
    import type { HTMLImgAttributes } from 'svelte/elements';

    let { src, ...props }: { src: string; props: Partial<HTMLImgAttributes> } = $props();
</script>

<img src={base + src} {...props} loading="lazy" />
