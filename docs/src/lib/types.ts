import type { Component } from "svelte";

export const CATEGORIES = ['Recipes'] as const;
type Category = (typeof CATEGORIES)[number];

export type PostMetadata = {
    title: string;
    slug: string;
    category?: Category
    hidden?: boolean
};

export type Post = { default: Component; metadata: PostMetadata }
