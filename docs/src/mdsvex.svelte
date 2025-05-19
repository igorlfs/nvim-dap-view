<script lang="ts" module>
    import { img } from '$lib/components/custom';
    export { img };
</script>

<script lang="ts">
    import type { Snippet } from 'svelte';
    let { children }: { children: Snippet } = $props();
</script>

{@render children()}
