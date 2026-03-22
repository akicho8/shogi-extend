// ・合わせて ../components/models/global_var_accessor.js でメソッドを公開する
// ・グローバル変数の基本的な定義だけにしてクラスのようには書くな

import { VolumeCop } from "@/components/models/volume_cop.js"

export const state = () => ({
  g_var1: 0,
  g_volume_talk_user_scale:   VolumeCop.CONFIG.user_scale_default,
  g_volume_common_user_scale: VolumeCop.CONFIG.user_scale_default,
  g_toast_key: null,
  g_modal_instance_count: 0,
})

export const getters = {
  g_var1_get(state)                 { return state.g_var1                     },
  g_volume_talk_user_scale(state)   { return state.g_volume_talk_user_scale   },
  g_volume_common_user_scale(state) { return state.g_volume_common_user_scale },
  g_toast_key(state)                { return state.g_toast_key                },
  g_modal_instance_count(state)       { return state.g_modal_instance_count       },
}

export const mutations = {
  __g_var1_set(state, payload)                     { state.g_var1                     = payload },
  __g_volume_talk_user_scale_set(state, payload)   { state.g_volume_talk_user_scale   = payload },
  __g_volume_common_user_scale_set(state, payload) { state.g_volume_common_user_scale = payload },
  __g_toast_key_set(state, payload)                { state.g_toast_key                = payload },
  __g_modal_instance_count_set(state, payload)       { state.g_modal_instance_count       = payload },
}

export const actions = {
}
