<template>
  <div id="nav">
    <!-- <router-link to="/"><i class="bi bi-box-arrow-left"></i> Exit</router-link>-->
    <button class="btn" @click="logOut"><i class="bi bi-box-arrow-left"></i> Exit</button>
  </div>

  <div class="container mt-4">
    <div class="card shadow">
      <div class="card-header"> Panel administrateur</div>
      <div class="card-body">
        <ul class="nav nav-pills nav-justified" style="padding-left: 20%;padding-right: 20%" id="myTab" role="tablist">
          <li class="nav-item" role="presentation">
            <button class="nav-link active" id="users-tab" data-bs-toggle="tab" data-bs-target="#users" type="button" role="tab"
                    aria-controls="users" aria-selected="true">Users
            </button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link" id="clock-tab" data-bs-toggle="tab" data-bs-target="#clock" type="button" role="tab"
                    aria-controls="clock" aria-selected="false">Clocks
            </button>
          </li>
          <li class="nav-item" role="presentation">
            <button class="nav-link" id="workingtimes-tab" data-bs-toggle="tab" data-bs-target="#workingtimes" type="button" role="tab"
                    aria-controls="workingtimes" aria-selected="false">Workingtimes
            </button>
          </li>
        </ul>
        <div class="tab-content" id="myTabContent">
          <div class="tab-pane fade show active" id="users" role="tabpanel" aria-labelledby="users-tab">
            <tableUsers class="mt-3"/>
          </div>
          <div class="tab-pane fade" id="clock" role="tabpanel" aria-labelledby="clock-tab">
            <tableClocks class="mt-3"/>
          </div>
          <div class="tab-pane fade" id="workingtimes" role="tabpanel" aria-labelledby="contact-tab">
            <tableWorktime class="mt-3" />
          </div>
        </div>
      </div>
    </div>
  </div>

</template>

<script>
import tableUsers from "../components/crud/tableUsers";
import tableClocks from "../components/crud/tableClocks";
import tableWorktime from "../components/crud/tableWorktime";
import axiosToken from "../axiosToken";

export default {
  name: 'Panel',
  components: {
    tableUsers,
    tableClocks,
    tableWorktime
  },
  methods: {
    logOut: function () {
      axiosToken.post('/session/delete')
          .then((res) => {
            console.log(res)
            if (res.status == 202) {
              window.$('#MsgErrHead').html('<div class="alert alert-success mt-3 text-center" style="font-size: 15px" role="alert"><i class="bi bi-check-circle"></i></i> ' + res.data + '</div>')
              setTimeout(() => {
                window.$('#MsgErrHead').empty()
              }, 3000)

              axiosToken.defaults.headers.common['Authorization'] = null
              this.$router.push({name: 'login'})
            }
          })
          .catch((err) => {
            console.log(err)
            this.$router.push({name: 'login'})
          })
    }
  }
}
</script>


<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 0px;
}
</style>
