<template lang="pug">
b-button.ShowButton.is-small(v-bind="$attrs" v-on="$listeners" @click="click_handle")
  slot
</template>

<script>
export default {
  name: "ShowButton",
  methods: {
    click_handle() {
      // 詳細のコンポーネント側で記録するので不要
      // this.app_log("詳細")
    },
  },
}
</script>
