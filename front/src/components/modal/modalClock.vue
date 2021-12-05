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
          <div class="form-floating mb-3">
            <input type="datetime-local" class="form-control" v-bind:value="hourVal" v-bind:id="hourId"
                   placeholder="Heure de pointage" required>
            <label>Heure de pointage</label>
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
          <button type="button" v-bind:id="btnApplyId" @click="apply(clock_id)" class="btn btn-primary">{{ btnApply }}
          </button>
        </div>
      </div>
    </div>
  </b-modal>

</template>


<script>

export default {
  name: "modalClock",
  props: {
    id: String,
    btnId: String,
    hourId: String,
    hourVal: String,
    apply: Function,
    title: String,
    btnApply: String,
    btnApplyId: String,
    clock_id: String,
    inputUser: String,
    inputUserVal: String,
    addModal:Boolean
  },
}
</script>

<style scoped>

</style>