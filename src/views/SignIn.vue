<template>
  <div class="home-wrapper">
    <card
      v-if="!address"
      title="It looks like you're not connected."
      subtitle="Please connect to use the app."
      :blue="true"
    >
      <collective-button :transparent="true" @click="connectUser">
        User
      </collective-button>
      <collective-button :transparent="true" @click="connectCompany">
        Company
      </collective-button>
    </card>
    <card title="You're connected!" subtitle="Hooray" :blue="true" v-else>
      <collective-button :transparent="true" @click="goToAccount">
        Go to account
      </collective-button>
    </card>
  </div>
</template>

<script lang="ts">
import { defineComponent, computed } from 'vue'
import { useStore } from 'vuex'
import Card from '@/components/Card.vue'
import CollectiveButton from '@/components/CollectiveButton.vue'

export default defineComponent({
  name: 'SignIn',
  components: { Card, CollectiveButton },
  setup() {
    const store = useStore()
    const address = computed(() => store.state.account.address)
    const connectUser = () => store.dispatch('ethereumConnectUser')
    const connectCompany = () => store.dispatch('ethereumConnectCompany')

    return { address, connectUser, connectCompany }
  },
  methods: {
    goToAccount() {
      this.$router.push({ name: 'Account' })
    },
  },
})
</script>

<style lang="css" scoped>
.home-wrapper {
  margin: auto 24px auto 24px;
}

.home {
  display: grid;
  align-items: center;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  grid-gap: 24px;
}

.card-body {
  padding: 12px;
  display: block;
  font-family: inherit;
  font-size: 1.2rem;
  font-weight: inherit;
  text-align: center;
  color: inherit;
  text-decoration: none;
  font-variant: small-caps;
}
</style>
