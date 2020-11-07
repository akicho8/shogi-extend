module Emox
  Config = {
    :emox_display_p                  => true,

    # -------------------------------------------------------------------------------- 共通
    :action_cable_debug              => true, # ActionCable関連デバッグモード

    # -------------------------------------------------------------------------------- マッチング
    :matching_gap_base               => 7,  # ○**カウンター
    :matching_pow_base               => 50, # gap < 2**(○+カウンター) ならマッチングする
    :matching_interval_second        => 3,  # カウンターをインクリメントする間隔(秒)
    :matching_forgo_second           => 10, # ○秒たったらマッチングを諦める(nullなら無限)
    :matching_cancel_possible_second => 2,  # ○秒たったらマッチングを諦めることができる(nullなら諦めることができない)

    # -------------------------------------------------------------------------------- バトル中の設定
    # 共通
    :leader_index                    => 1,        # シングルトンとハイブリッドルールのときの memberships のインデックス○をリーダーにする。:0 =>左側 1:右側
    :self_is_left_side_p             => false,    # 自分を左に表示
    :readygo_delay                   => 2.2,      # 「対戦開始！」の待ち
  }

  if Rails.env.staging? || Rails.env.production?
    Config.update({
        :matching_pow_base               => 6,        # gap < 2**(○+カウンター) ならマッチングする
        :matching_interval_second        => 4,        # カウンターをインクリメントする間隔(秒)
        :matching_forgo_second           => 60*5,     # ○秒たったらマッチングを諦める(nullなら無限)
        :matching_cancel_possible_second => 30,       # ○秒たったらマッチングを諦めることができる
        :action_cable_debug              => false,    # ActionCable関連デバッグモード
        :self_is_left_side_p             => true,     # 自分を左に表示
        :sp_theme                        => "real",   # 将棋盤のタイプ
      })
  end
end
