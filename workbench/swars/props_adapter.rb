#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

swars_react_props = {
  "gameHash"=>
  { "name"=>"kinakom0chi-myan0730-20221104_220631",
    "gtype"=>"",
    "opponent_type"=>0,
    "sente"=>"kinakom0chi",
    "gote"=>"myan0730",
    "sente_dan"=>-1,
    "gote_dan"=>-1,
    "sente_avatar"=>"_e1610s3c",
    "gote_avatar"=>"_",
    "result"=>"SENTE_WIN_TORYO",
    "handicap"=>0,
    "init_sfen_position"=>
    "lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1",
    "moves"=>
    [{ "t"=>591, "n"=>0, "m"=>"+7776FU" },
      { "t"=>599, "n"=>1, "m"=>"-8384FU" },
      { "t"=>588, "n"=>2, "m"=>"+7968GI" },
      { "t"=>596, "n"=>3, "m"=>"-8485FU" },
      { "t"=>587, "n"=>4, "m"=>"+8877KA" },
      { "t"=>592, "n"=>5, "m"=>"-4132KI" },
      { "t"=>586, "n"=>6, "m"=>"+2726FU" },
      { "t"=>589, "n"=>7, "m"=>"-3334FU" },
      { "t"=>584, "n"=>8, "m"=>"+6766FU" },
      { "t"=>583, "n"=>9, "m"=>"-3142GI" },
      { "t"=>583, "n"=>10, "m"=>"+6867GI" },
      { "t"=>580, "n"=>11, "m"=>"-7162GI" },
      { "t"=>582, "n"=>12, "m"=>"+2625FU" },
      { "t"=>578, "n"=>13, "m"=>"-2233KA" },
      { "t"=>581, "n"=>14, "m"=>"+3948GI" },
      { "t"=>576, "n"=>15, "m"=>"-5141OU" },
      { "t"=>580, "n"=>16, "m"=>"+4746FU" },
      { "t"=>575, "n"=>17, "m"=>"-6152KI" },
      { "t"=>579, "n"=>18, "m"=>"+4847GI" },
      { "t"=>571, "n"=>19, "m"=>"-1314FU" },
      { "t"=>578, "n"=>20, "m"=>"+1716FU" },
      { "t"=>569, "n"=>21, "m"=>"-7374FU" },
      { "t"=>576, "n"=>22, "m"=>"+6978KI" },
      { "t"=>569, "n"=>23, "m"=>"-6273GI" },
      { "t"=>575, "n"=>24, "m"=>"+4958KI" },
      { "t"=>568, "n"=>25, "m"=>"-7364GI" },
      { "t"=>574, "n"=>26, "m"=>"+4756GI" },
      { "t"=>566, "n"=>27, "m"=>"-8173KE" },
      { "t"=>572, "n"=>28, "m"=>"+5969OU" },
      { "t"=>565, "n"=>29, "m"=>"-8284HI" },
      { "t"=>566, "n"=>30, "m"=>"+3736FU" },
      { "t"=>564, "n"=>31, "m"=>"-9394FU" },
      { "t"=>564, "n"=>32, "m"=>"+9796FU" },
      { "t"=>558, "n"=>33, "m"=>"-7475FU" },
      { "t"=>560, "n"=>34, "m"=>"+6665FU" },
      { "t"=>544, "n"=>35, "m"=>"-7365KE" },
      { "t"=>555, "n"=>36, "m"=>"+7733UM" },
      { "t"=>542, "n"=>37, "m"=>"-4233GI" },
      { "t"=>528, "n"=>38, "m"=>"+7675FU" },
      { "t"=>509, "n"=>39, "m"=>"-0077FU" },
      { "t"=>522, "n"=>40, "m"=>"+8977KE" },
      { "t"=>506, "n"=>41, "m"=>"-6577NK" },
      { "t"=>521, "n"=>42, "m"=>"+7877KI" },
      { "t"=>503, "n"=>43, "m"=>"-0088KA" },
      { "t"=>509, "n"=>44, "m"=>"+7778KI" },
      { "t"=>500, "n"=>45, "m"=>"-8899UM" },
      { "t"=>507, "n"=>46, "m"=>"+0076KE" },
      { "t"=>492, "n"=>47, "m"=>"-8482HI" },
      { "t"=>505, "n"=>48, "m"=>"+7664KE" },
      { "t"=>490, "n"=>49, "m"=>"-6364FU" },
      { "t"=>503, "n"=>50, "m"=>"+0073KA" },
      { "t"=>485, "n"=>51, "m"=>"-8292HI" },
      { "t"=>495, "n"=>52, "m"=>"+7364UM" },
      { "t"=>472, "n"=>53, "m"=>"-8586FU" },
      { "t"=>477, "n"=>54, "m"=>"+6474UM" },
      { "t"=>468, "n"=>55, "m"=>"-8687TO" },
      { "t"=>470, "n"=>56, "m"=>"+0061GI" },
      { "t"=>456, "n"=>57, "m"=>"-3242KI" },
      { "t"=>464, "n"=>58, "m"=>"+6152NG" },
      { "t"=>450, "n"=>59, "m"=>"-4252KI" },
      { "t"=>453, "n"=>60, "m"=>"+7868KI" },
      { "t"=>445, "n"=>61, "m"=>"-8777TO" },
      { "t"=>434, "n"=>62, "m"=>"+0063KI" },
      { "t"=>440, "n"=>63, "m"=>"-5263KI" },
      { "t"=>432, "n"=>64, "m"=>"+7463UM" },
      { "t"=>439, "n"=>65, "m"=>"-0052KI" },
      { "t"=>419, "n"=>66, "m"=>"+6374UM" },
      { "t"=>429, "n"=>67, "m"=>"-7768TO" },
      { "t"=>418, "n"=>68, "m"=>"+5868KI" },
      { "t"=>405, "n"=>69, "m"=>"-0066FU" },
      { "t"=>402, "n"=>70, "m"=>"+0064FU" },
      { "t"=>399, "n"=>71, "m"=>"-6667TO" },
      { "t"=>401, "n"=>72, "m"=>"+5667GI" },
      { "t"=>373, "n"=>73, "m"=>"-4132OU" },
      { "t"=>397, "n"=>74, "m"=>"+6463TO" },
      { "t"=>372, "n"=>75, "m"=>"-5242KI" },
      { "t"=>389, "n"=>76, "m"=>"+0052KI" },
      { "t"=>369, "n"=>77, "m"=>"-4252KI" },
      { "t"=>388, "n"=>78, "m"=>"+6352TO" },
      { "t"=>368, "n"=>79, "m"=>"-3222OU" },
      { "t"=>362, "n"=>80, "m"=>"+5253TO" },
      { "t"=>353, "n"=>81, "m"=>"-9998UM" },
      { "t"=>345, "n"=>82, "m"=>"+0087FU" },
      { "t"=>255, "n"=>83, "m"=>"-9887UM" },
      { "t"=>342, "n"=>84, "m"=>"+6878KI" },
      { "t"=>251, "n"=>85, "m"=>"-8786UM" },
      { "t"=>315, "n"=>86, "m"=>"+0068FU" },
      { "t"=>245, "n"=>87, "m"=>"-0077FU" },
      { "t"=>307, "n"=>88, "m"=>"+7492UM" },
      { "t"=>241, "n"=>89, "m"=>"-7778TO" },
      { "t"=>306, "n"=>90, "m"=>"+6778GI" },
      { "t"=>230, "n"=>91, "m"=>"-8696UM" },
      { "t"=>288, "n"=>92, "m"=>"+9265UM" },
      { "t"=>216, "n"=>93, "m"=>"-0077FU" },
      { "t"=>268, "n"=>94, "m"=>"+0032KI" },
      { "t"=>210, "n"=>95, "m"=>"-2213OU" },
      { "t"=>261, "n"=>96, "m"=>"+1615FU" },
      { "t"=>202, "n"=>97, "m"=>"-9678UM" },
      { "t"=>257, "n"=>98, "m"=>"+6958OU" },
      { "t"=>162, "n"=>99, "m"=>"-1415FU" },
      { "t"=>217, "n"=>100, "m"=>"+6543UM" },
      { "t"=>154, "n"=>101, "m"=>"-0039GI" },
      { "t"=>208, "n"=>102, "m"=>"+2818HI" },
      { "t"=>148, "n"=>103, "m"=>"-0049GI" },
      { "t"=>190, "n"=>104, "m"=>"+5847OU" },
      { "t"=>145, "n"=>105, "m"=>"-0055KE" },
      { "t"=>187, "n"=>106, "m"=>"+4737OU" },
      { "t"=>126, "n"=>107, "m"=>"-7869UM" },
      { "t"=>175, "n"=>108, "m"=>"+1815HI" },
    ],
  },
  "userConfig"=>
  { "imgPieceType"=>"ja_single",
    "soundEnable"=>true,
    "voiceType"=>0,
    "situationFormat"=>"evaluation" },
  "isNeedRealtime"=>false,
  "isNeedTargetParent"=>false,
  "isNotReload"=>false,
  "settings"=>
  { "cdn.web"=>"//shogiwars-cdn.heroz.jp",
    "cdn.image"=>"//image-pona.heroz.jp",
    "cdn.sound"=>"//sound-pona.heroz.jp",
    "goldengate.match.host"=>"wss://shogiwars-game-web.heroz.jp:7012",
    "javascript.log_level"=>"error" },
  "version"=>"" }

props_adapter = Swars::Agent::PropsAdapter.new(swars_react_props)
tp props_adapter.to_h
# >> |-----------+--------------------------------------|
# >> |   対局KEY | kinakom0chi-myan0730-20221104_220631 |
# >> |  対局日時 | 2022-11-04 22:06:31                  |
# >> |    ルール | 10分                                 |
# >> |      種類 | 通常                                 |
# >> |    手合割 | 平手                                 |
# >> |      結末 | 投了                                 |
# >> |  両者名前 | kinakom0chi:1級 vs myan0730:1級      |
# >> |  勝った側 | ▲                                   |
# >> | 対局後か? | true                                 |
# >> | 対局中か? | false                                |
# >> | 正常終了? | true                                 |
# >> | 棋譜有り? | true                                 |
# >> |  棋譜手数 | 109                                  |
# >> |-----------+--------------------------------------|
