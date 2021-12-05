<template>

  <div class="position-absolute top-50 start-50 translate-middle">
    <div class="row justify-content-md-center">

      <div class="card" style="width: 33em;height: auto">
        <div class="card-body">
          <h5 class="card-title text-center mt-3">Identification</h5>
          <h6 class="card-subtitle mb-5 text-center text-muted"></h6>

          <form id="loginForm" class="form-floating">
            <div class="form-floating mb-3">
              <input type="email" class="form-control" name="email" id="email"
                     placeholder="Adresse mail">
              <label for="email">Adresse mail</label>
            </div>
            <div class="form-floating mb-5">
              <input type="password" class="form-control" name="password" id="password"
                     placeholder="Mot de passe">
              <label for="password">Mot de passe</label>
            </div>
          </form>

        </div>

        <button @click="testLogin"
                style="position: relative; width: 60%; align-self:center"
                class="btn btn-primary mb-5">Connexion
        </button>

      </div>

    </div>
  </div>
</template>

<script>
import axiosToken from "../axiosToken";

export default {
  name: "Login",
  methods: {
    testLogin: function () {
      axiosToken.post('/session/new', {
        "email": window.$('#email').val(),
        "password": window.$('#password').val()
      })
          .then((res) => {
            //console.log(res)
            if (res.status == 201) {
              window.$('#MsgErrHead').html('<div class="alert alert-success mt-3 text-center" style="font-size: 15px" role="alert"><i class="bi bi-check-circle"></i></i> Connexion reussi</div>')
              setTimeout(() => {
                window.$('#MsgErrHead').empty()
              }, 3000)
              const token = 'Bearer ' + res.data.access_token

              axiosToken.defaults.headers.common['Authorization'] = token

              /*   axiosToken.post("/session/refresh", {}, {withCredentials: true})
                     .then((res) => {
                       console.log(res)
                     })
                     .catch((err) => {
                       console.log(err)
                     })
                 /*  setInterval(() => {
                     axiosToken.post("/session/refresh", {}, {
                       'Authorization': 'Bearer ' + token + ''
                     })
                         .then((res) => {
                           console.log(res)
                         })
                         .catch((err) => {
                           console.log(err)
                         })
                   }, 2000)*/

              if (res.data.role) {
                this.$router.push({name: 'home'})

              } else {
                this.$router.push({name: 'home'})

              }

            }
          })
          .catch((err) => {
            console.log(err)
            window.$('#MsgErrHead').html('<div class="alert alert-danger mt-3 text-center" style="font-size: 15px" role="alert"><i class="bi-exclamation-triangle"></i> L\'adresse mail ou le mot de passe est/sont incorrect(s)</div>')
          })

    },
  }
}

</script>

<style scoped>

</style>