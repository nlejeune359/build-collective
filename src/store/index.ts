import { createStore } from 'vuex'
import * as Ethereum from '../services/ethereum'

export default createStore({
  state: {
    contract: null,
    account: {
      address: null,
      balance: 0,
      type: null,
      username: ''
    },
  },
  mutations: {
    updateEthereum(state, { address, contract, balance, type }) {
      state.account.address = address
      state.account.balance = balance
      state.account.type = type
      state.contract = contract
    },
  },
  actions: {
    async ethereumConnectUser(context) {
      const response = await Ethereum.connect()
      if (response) {
        const { address, contract, balance } = response
        context.commit('updateEthereum', {
          address,
          contract,
          balance,
          type: "user"
        })
      }
    },
    async ethereumConnectCompany(context) {
      const response = await Ethereum.connect()
      if (response) {
        const { address, contract, balance } = response
        context.commit('updateEthereum', {
          address,
          contract,
          balance,
          type: "company"
        })
      }
    },
  },
  modules: {},
})
