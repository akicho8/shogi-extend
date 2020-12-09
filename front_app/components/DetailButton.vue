<template lang="pug">
b-button.DetailButton.is-small(v-bind="$attrs" v-on="$listeners" @click="click_handle")
  slot
</template>

<script>
export default {
  name: "DetailButton",
  methods: {
    click_handle() {
      // 詳細のコンポーネント側で記録するので不要
      // this.ga_click("詳細")
    },
  },
}
</script>
