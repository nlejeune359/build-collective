<template lang="html">
  <div class="home" v-if="!account">
    <form @submit.prevent="signUp">
      <card
        title="Enter your username here"
        subtitle="Type directly in the input and hit enter. All spaces will be converted to _"
      >
        <input
          type="text"
          class="input-username"
          v-model="username"
          placeholder="Type your username here"
        />
      </card>
    </form>
  </div>
  <div class="home" v-if="account">
    <div class="card-home-wrapper">
      <card
        :title="account.username"
        :subtitle="`[${type}] ${balance} Ξ ${account.balance} Tokens`"
        :gradient="true"
      >
        <div class="explanations">
          This data has been fetched from the blockchain. You started by
          connecting MetaMask, and you fetched your data by reading the
          blockchain. Try to modify the code to see what's happening!
        </div>
        <div class="explanations">
          On your account on the contract, you have
          {{ account.balance }} tokens. If you click
          <button class="button-link" @click="addTokens">here</button>, you can
          add some token to your account. Just give it a try! And think to put
          an eye on Ganache!
        </div>
      </card>
      <spacer :size="24" />
      <form @submit.prevent="addProjet" v-if="type == 'user'">
        <card title="Ajouter un projet" :gradient="true">
          <input type="text" class="input-username" v-model="nameProjet" placeholder="Nom du projet" />
        </card>
      </form>
    </div>
    <div class="bord">
      <h2>List of issues</h2>
      <div v-for="issue in account.projects" :key="issue.id"> 
        <card :title=issue.name subtitle= "Name of project">
          <div class="explanations">
              Content of issue
              <button @click="deleteProject(issue.id)">Delete</button>
          </div>
        </card>
        <spacer :size="24" />
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'
import Spacer from '@/components/Spacer.vue'

export default defineComponent({
  components: { Card, Spacer },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const balance = computed(() => store.state.account.balance)
    const type = computed(() => store.state.account.type)
    const contract = computed(() => store.state.contract)

    return { address, contract, balance, type }
  },
  data() {
    const account = null
    const username = ''
    const nameProjet = ''
    this.updateAccount()
    return { account, username, nameProjet }
  },
  methods: {
    async updateAccount() {
      const { address, contract, type } = this
      if (type == 'user') {
        let account = await contract.methods.user(address).call()
        const projects = await contract.methods.getProjects().call()
        account = { ...account, projects }
        this.account = account
      }

      if (type == 'company')
        this.account = await contract.methods.company(address).call()

      console.log(this.account)
    },
    async signUp() {
      const { contract, username, type } = this
      const name = username.trim().replace(/ /g, '_')
      if (type == 'user') await contract.methods.signUp(name).send()
      if (type == 'company') await contract.methods.signUpCompany(name).send()
      await this.updateAccount()
      this.username = ''
    },
    async addProjet() {
      const { contract, type, nameProjet } = this
      const name = nameProjet.trim().replace(/ /g, '_')
      if (type == 'user') {
        await contract.methods.createProject(name).send()
        await this.updateAccount()
        this.nameProjet = ''
      }
    },
    async deleteProject(id: string) {
      const { contract, type } = this
      if (type == 'user') {
        console.log('Delete ' + id)
        console.log(await contract.methods.removeProject(parseInt(id)).call())
        await this.updateAccount()
      }
    },
    async addTokens() {
      const { contract } = this
      await contract.methods.addBalance(200).send()
      await this.updateAccount()
    },
  },
  async mounted() {
    const { address, contract } = this
    const account = await contract.methods.user(address).call()
    if (account.registered) this.account = account
  },
})
</script>

<style lang="css" scoped>
.card-home-wrapper {
  width: 400px;
  margin-right: 24px;
}

.home {
  padding: 24px;
  flex: 1;
  display: flex;
  flex-direction: row;
}

.explanations {
  padding: 12px;
}

.button-link {
  display: inline;
  appearance: none;
  border: none;
  background: none;
  color: inherit;
  text-decoration: underline;
  font-family: inherit;
  font-size: inherit;
  font-weight: inherit;
  padding: 0;
  margin: 0;
  cursor: pointer;
}

.input-username {
  background: transparent;
  border: none;
  padding: 12px;
  outline: none;
  width: 100%;
  color: white;
  font-family: inherit;
  font-size: 1.3rem;
}

.card {
  color: aliceblue;
}

.bord {
  flex: 1;
  display: flex;
  flex-direction: column;
}
</style>
