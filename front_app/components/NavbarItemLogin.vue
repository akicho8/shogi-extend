<template lang="pug">
b-navbar-item.has-text-weight-bold(v-if="!g_current_user" :href="login_url_build()" @click="sound_play('click')")
  | ログイン
</template>
