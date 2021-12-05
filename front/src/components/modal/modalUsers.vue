<template>
  <b-modal class="modal fade" v-bind:id="id" tabindex="-1" aria-labelledby="modalUsersLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="modalUsersLabel">{{ title }}</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="form-floating mb-3">
            <input type="text" class="form-control" v-bind:value="usrnameVal" v-bind:id="usrnameId"
                   placeholder="Identifiant" required>
            <label>Identifiant</label>
          </div>
          <div class="form-floating mb-3">
            <input type="email" class="form-control" v-bind:value="emailVal" v-bind:id="emailId"
                   placeholder="name@example.com" required>
            <label>Email</label>
          </div>
          <div class="form-floating mb-3">
            <input type="password" class="form-control" v-bind:value="pwdVal" v-bind:id="pwdId"
                   placeholder="Entrez un mot de passe" required>
            <label>Mot de passe</label>
          </div>
          <div v-if="addModal" class="form-floating">
            <select class="form-control" v-bind:id="inputRole">
              <option value="false">Standard</option>
              <option value="true">Administrateur</option>
            </select>
            <label>Choisir un role</label>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
          <button type="button" v-bind:id="btnApplyId" @click="apply(user_id)" class="btn btn-primary">{{ btnApply }}
          </button>
        </div>
      </div>
    </div>
  </b-modal>

</template>


<script>

export default {
  name: "modalUsers",
  props: {
    id: String,
    btnId: String,
    usrnameId: String,
    emailId: String,
    pwdId: String,
    pwdVal: String,
    usrnameVal: String,
    emailVal: String,
    apply: Function,
    title: String,
    btnApply: String,
    btnApplyId: String,
    user_id: String,
    addModal:Boolean,
    inputRole:String
  },
}
</script>

<style scoped>

</style>