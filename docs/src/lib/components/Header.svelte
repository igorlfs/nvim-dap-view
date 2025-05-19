<script lang="ts">
    import { title } from '$lib/config';
</script>

<nav class="bg-crust p-2">
    <div class="flex justify-between items-center py-2">
        <div class="flex justify-between xl:px-24 sm:px-16">
            <a class="text-xl text-accent" href="home">{title}</a>
        </div>
        <div class="flex text-2xl pr-5 gap-5">
            <a
                href="https://github.com/igorlfs/nvim-dap-view"
                target="_blank"
                aria-label="GitHub Link"
            >
                <i class="nf nf-fa-github"></i>
            </a>
            <a href="https://github.com/sponsors/igorlfs" target="_blank" aria-label="Donate Link">
                <i class="nf nf-fa-heart"></i>
            </a>
        </div>
    </div>
</nav>
