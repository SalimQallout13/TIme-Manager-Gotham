<template>
  <div id="user-container" class="container">
    <modalUsers v-bind:id="'modalUserAdd'"
                title="Ajouter un utilisateur"
                v-bind:func="addUser"
                v-bind:user_id="null"
                v-bind:apply="addUser"
                v-bind:add-modal="true"
                v-bind:inputRole="'selectRole'"
                v-bind:usrnameId="'usernameAdd'" v-bind:emailId="'emailAdd'" v-bind:pwd-id="'pwdAdd'"
                v-bind:btn-apply-id="'btnAdd'"
                btn-apply="Ajouter"/>

    <modalUsers v-for="user in users" :key="user.id" v-bind:id="'modalUserEdit'+user.id"
                title="Editer un utilisateur"
                v-bind:apply="editUser"
                v-bind:add-modal="false"
                v-bind:user_id="user.id"
                v-bind:usrnameVal="user.username" v-bind:emailVal="user.email"
                v-bind:usrnameId="'usernameEdit'+user.id" v-bind:emailId="'emailEdit'+user.id"
                v-bind:pwd-id="'pwdEdit'+user.id" v-bind:pwd-val="user.password"
                v-bind:btn-apply-id="'btnEdit'+user.id"
                btn-apply="Appliquer"/>

    <modalDel v-for="user in users" :key="user.id" v-bind:id="'modalUserDel'+user.id"
              title="Voulez-vous vraiment supprimer cette utilisateur ?"
              v-bind:apply="delUser"
              v-bind:row_id="user.id"
              v-bind:btn-apply-id="'btnDel'+user.id"
              btn-apply="Suprimmer"
    />


    <div class="card">
      <div class="card-title">
        <div class="row">
          <div class="col">
            <div class="d-flex mt-4" style="width: 60%;margin-left: 22%">
              <input class="form-control me-2" id="keyword" type="search" placeholder="N°Utilisateur"
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
              <th scope="col">Identifiant</th>
              <th scope="col">Email</th>
              <th scope="col">Mot de passe</th>
              <th scope="col">Role</th>
              <th scope="col" style="width: 9%">
                <button type="button" class="btn btn-sm" data-bs-toggle="modal"
                        data-bs-target="#modalUserAdd">
                  <img src="https://img.icons8.com/ios-glyphs/20/000000/add-user-male.png"/>
                </button>
              </th>
            </tr>
            </thead>

            <tbody>

            <tr v-for="user in users" :key="user.id">
              <th scope="row" v-text="user.id"></th>
              <td v-text="user.username"></td>
              <td v-text="user.email"></td>
              <td v-text="user.password"></td>
              <td v-if="user.role == false">Standard</td>
              <td v-if="user.role == true">Admin</td>

              <td id="userBtn" style="width: 6%" class="text-center">
                <b-button type="button" class="btn btn-sm"
                          data-bs-toggle="modal"
                          v-bind:data-bs-target="'#modalUserEdit'+user.id">
                  <img src="https://img.icons8.com/metro/16/000000/edit.png"/></b-button>
                <b-button type="button" class="btn btn-sm"
                          data-bs-toggle="modal"
                          v-bind:data-bs-target="'#modalUserDel'+user.id"><img
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
import modalUsers from "../modal/modalUsers";
import modalDel from "../modal/modalDel";
import axiosToken from "../../axiosToken";

export default {
  name: 'tableUsers',
  components: {modalUsers, modalDel},
  data() {
    return {
      users: []
    };
  },
  mounted() {
    if (axiosToken.defaults.headers.common['Authorization'] == null) {
      //console.log("token " + Login.data().tokenLogin())


      window.$('#MsgErrHead').html('<div class="alert alert-danger mt-3 text-center" style="font-size: 15px" role="alert"><i class="bi-exclamation-triangle"></i> Vous devez vous connecter !</div>')
      setTimeout(() => {
        window.$('#MsgErrHead').empty()
      }, 3000)
      //this.$router.push({name: 'login'})
    } else {
      axiosToken.get("/users/")
          .then((res) => {
            this.users = res.data.data;
            for (let i = 0; i < this.users.length; i++) {
              window.$('#userSelectedAdd').append('<option value="' + this.users[i].id + '">' + this.users[i].username + '</option>')
              window.$('#userSelectedAddWT').append('<option value="' + this.users[i].id + '">' + this.users[i].username + '</option>')
            }
          })
          .catch((err) => {
            console.log(err)
          })
    }

  },
  methods: {
    getByID: function () {
      let id = window.$('#keyword').val()
      if (id != null && id != '') {
        axiosToken.get("http://localhost:4000/api/users/" + id)
            .then((res) => {
              this.users = res.data;
            })
            .catch((err) => {
              console.log(err)
              window.$('#MsgErrHead').html('<div class="alert alert-danger mt-3 text-center" style="font-size: 15px" role="alert"><i class="bi-exclamation-triangle"></i> Utilisateur non trouvé</div>')
            })
      } else {
        window.$('#keyword').addClass('is-invalid')
        window.$('#MsgErrHead').html('<div class="alert alert-danger mt-3 text-center" style="font-size: 15px" role="alert"><i class="bi-exclamation-triangle"></i> Vous devez renseigner un n° utilisateur</div>')
        axiosToken.get("http://localhost:4000/api/users/")
            .then((res) => {
              this.users = res.data.data;
            })
            .catch((err) => {
              console.log(err)
            })
      }

      setTimeout(() => {
        window.$('#keyword').removeClass('is-invalid')
        window.$('#MsgErrHead').empty()
      }, 3000)

    },
    addUser: function () {
      if (window.$('#usernameAdd').val().trim() == '' || window.$('#usernameAdd').val().trim() == undefined) {
        window.$('#usernameAdd').addClass('is-invalid')
        window.$('#usernameAdd').after('<div class="invalid-feedback text-start">Vous devez renseigner ce champ</div>')
      } else {
        window.$('#usernameAdd').removeClass('is-invalid')
        window.$('#usernameAdd').remove('.invalid-feedback')
        if (window.$('#emailAdd').val().trim() == '' || window.$('#emailAdd').val().trim() == undefined) {
          window.$('#emailAdd').addClass('is-invalid')
          window.$('#emailAdd').after('<div class="invalid-feedback text-start">Vous devez renseigner ce champ</div>')
        } else {
          window.$('#emailAdd').removeClass('is-invalid')
          window.$('#emailAdd').remove('.invalid-feedback')
          if (window.$('#pwdAdd').val().trim() == '' || window.$('#pwdAdd').val().trim() == undefined) {
            window.$('#pwdAdd').addClass('is-invalid')
            window.$('#pwdAdd').after('<div class="invalid-feedback text-start">Vous devez renseigner ce champ</div>')
          } else {
            window.$('#pwdAdd').removeClass('is-invalid')
            window.$('#pwdAdd').remove('.invalid-feedback')
            axiosToken.post("http://localhost:4000/api/users/", {
              "username": window.$('#usernameAdd').val(),
              "email": window.$('#emailAdd').val(),
              "password": window.$('#pwdAdd').val(),
              "role": window.$('#selectRole').val()
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
    editUser: function (id) {
      if (window.$('#usernameEdit' + id).val().trim() == '' || window.$('#usernameEdit' + id).val().trim() == undefined) {
        window.$('#usernameEdit' + id).addClass('is-invalid')
        window.$('#usernameEdit' + id).after('<div class="invalid-feedback text-start">Vous devez renseigner ce champ</div>')
      } else {
        window.$('#usernameEdit' + id).removeClass('is-invalid')
        window.$('#usernameEdit' + id).remove('.invalid-feedback')
        if (window.$('#emailEdit' + id).val().trim() == '' || window.$('#emailEdit' + id).val().trim() == undefined) {
          window.$('#emailEdit' + id).addClass('is-invalid')
          window.$('#emailEdit' + id).after('<div class="invalid-feedback text-start">Vous devez renseigner ce champ</div>')
        } else {
          window.$('#emailEdit' + id).removeClass('is-invalid')
          window.$('#usernameEdit' + id).remove('.invalid-feedback')
          if (window.$('#pwdEdit' + id).val().trim() == '' || window.$('#pwdEdit' + id).val().trim() == undefined) {
            window.$('#pwdEdit' + id).addClass('is-invalid')
            window.$('#pwdEdit' + id).after('<div class="invalid-feedback text-start">Vous devez renseigner ce champ</div>')
          } else {
            window.$('#pwdEdit' + id).removeClass('is-invalid')
            window.$('#pwdEdit' + id).remove('.invalid-feedback')
            axiosToken.put("http://localhost:4000/api/users/" + id, {
              "username": window.$('#usernameEdit' + id).val(),
              "email": window.$('#emailEdit' + id).val(),
              "password": window.$('#pwdAdd').val()
            })
                .then((res) => {
                  //console.log(res)
                  if (res.status == 200) {
                    window.$('#MsgErrHead').html('<div class="alert alert-success mt-3 text-center" style="font-size: 15px" role="alert"><i class="bi-exclamation-triangle"></i> Modification reussi</div>')
                  } else {
                    window.$('#MsgErrHead').html('<div class="alert alert-danger mt-3 text-center" style="font-size: 15px" role="alert"><i class="bi-exclamation-triangle"></i> Modification échouée</div>')
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
    delUser: function (id) {
      axiosToken().delete("http://localhost:4000/api/users/" + id)
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
          })
          .catch((err) => {
            console.log(err)
            window.$('#MsgErrHead').html('<div class="alert alert-danger mt-3 text-center" style="font-size: 15px" role="alert"><i class="bi-exclamation-triangle"></i> Suppression échouée une ou plusieurs horaire de travail sont encore associées à utilisateur</div>')
            setTimeout(() => {
              window.$('#MsgErrHead').empty()
            }, 3000)
          })
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
