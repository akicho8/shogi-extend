<template lang="pug">
b-button.DetailButton.is-small(v-bind="$attrs" v-on="$listeners" @click="click_handle")
  slot
</template>

<script>
export default {
  name: "DetailButton",
  methods: {
    click_handle() {
      this.ga_click("詳細")
    },
  },
}
</script>
