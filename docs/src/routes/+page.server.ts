import { resolve } from '$app/paths';
import { redirect, type Load } from '@sveltejs/kit';

export const load: Load = async () => {
    redirect(301, resolve('/home'))
};
