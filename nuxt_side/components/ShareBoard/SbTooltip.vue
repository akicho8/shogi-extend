<template>
<span class="tooltip-wrapper">
  <!-- ツールチップを表示させたい対象 -->
  <slot></slot>

  <!-- ツールチップ本体 -->
  <span class="tooltip-content">
    {{ content }}
  </span>
</span>
</template>

<script>
export default {
  name: "SbTooltip",
  props: {
    content: { type: String, required: true },
  },
}
</script>

<style scoped>
.tooltip-wrapper {
  position: relative;
  display: inline-block;
  cursor: help;

  .tooltip-content {
    /* 配置設定 */
    position: absolute;
    top: 125%;          /* 下側に配置 */
    left: 50%;
    transform: translateX(-50%);

    /* デザイン */
    background-color: #333;
    color: white;
    padding: 6px 10px;
    border-radius: 4px;
    font-size: 12px;
    white-space: nowrap;
    z-index: 100;

    /* 非表示状態 */
    opacity: 0;
    visibility: hidden;

    /* 消える時はすぐ（0秒） */
    transition: opacity 0.2s;
    transition-delay: 0s;
  }

  /* ホバーした時の挙動 */
  &:hover .tooltip-content {
    opacity: 1;
    visibility: visible;
    /* 表示される時だけ1秒待機 */
    transition-delay: 1s;
  }
}
</style>
