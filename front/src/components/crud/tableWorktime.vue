<template>
  <div id="worktime-container" class="container">
    <modal-worktime v-bind:id="'modalAddWorktime'"
                    title="Créer un temps de travail"
                    v-bind:inputUser="'userSelectedAddWT'"
                    v-bind:worktime_id="null"
                    v-bind:apply="addWorktime"
                    v-bind:add-modal="true"
                    v-bind:hour-deb-id="'hourDebAddWorktime'"
                    v-bind:hour-fin-id="'hourFinAddWorktime'"
                    v-bind:btn-apply-id="'btnAddWT'"
                    btn-apply="Ajouter"/>

    <modal-worktime v-for="worktime in worktimes" :key="worktime.id" v-bind:id="'modalEditWorktime'+worktime.id"
                    title="Modifier un temps de travail"
                    v-bind:inputUser="'userSelectedEditWT'+worktime.id"
                    v-bind:worktime_id="worktime.id"
                    v-bind:apply="editWorktime"
                    v-bind:add-modal="false"
                    v-bind:hour-deb-id="'hourDebEditWorktime'+worktime.id"
                    v-bind:hour-fin-id="'hourFinEditWorktime'+worktime.id"
                    v-bind:hour-deb-val="worktime.start"
                    v-bind:hour-fin-val="worktime.end"
                    v-bind:btn-apply-id="'btnEditWT'+worktime.id"
                    btn-apply="Appliquer"/>

    <modal-del v-for="worktime in worktimes" :key="worktime.id" v-bind:id="'modalDelWorktime'+worktime.id"
               title="Voulez-vous vraiment supprimer ce temps de travail ?"
               v-bind:row_id="worktime.id"
               v-bind:apply="delWorktime"
               v-bind:btn-apply-id="'btnDel'+worktime.id"
               btn-apply="Supprimer"
    />

    <div class="card">
      <div class="card-title">
        <div class="row">
          <div class="col">
            <div class="d-flex mt-4" style="width: 60%;margin-left: 22%">
              <input class="form-control me-2" id="keywordWorktime" type="search" placeholder="Entrez un username"
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
              <th scope="col">Début</th>
              <th scope="col">Fin</th>
              <th scope="col" style="width: 9%">
                <button type="button" class="btn btn-sm" data-bs-toggle="modal"
                        data-bs-target="#modalAddWorktime">
                  <img src="https://img.icons8.com/ios-filled/20/000000/add-time.png"/>
                </button>
              </th>
            </tr>
            </thead>

            <tbody>

            <tr v-for="worktime in worktimes" :key="worktime.id">
              <th scope="row" v-text="worktime.id"></th>
              <td v-text="worktime.start.split('T')[0] + ' ' + worktime.start.split('T')[1]"></td>
              <td v-text="worktime.end.split('T')[0] + ' ' + worktime.end.split('T')[1]"></td>
              <td id="worktimeBtn" style="width: 6%" class="text-center">
                <b-button type="button" class="btn btn-sm"
                          data-bs-toggle="modal"
                          v-bind:data-bs-target="'#modalEditWorktime'+worktime.id">
                  <img src="https://img.icons8.com/metro/16/000000/edit.png"/></b-button>
                <b-button type="button" class="btn btn-sm"
                          data-bs-toggle="modal"
                          v-bind:data-bs-target="'#modalDelWorktime'+ worktime.id"><img
                    src="https://img.icons8.com/windows/20/000000/delete.png"/></b-button>
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


import ModalWorktime from "../modal/modalWorktime";
import ModalDel from "../modal/modalDel";
import axiosToken from "../../axiosToken";

export default {
  name: 'tableWorktime',
  components: {ModalDel, ModalWorktime},
  data() {
    return {
      worktimes: []
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

      axiosToken.get("http://localhost:4000/api/workingtimes/")
          .then((res) => {
            this.worktimes = res.data.data;
          })
          .catch((err) => {
            console.log(err)
          })
    }
  },
  methods: {
    getByID: function () {
      let username = window.$('#keywordWorktime').val()
      if (username != null && username != '') {
        axiosToken.get("http://localhost:4000/api/workingtimes/search?username=" + username)
            .then((res) => {
              console.log(res)
              if (res.data.data.length > 0) {
                this.worktimes = res.data.data;
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
        axiosToken.get("http://localhost:4000/api/workingtimes/")
            .then((res) => {
              this.worktimes = res.data.data;
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
    addWorktime: function () {
      // console.log(window.$('#userSelectedAddWT').val(), window.$('#hourDebAddWorktime').val(), window.$('#hourFinAddWorktime').val())
      if (window.$('#userSelectedAddWT').val().trim() == '' || window.$('#userSelectedAddWT').val().trim() == undefined) {
        window.$('#userSelectedAddWT').addClass('is-invalid')
        window.$('#userSelectedAddWT').after('<div class="invalid-feedback text-start">Vous devez renseigner ce champ</div>')
      } else {
        window.$('#userSelectedAddWT').removeClass('is-invalid')
        window.$('#userSelectedAddWT').remove('.invalid-feedback')
        if (window.$('#hourDebAddWorktime').val().trim() == '' || window.$('#hourDebAddWorktime').val().trim() == undefined) {
          window.$('#hourDebAddWorktime').addClass('is-invalid')
          window.$('#hourDebAddWorktime').after('<div class="invalid-feedback text-start">Vous devez renseigner ce champ</div>')
        } else {
          window.$('#hourDebAddWorktime').removeClass('is-invalid')
          window.$('#hourDebAddWorktime').remove('.invalid-feedback')
          if (window.$('#hourFinAddWorktime').val().trim() == '' || window.$('#hourFinAddWorktime').val().trim() == undefined) {
            window.$('#hourFinAddWorktime').addClass('is-invalid')
            window.$('#hourFinAddWorktime').after('<div class="invalid-feedback text-start">Vous devez renseigner ce champ</div>')
          } else {
            window.$('#hourFinAddWorktime').removeClass('is-invalid')
            window.$('#hourFinAddWorktime').remove('.invalid-feedback')
            axiosToken.post("http://localhost:4000/api/workingtimes/" + window.$('#userSelectedAddWT').val(), {
              "start": window.$('#hourDebAddWorktime').val(),
              "end": window.$('#hourFinAddWorktime').val()
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
      }
    },
    editWorktime: function (id) {
      // console.log(window.$('#userSelectedEditWT').val(), window.$('#hourDebEditWorktime').val(), window.$('#hourFinEditWorktime').val())
      if (window.$('#hourDebEditWorktime' + id).val().trim() == '' || window.$('#hourDebEditWorktime' + id).val().trim() == undefined) {
        window.$('#hourDebEditWorktime' + id).addClass('is-invalid')
        window.$('#hourDebEditWorktime' + id).after('<div class="invalid-feedback text-start">Vous devez renseigner ce champ</div>')
      } else {
        window.$('#hourDebEditWorktime' + id).removeClass('is-invalid')
        window.$('#hourDebEditWorktime' + id).remove('.invalid-feedback')
        if (window.$('#hourFinEditWorktime' + id).val().trim() == '' || window.$('#hourFinEditWorktime' + id).val().trim() == undefined) {
          window.$('#hourFinEditWorktime' + id).addClass('is-invalid')
          window.$('#hourFinEditWorktime' + id).after('<div class="invalid-feedback text-start">Vous devez renseigner ce champ</div>')
        } else {
          window.$('#hourFinEditWorktime' + id).removeClass('is-invalid')
          window.$('#hourFinEditWorktime' + id).remove('.invalid-feedback')
          axiosToken.put("http://localhost:4000/api/workingtimes/" + id, {
            "start": window.$('#hourDebEditWorktime' + id).val(),
            "end": window.$('#hourFinEditWorktime' + id).val()
          })
              .then((res) => {
                console.log(res)

                if (res.status == 200) {
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
    delWorktime: function (id) {
      axiosToken.delete("http://localhost:4000/api/workingtimes/" + id)
          .then((res) => {
            //console.log(res)
            if (res.status == 204) {
              window.$('#MsgErrHead').html('<div class="alert alert-success mt-3 text-center" style="font-size: 15px" role="alert"><i class="bi-exclamation-triangle"></i> Suppression reussi</div>')
            } else {
              window.$('#MsgErrHead').html('<div class="alert alert-danger mt-3 text-center" style="font-size: 15px" role="alert"><i class="bi-exclamation-triangle"></i> Suppression échouée</div>')
            }
            setTimeout(() => {
              window.$('#MsgErrHead').empty()
              location.reload()
            }, 3000)
          });
    }

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
