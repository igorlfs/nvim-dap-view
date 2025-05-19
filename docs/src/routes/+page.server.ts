import { redirect, type Load } from '@sveltejs/kit';

export const load: Load = async () => {
    redirect(301, 'home')
};
