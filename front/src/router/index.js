import {createRouter, createWebHistory} from 'vue-router'
import Panel from '../views/Panel.vue'
import Login from "../views/Login";

const routes = [
    {
        path: '/home',
        name: 'home',
        component: Panel
    },
    {
        path: '/',
        name: 'login',
        component: Login
    },
]

const router = createRouter({
    history: createWebHistory(process.env.BASE_URL),
    routes
})

export default router
