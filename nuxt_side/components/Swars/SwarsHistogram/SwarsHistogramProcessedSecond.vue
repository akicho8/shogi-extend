<template lang="pug">
.columns.is-vcentered.is-multiline.xform_block
  .column
    nav.level.is-mobile
      .level-item.has-text-centered
        div
          .heading 実行時間(秒)
          .title {{$gs.number_floor(xi.processed_second, 3)}}
</template>

<script>
export default {
  name: "SwarsHistogramProcessedSecond",
  props: {
    xi: { type: Object, required: true },
  },
}
</script>
