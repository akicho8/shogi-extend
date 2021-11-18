<template lang="pug">
.SwarsUserShowHeadMedal(v-if="base.info.medal_list.length >= 1")
  .one_element(v-for="e in base.info.medal_list" @click="base.medal_click_handle(e)" :class="{'is-clickable': e.message}")
    template(v-if="false")
    b-tag( v-else-if="e.method === 'tag'" :type="e.type" rounded) {{e.name}}
    .raw(  v-else-if="e.method === 'raw'" v-xemoji :key="e.name") {{e.name}}
    b-icon(v-else-if="e.method === 'icon'" :icon="e.name" :type="e.type" size="is-small")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "SwarsUserShowHeadMedal",
  mixins: [support_child],
}
</script>

<style lang="sass">
.SwarsUserShowHeadMedal
  margin-top: 0.1rem

  display: flex
  justify-content: center
  align-items: center

  .one_element
    margin: auto 0.1rem
    .raw
      position: relative
      bottom: -0.2rem     // 絵文字は大きいので若干下げる
    .icon
      position: relative
      bottom: -0.1rem
</style>
