module Emox
  Config = {
    :emox_display_p                  => true,

    # -------------------------------------------------------------------------------- マッチング
    :matching_gap_base               => 7,  # ○**カウンター
    :matching_pow_base               => 50, # gap < 2**(○+カウンター) ならマッチングする
    :matching_interval_second        => 3,  # カウンターをインクリメントする間隔(秒)
    :matching_forgo_second           => 10, # ○秒たったらマッチングを諦める(nullなら無限)

    # -------------------------------------------------------------------------------- バトル中の設定
    # 共通
    :leader_index                    => 1,        # シングルトンとハイブリッドルールのときの memberships のインデックス○をリーダーにする。:0 =>左側 1:右側
  }

  if Rails.env.staging? || Rails.env.production?
    Config.update({
        :matching_pow_base        => 10,       # gap < 2**(○+カウンター) ならマッチングする
        :matching_interval_second => 5,        # カウンターをインクリメントする間隔(秒)
        :matching_forgo_second    => 60*10,    # ○秒たったらマッチングを諦める(nullなら無限)
      })
  end
end
