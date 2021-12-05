import {createApp} from "vue";
import App from './App.vue'
import router from './router'

window.$ = window.jQuery = require('jquery');

const app = createApp(App)

/*axios.interceptors.request.use(
    config => {
        const token = config.headers.common.Authorization
        if (token) {
            console.log(token)
            axios.defaults.headers.common['Authorization'] = token
        }
        return config;
    },
    error => {
        return Promise.reject(error);
    }
);*/

app.use(router)
app.mount('#app')