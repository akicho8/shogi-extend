<template lang="pug">
.SbDebugGeneralMark.column.is-3
  .panel
    .panel-heading
      | 印
    a.panel-block(href="?xbody=cG9zaXRpb24gc2ZlbiBsK24xZzFnMW4rbC8xa3MycjErcjEvMXBwcHAxYnBwL3AyK2Irc3ArcDIvOS9QMVAxK1NQMVBQLzErUCtCUFAxUDIvMUJLMUdSMStSMS8rTCtOU0czTkwgYiBSMkIzRzRTNU4xMUw5OVByMmIzZzRzNW4xMWw5OXAgMQ") 確認用URL
  .panel.assert_var
    .panel-heading
      | [assert_var]
    .panel-block general_mark_color_index:{{SB.general_mark_color_index}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugGeneralMark",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../stylesheets/support"
.SbDebugGeneralMark
  __css_keep__: 0
</style>
