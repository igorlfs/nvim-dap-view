<script lang="ts">
    import { page } from '$app/state';
</script>

<div class="w-screen h-screen items-center justify-center flex">
    <div class="flex flex-col items-center">
        <h1 class="text-primary text-3xl font-bold">{page.status}</h1>

        <p class="text-text">{page.error?.message}</p>
    </div>
</div>
