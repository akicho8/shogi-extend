<template lang="pug">
QuickScriptView(qs_group_key="chore" qs_page_key="documentation" :qs_override_params="{md_key: 'video_new'}")
</template>

<script>
export default {
  name: "PagesVideoHelp",
  computed: {
    meta() {
      return {
        title: ["使い方", "動画作成"],
        description: "棋譜を動画に変換します",
        og_image_key: "video-new",
      }
    }
  },
}
</script>

<style lang="sass">
</style>
