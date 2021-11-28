<template lang="html">
    <div class="home" v-if="account">
        <form v-if="type == 'user'" >
            <card title="Ajouter une bounty" :gradient="true">
                <input type="text" class="input-username" v-model="nameBounty" placeholder="Nom de la bounty" />
                <input type="text" class="input-username" v-model="describe" placeholder="Desription de la bounty" />
                <input type="text" class="input-username" v-model="reward" placeholder="Cout de la bounty" />
                <button class="button" @click="addBounty">
                    Ajouter
                </button>
            </card>
        </form>
        <spacer :size="24" />
        <div v-for="bounty in account.bounties" :key="bounty.id" > 
            <card :title=bounty.nom :subtitle="`Reward : ${bounty.reward} \t\t Status : ${bounty.closed ? 'Closed' : 'Published'}`">
            <div class="explanations">
                {{ bounty.description }}
                <button @click="deleteBounty(bounty.id)">Delete Bounty</button>
                <button v-if="!bounty.closed" @click="closeBounty(bounty.id)">Close Bounty</button>
                <button v-else @click="publishBounty(bounty.id)">Publish bounty</button>
            </div>
            </card>
            <spacer :size="24" />
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
    const id_projet = this.$route.params.id
    const account = null
    const nameBounty = ''
    const describe = ''
    const reward = null
    this.updateAccount()
    return { id_projet, account, reward, nameBounty, describe }
  },
  methods: {
    async addBounty(e: Event) {
      e.preventDefault()
      const { contract, type, reward, id_projet, nameBounty, describe } = this
      if (type == 'user') {
        await contract.methods
          .createBounty(Number(id_projet), nameBounty, describe, Number(reward))
          .send()
        await this.updateAccount()
      }
      this.nameBounty = ''
      this.describe = ''
      this.reward = null
    },
    async updateAccount() {
      const { address, contract, type } = this
      if (type == 'user') {
        let account = await contract.methods.user(address).call()
        const bounties = await contract.methods
          .getBounties(Number(this.id_projet))
          .call()
        account = { ...account, bounties }
        this.account = account
        console.log(this.account)
      }
      if (type == 'company')
        this.account = await contract.methods.company(address).call()
    },
    async deleteBounty(id_bounty: string) {
      const { contract, type, id_projet } = this
      if (type == 'user') {
        console.log('Projet ' + id_projet + 'Delete ' + id_bounty)
        console.log(
          await contract.methods
            .removeBounty(Number(id_projet), Number(id_bounty))
            .send()
        )
        await this.updateAccount()
      }
    },
    async closeBounty(id_bounty: string) {
      const { contract, type, id_projet } = this
      if (type == 'user') {
        console.log('Close ' + id_bounty)
        console.log(
          await contract.methods
            .closeBounty(Number(id_projet), Number(id_bounty))
            .send()
        )
        await this.updateAccount()
      }
    },
    async publishBounty(id_bounty: string) {
      const { contract, type, id_projet } = this
      if (type == 'user') {
        console.log('publish ' + id_bounty)
        console.log(
          await contract.methods
            .openBounty(Number(id_projet), Number(id_bounty))
            .send()
        )
        await this.updateAccount()
      }
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
.test {
  background-color: red;
}

.home {
  margin: 24px;
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

.explanations {
  padding: 12px;
}

.button {
  background: transparent;
  color: white;
  border: none;
  appearance: none;
  cursor: pointer;
  font-family: inherit;
  font-size: 1.2rem;
  font-weight: inherit;
  padding: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 100%;
}
</style>
