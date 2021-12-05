<template>
  <b-modal class="modal fade" v-bind:id="id" tabindex="-1" aria-labelledby="modalUsersLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="modalUsersLabel">{{ title }}</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
          <button type="button" v-bind:id="btnApplyId" @click="apply(row_id)" class="btn btn-danger">{{ btnApply }}
          </button>
        </div>
      </div>
    </div>
  </b-modal>

</template>


<script>

export default {
  name: "modalDel",
  props: {
    id: String,
    btnId: String,
    apply: Function,
    title: String,
    btnApply: String,
    btnApplyId: String,
    row_id: String
  },
}
</script>

<style scoped>

</style>