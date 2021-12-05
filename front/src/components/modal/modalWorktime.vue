<template>
  <b-modal class="modal fade" v-bind:id="id" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title">{{ title }}</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div v-if="addModal" class="form-floating mb-3">
            <select class="form-control" v-bind:value="inputUserVal" v-bind:id="inputUser">
            </select>
            <label>Choisir un utilisateur</label>
          </div>
          <div class="row">
            <div class="col-6">
              <div class="form-floating mb-3">
                <input type="datetime-local" class="form-control" v-bind:value="hourDebVal" v-bind:id="hourDebId"
                       placeholder="Heure de pointage" required>
                <label>Début</label>
              </div>
            </div>
            <div class="col-6">
              <div class="form-floating mb-3">
                <input type="datetime-local" class="form-control" v-bind:value="hourFinVal" v-bind:id="hourFinId"
                       placeholder="Heure de pointage" required>
                <label>Fin</label>
              </div>
            </div>
          </div>


        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
          <button type="button" v-bind:id="btnApplyId" @click="apply(worktime_id)" class="btn btn-primary">{{
              btnApply
            }}
          </button>
        </div>
      </div>
    </div>
  </b-modal>

</template>


<script>

export default {
  name: "modalWorktime",
  props: {
    id: String,
    hourDebVal: String,
    hourDebId: String,
    hourFinVal: String,
    hourFinId: String,
    apply: Function,
    title: String,
    btnApply: String,
    btnApplyId: String,
    worktime_id: String,
    inputUser: String,
    inputUserVal: String,
    addModal: Boolean
  },
}
</script>

<style scoped>

</style>