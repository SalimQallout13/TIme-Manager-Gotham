<template>
  <div id="clock-container" class="container">
    <modal-clock v-bind:id="'modalAddClock'"
                 title="Ajouter un pointage"
                 v-bind:inputUser="'userSelectedAdd'"
                 v-bind:clock_id="null"
                 v-bind:apply="addClock"
                 v-bind:add-modal="true"
                 v-bind:hourId="'hourAddClock'" v-bind:btn-apply-id="'btnAddClock'"
                 btn-apply="Ajouter"/>

    <modal-clock v-for="clock in clocks" :key="clock.id" v-bind:id="'modalEditClock'+clock.id"
                 title="Modifier un pointage"
                 v-bind:inputUser="'userSelectedEdit'+clock.id"
                 v-bind:clock_id="null"
                 v-bind:apply="addClock"
                 v-bind:add-modal="false"
                 v-bind:input-user-val="+clock.id"
                 v-bind:hour-val="clock.time"
                 v-bind:hourId="'hourEditClock'+clock.id" v-bind:btn-apply-id="'btnEditClock'"
                 btn-apply="Appliquer"/>


    <div class="card">
      <div class="card-title">
        <div class="row">
          <div class="col">
            <div class="d-flex mt-4" style="width: 60%;margin-left: 22%">
              <input class="form-control me-2" id="keywordClock" type="search" placeholder="Entrez un username"
                     aria-label="Rechercher">
              <button class="btn btn-outline-primary" v-on:click="getByID">Rechercher</button>
            </div>
          </div>
        </div>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table class="table text-top table-bordered table-striped table-hover">
            <thead>
            <tr>
              <th scope="col">#</th>
              <th scope="col">status</th>
              <th scope="col">time</th>
              <th scope="col" style="width: 9%">
                <button type="button" class="btn btn-sm" data-bs-toggle="modal"
                        data-bs-target="#modalAddClock">
                  <img src="https://img.icons8.com/material-rounded/24/000000/clock-add.png"/>
                </button>
              </th>
            </tr>
            </thead>

            <tbody>

            <tr v-for="clock in clocks" :key="clock.id">
              <th scope="row" v-text="clock.id"></th>
              <td v-if="clock.status == true"> Vrai</td>
              <td v-if="clock.status == false"> Vrai</td>
              <td v-text="clock.time.split('T')[0] + ' ' + clock.time.split('T')[1]"></td>
              <td id="clockBtn" style="width: 6%" class="text-center">
                <button type="button" class="btn btn-sm"
                        data-bs-toggle="modal"
                        v-bind:data-bs-target="'#modalEditClock'+clock.id">
                  <img src="https://img.icons8.com/metro/16/000000/edit.png"/></button>
              </td>
            </tr>
            </tbody>


          </table>
        </div>

      </div>
    </div>
  </div>


</template>


<script>


import ModalClock from "../modal/modalClock";
import axiosToken from "../../axiosToken";

export default {
  name: 'tableClocks',
  components: {ModalClock},
  data() {
    return {
      clocks: []
    };
  },
  mounted() {
    if (axiosToken.defaults.headers.common['Authorization'] == null) {
      window.$('#MsgErrHead').html('<div class="alert alert-danger mt-3 text-center" style="font-size: 15px" role="alert"><i class="bi-exclamation-triangle"></i> Vous devez vous connecter !</div>')
      setTimeout(() => {
        window.$('#MsgErrHead').empty()
      }, 3000)
      this.$router.push({name: 'login'})
    } else {

      axiosToken.get("http://localhost:4000/api/clocks/")
          .then((res) => {
            this.clocks = res.data.data;
          })
          .catch((err) => {
            console.log(err)
          })
    }
  },
  methods: {
    getByID: function () {
      let username = window.$('#keywordClock').val()
      if (username != null && username != '') {
        axiosToken.get("http://localhost:4000/api/clocks/search?username=" + username)
            .then((res) => {
              console.log(res)
              if (res.data.data.length > 0) {
                this.clocks = res.data.data;
              } else {
                window.$('#MsgErrHead').html('<div class="alert alert-danger mt-3 text-center" style="font-size: 15px" role="alert"><i class="bi-exclamation-triangle"></i> Utilisateur non trouvé</div>')
              }
            })
            .catch((err) => {
              console.log(err)
            })
      } else {
        window.$('#keyword').addClass('is-invalid')
        window.$('#MsgErrHead').html('<div class="alert alert-danger mt-3 text-center" style="font-size: 15px" role="alert"><i class="bi-exclamation-triangle"></i> Vous devez renseigner un username</div>')
        axiosToken.get("http://localhost:4000/api/clocks/")
            .then((res) => {
              this.clocks = res.data.data;
            })
            .catch((err) => {
              console.log(err)
            })
      }

      setTimeout(() => {
        window.$('#keyword').removeClass('is-invalid')
        window.$('#MsgErrHead').empty()
      }, 4000)

    },
    addClock: function () {
      if (window.$('#userSelectedAdd').val().trim() == '' || window.$('#userSelectedAdd').val().trim() == undefined) {
        window.$('#userSelectedAdd').addClass('is-invalid')
        window.$('#userSelectedAdd').after('<div class="invalid-feedback text-start">Vous devez renseigner ce champ</div>')
      } else {
        window.$('#userSelectedAdd').removeClass('is-invalid')
        window.$('#userSelectedAdd').remove('.invalid-feedback')
        if (window.$('#hourAddClock').val().trim() == '' || window.$('#hourAddClock').val().trim() == undefined) {
          window.$('#hourAddClock').addClass('is-invalid')
          window.$('#hourAddClock').after('<div class="invalid-feedback text-start">Vous devez renseigner ce champ</div>')
        } else {
          window.$('#hourAddClock').removeClass('is-invalid')
          window.$('#userSelectedAdd').remove('.invalid-feedback')
          axiosToken.post("http://localhost:4000/api/clocks/" + window.$('#userSelectedAdd').val(), {
            "time": window.$('#hourAddClock').val()
          })
              .then((res) => {
                console.log(res)

                if (res.status == 201) {
                  window.$('#MsgErrHead').html('<div class="alert alert-success mt-3 text-center" style="font-size: 15px" role="alert"><i class="bi-exclamation-triangle"></i> Ajout reussi</div>')
                } else {
                  window.$('#MsgErrHead').html('<div class="alert alert-danger mt-3 text-center" style="font-size: 15px" role="alert"><i class="bi-exclamation-triangle"></i> Ajout failed</div>')
                }
                setTimeout(() => {
                  window.$('#MsgErrHead').empty()
                  location.reload()
                }, 3000)
              });
        }
      }
    },
  }

}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #42b983;
}
</style>
