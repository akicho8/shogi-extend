<template lang="pug">
MainSection.WkbkBookShowAccessBlock
 .container.is-fluid
   .columns
    .column
      .hero.is-medium.is-dark
        .hero-body.has-text-centered
          p.title
            | 非公開問題
          p.subtitle.mt-5
            | この問題を見れるのは作成者本人だけです
          b-button.mt-1(@click="sns_login_modal_handle" type="is-primary" ) ログイン
      .buttons.mt-5.mb-0.has-addons.is-centered
        b-button.mb-0.is-outlined(@click="base.skip_handle" type="is-primary") SKIP
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowAccessBlock",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
MainSection.section.WkbkBookShowAccessBlock
  +touch
    padding: 1.5rem
  +desktop
    padding: 1.5rem 0
</style>
