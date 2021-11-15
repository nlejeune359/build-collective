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
        :title="`[${type}] ${account.username}`"
        :subtitle="`${balance} Ξ\t\t${account.balance} Tokens`"
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
    </div>

    <div class="bord" v-if="type == 'company'">
      <h2>List of issues</h2>
      <div v-for="issue in dataCompany" :key="issue.id"> 
        <card :title=issue.title>
          <div class="explanations">
            {{ issue.content }}
            <br>
            <br><a href="$">{{ issue.contributor }}</a>
          </div>
        </card>
        <spacer :size="24" />
      </div>
    </div>
    <div class="bord" v-else>
      <h2>Project comtributed</h2>
      <div v-for="issue in dataUser" :key="issue.id"> 
        <card :title=issue.company>
          <div class="explanations">
            {{ issue.content }}
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
    const dataCompany = [
      {
        id: 0,
        title: 'Issue 1',
        content:
          'Voluptate cillum velit irure laboris elit est elit non adipisicing dolore. Non exercitation dolor consectetur labore voluptate eu veniam duis veniam. Fugiat labore ex eiusmod excepteur et veniam. Ea aliquip duis labore commodo aute minim amet. Excepteur consequat sunt sit est ipsum nostrud magna mollit in duis consectetur amet. Sint id voluptate reprehenderit id quis occaecat commodo excepteur exercitation excepteur elit exercitation.',
        contributor: 'user@123',
      },
      {
        id: 1,
        title: 'Issue 2',
        content:
          'Excepteur magna irure eiusmod laboris nulla duis ullamco eu ea officia pariatur. Reprehenderit dolore exercitation exercitation dolore. Ullamco anim dolor incididunt cupidatat tempor ipsum proident aute amet laboris amet Lorem pariatur aliqua. Fugiat magna exercitation minim ipsum adipisicing pariatur consequat adipisicing cillum. Aliquip laborum ea sint nulla duis. Non cupidatat esse minim eiusmod cupidatat. Enim qui deserunt incididunt incididunt ullamco voluptate in officia nostrud dolor.',
        contributor: 'user@456',
      },
      {
        id: 2,
        title: 'Issue 3',
        content:
          'Magna irure culpa commodo nulla excepteur aute Lorem enim exercitation qui amet. Velit duis ad id cillum eiusmod consequat dolore velit ea sunt nisi in. In non pariatur officia laboris. Occaecat pariatur eu velit irure.',
        contributor: 'user@007',
      },
    ]

    const dataUser = [
      {
        id: 0,
        company: "Company 1",
        content:
          'Voluptate cillum velit irure laboris elit est elit non adipisicing dolore. Non exercitation dolor consectetur labore voluptate eu veniam duis veniam. Fugiat labore ex eiusmod excepteur et veniam. Ea aliquip duis labore commodo aute minim amet. Excepteur consequat sunt sit est ipsum nostrud magna mollit in duis consectetur amet. Sint id voluptate reprehenderit id quis occaecat commodo excepteur exercitation excepteur elit exercitation.',
      },
      {
        id: 1,
        title: 'Company 1',
        content:
          'Excepteur magna irure eiusmod laboris nulla duis ullamco eu ea officia pariatur. Reprehenderit dolore exercitation exercitation dolore. Ullamco anim dolor incididunt cupidatat tempor ipsum proident aute amet laboris amet Lorem pariatur aliqua. Fugiat magna exercitation minim ipsum adipisicing pariatur consequat adipisicing cillum. Aliquip laborum ea sint nulla duis. Non cupidatat esse minim eiusmod cupidatat. Enim qui deserunt incididunt incididunt ullamco voluptate in officia nostrud dolor.',
      },
    ]
    return { account, username, dataCompany, dataUser }
  },
  methods: {
    async updateAccount() {
      const { address, contract } = this
      this.account = await contract.methods.user(address).call()
    },
    async signUp() {
      const { contract, username } = this
      const name = username.trim().replace(/ /g, '_')
      await contract.methods.signUp(name).send()
      await this.updateAccount()
      this.username = ''
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
  width: 300px;
  margin-right: 24px;
}
.home {
  padding: 24px;
  flex: 1;
  display: flex;
  flex-direction: row;
}

.card {
  color: aliceblue;
}

.bord {
  flex: 1;
  display: flex;
  flex-direction: column;
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
</style>
