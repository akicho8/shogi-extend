# 「Not found. Authentication passthru.」対策
# https://zenn.dev/koshilife/articles/b71f8cfcb50e33

# フロント側 ../../nuxt_side/components/SnsLoginContainer.vue から POST できないため GET を許可している
OmniAuth.config.allowed_request_methods = [:get, :post]

# OmniAuth.config.silence_get_warning = true
