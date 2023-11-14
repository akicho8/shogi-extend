#!/usr/bin/env ruby
require File.expand_path('../../../config/environment', __FILE__)

# PonaInfinity
# DM9
# H_Kirara

# agent = Swars::Agent::History.new(remote_run: true, user_key: "testarossa00", page_index: 0, rule_key: :ten_min)
# agent.history_url               # => "https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=testarossa00"
# https://shogiwars.heroz.jp/games/history?gtype=&page=1&user_id=testarossa00

history_result = Swars::Agent::History.new(remote_run: true, user_key: "testarossa00", page_index: 0, rule_key: :ten_min).fetch
tp history_result.all_keys

# tp history_result.all_keys.collect { |key| Swars::Agent::Record.new(remote_run: true, key: key).fetch }
# >> <!DOCTYPE html>
# >> <html>
# >> <head>
# >>   <meta charset="UTF-8" />
# >>   <meta http-equiv="Content-Style-Type" content="text/css" />
# >>   <meta http-equiv="Pragma" content="no-cache" />
# >>   <meta http-equiv="Cache-Control" content="no-cache" />
# >>   <meta http-equiv="Expires" content="0" />
# >>   <meta name="description" content="将棋ウォーズ【日本将棋連盟公認】は、従来の将棋アプリの常識を覆す派手な演出、グラフィックとAIを駆使し、超初心者から上級者まですぐに適切な相手が見つかる充実のオンライン対局を提供するサービスです。 10分切れ負けや3分切れ負けや10秒将棋でスピーディーに対局できます。オフラインでコンピュータと対局もできます。将棋ウォーズの段級位で、日本将棋連盟公認の免状・認定状（六段～５級）申請できます。" />
# >>   <meta name="keywords" content="加藤一二三,香川愛生,将棋,ゲーム,将棋ウォーズ,日本将棋連盟,無料,アプリ,iPhone,android,SHOGIWARS,shogiwars,棋神降臨,棋神解析,どうぶつしょうぎ,オンライン対局,オンライン,棋力,藤井聡太,羽生善治,名人,棋神,竜王,プロ棋士,囲い,戦法,Ponanza,指導対局,電王戦,棋神クイズ,ニコニコ,AbemaTV,将棋めし,棋神戦,灼熱の時代,3月のライオン,宗桂" />
# >>   <meta property="og:type" content="website">
# >>   <meta property="og:title" content="将棋ウォーズ">
# >>   <meta property="og:image" content="https://shogiwars.heroz.jp/images/icon_512.jpg">
# >>   <meta property="og:url" content="https://shogiwars.heroz.jp/">
# >>   <meta property="og:description" content="将棋ウォーズ【日本将棋連盟公認】は、従来の将棋アプリの常識を覆す派手な演出、グラフィックとAIを駆使し、超初心者から上級者まですぐに適切な相手が見つかる充実のオンライン対局を提供するサービスです。 10分切れ負けや3分切れ負けや10秒将棋でスピーディーに対局できます。オフラインでコンピュータと対局もできます。将棋ウォーズの段級位で、日本将棋連盟公認の免状・認定状（六段～５級）申請できます。">
# >>   <meta property="og:site_name" content="将棋ウォーズ">
# >>   <meta property="og:locale" content="ja_JP">
# >>   <meta name="twitter:site" content="@warsminamin">
# >>   <meta name="twitter:card" content="app">
# >>   <meta name="twitter:description" content="将棋ウォーズ【日本将棋連盟公認】は、従来の将棋アプリの常識を覆す派手な演出、グラフィックとAIを駆使し、超初心者から上級者まですぐに適切な相手が見つかる充実のオンライン対局を提供するサービスです。 10分切れ負けや3分切れ負けや10秒将棋でスピーディーに対局できます。オフラインでコンピュータと対局もできます。将棋ウォーズの段級位で、日本将棋連盟公認の免状・認定状（六段～５級）申請できます。">
# >>   <meta name="twitter:app:country" content="JP">
# >>   <meta name="twitter:app:name:iphone" content="将棋ウォーズ">
# >>   <meta name="twitter:app:id:iphone" content="496801169">
# >>   <meta name="twitter:app:url:iphone" content="https://itunes.apple.com/jp/app/id496801169?mt=8">
# >>   <meta name="twitter:app:name:ipad" content="将棋ウォーズ">
# >>   <meta name="twitter:app:id:ipad" content="496801169">
# >>   <meta name="twitter:app:url:ipad" content="https://itunes.apple.com/jp/app/id496801169?mt=8">
# >>   <meta name="twitter:app:name:googleplay" content="将棋ウォーズ">
# >>   <meta name="twitter:app:id:googleplay" content="jp.heroz.android.shogiwars">
# >>   <meta name="twitter:app:url:googleplay" content="https://play.google.com/store/apps/details?id=jp.heroz.android.shogiwars">
# >>   <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" />
# >>   <meta name="format-detection" content="telephone=no">
# >>   
# >>   <link rel="shortcut icon" type="image/x-icon" href="/favicon.ico" />
# >>   <title>testarossa00 対局履歴</title>
# >>   <link rel="stylesheet" media="screen" href="//shogiwars-cdn.heroz.jp/assets/application-712b15ed4c346239aa01d801de3ce1d58ed18e3fe7cd0104538c8800470e827f.css" />
# >>     
# >>   
# >> <link rel="stylesheet" media="screen" href="//shogiwars-cdn.heroz.jp/assets/games/history-9d93aa44bfb8de65daff20c039bfd4a876740fde934cea23d8dd773d4917b37b.css" />
# >> 
# >> 
# >>   <script src="//shogiwars-cdn.heroz.jp/assets/application-dd98e7289df4c48920be6241e183db5ad93a65653ced5b2d1d76533e04152feb.js"></script>
# >>     
# >> <script src="//shogiwars-cdn.heroz.jp/assets/games/history-f8e91e8c5f5d474624ebb465a833296c479ee2e707faa2c360712f3443e8f605.js"></script>
# >> 
# >> <script src="//shogiwars-cdn.heroz.jp/assets/i18n/ja-cc84741a320c01fcf46a58b9afc0a2f6ee1a0935fcbbfce15331a048620a1057.js"></script>
# >> <script>
# >>     I18n.defaultLocale = "ja"
# >>     I18n.locale = "ja"
# >> </script>
# >> 
# >>   <meta name="csrf-param" content="authenticity_token" />
# >> <meta name="csrf-token" content="3BQ1GH7aipmeMEqELRUHb8vFB5YiLbOInnZz18clg3VBkHgZC6_W8Z_f1Y3IEMRM6JdOnZaCs0vWqoU2s1xpng" />
# >> 
# >>   <script type="text/javascript">
# >>       function goTop(){
# >>           $('body,html').animate({scrollTop: 0},500);
# >>       }
# >>   </script>
# >> 
# >>   <style type="text/css">
# >>     #topNavigation{
# >>       position: absolute;
# >>       left: 80%;
# >>       min-width: 15%;
# >>       max-width: 20%;
# >>       padding: 12px 0px;
# >>     }
# >>     #topNavigation div{
# >>       width: 100%;
# >>       /*background: #2E7D32;*/
# >>       background: rgba(46, 125, 50, 0.8);
# >>       border: 1px solid #1B5E20;
# >>       border-radius: 4px;
# >>       -webkit-border-radius: 4px;
# >>       -moz-border-radius: 4px;
# >>     }
# >>     #topNavigation a{
# >>       display: block;
# >>       padding: 6px;
# >>       color: #A5D6A7;
# >>       font-size: 12px;
# >>       font-weight: bold;
# >>       text-shadow: 1px 1px 1px #1B5E20;
# >>       -moz-text-shadow: 1px 1px 1px #1B5E20;
# >>       -webkit-text-shadow: 1px 1px 1px #1B5E20;
# >>       text-decoration: none;
# >>     }
# >>     #session_invalid{
# >>       padding:4px;
# >>       font-size:12px;
# >>       color:#A5D6A7;
# >>       font-weight: bold;
# >>       text-shadow: 1px 1px 1px #1B5E20;
# >>       -moz-text-shadow: 1px 1px 1px #1B5E20;
# >>       -webkit-text-shadow: 1px 1px 1px #1B5E20;
# >>       background: rgba(46, 125, 50, 0.8);
# >>       border-bottom:2px solid #1B5E20;
# >>     }
# >>   </style>
# >> 
# >>   <script async src="https://www.googletagmanager.com/gtag/js?id=G-X0F89DVXWM"></script>
# >> <script>
# >>     window.dataLayer = window.dataLayer || [];
# >>     function gtag(){dataLayer.push(arguments);}
# >>     gtag('js', new Date());
# >> 
# >>     gtag('config', 'G-X0F89DVXWM');
# >>     gtag('config', 'AW-972589478');
# >> </script></head>
# >> 
# >> <body>
# >>   <div id="wrapper">
# >>     
# >>   <div class="title">
# >>     testarossa00 対局結果・棋譜一覧
# >>   </div>
# >> 
# >>   <div id="history_all">
# >>       <div id="category_select_tab">
# >>   <ul>
# >>       <li id="ten_min_tab" class="tab3 selected_tab">
# >>         <a onclick="changeGameTab([&quot;ten_min_tab&quot;, &quot;three_min_tab&quot;, &quot;ten_sec_tab&quot;], 0, &#39;&#39;, false);" href="javascript:void(0);">10分</a>
# >>       </li>
# >>       <li id="three_min_tab" class="tab3">
# >>         <a onclick="changeGameTab([&quot;ten_min_tab&quot;, &quot;three_min_tab&quot;, &quot;ten_sec_tab&quot;], 1, &#39;sb&#39;, false);" href="javascript:void(0);">3分</a>
# >>       </li>
# >>       <li id="ten_sec_tab" class="tab3">
# >>         <a onclick="changeGameTab([&quot;ten_min_tab&quot;, &quot;three_min_tab&quot;, &quot;ten_sec_tab&quot;], 2, &#39;s1&#39;, false);" href="javascript:void(0);">10秒</a>
# >>       </li>
# >>   </ul>
# >> </div>
# >> 
# >> 
# >>     <div id="history_content">
# >>       <div id="history_search_area">
# >>           <div id="history_search">
# >>     <form id="search_form" action="/games/history?locale=ja" accept-charset="UTF-8" data-remote="true" method="get">
# >>         <button id="btn_is_latest" class="is_latest_tab">直近30日</button>
# >>         <div id="month_list">
# >>             <select class="month_area" id="month" name="month"><option value="">表示する月を選択</option>
# >> <option value="2023-11">2023-11</option>
# >> <option value="2023-10">2023-10</option>
# >> <option value="2023-09">2023-09</option>
# >> <option value="2023-08">2023-08</option>
# >> <option value="2023-07">2023-07</option>
# >> <option value="2023-06">2023-06</option>
# >> <option value="2023-05">2023-05</option>
# >> <option value="2023-04">2023-04</option>
# >> <option value="2023-03">2023-03</option>
# >> <option value="2023-02">2023-02</option>
# >> <option value="2023-01">2023-01</option>
# >> <option value="2022-12">2022-12</option>
# >> <option value="2022-11">2022-11</option>
# >> <option value="2022-10">2022-10</option>
# >> <option value="2022-09">2022-09</option>
# >> <option value="2022-08">2022-08</option>
# >> <option value="2022-07">2022-07</option>
# >> <option value="2022-06">2022-06</option>
# >> <option value="2022-05">2022-05</option>
# >> <option value="2022-04">2022-04</option>
# >> <option value="2022-03">2022-03</option>
# >> <option value="2022-02">2022-02</option>
# >> <option value="2022-01">2022-01</option>
# >> <option value="2021-12">2021-12</option>
# >> <option value="2021-11">2021-11</option>
# >> <option value="2021-10">2021-10</option>
# >> <option value="2021-09">2021-09</option>
# >> <option value="2021-08">2021-08</option>
# >> <option value="2021-07">2021-07</option>
# >> <option value="2021-06">2021-06</option>
# >> <option value="2021-05">2021-05</option>
# >> <option value="2021-04">2021-04</option>
# >> <option value="2021-03">2021-03</option>
# >> <option value="2021-02">2021-02</option>
# >> <option value="2021-01">2021-01</option>
# >> <option value="2020-12">2020-12</option>
# >> <option value="2020-11">2020-11</option>
# >> <option value="2020-10">2020-10</option>
# >> <option value="2020-09">2020-09 (36勝9敗)</option>
# >> <option value="2020-08">2020-08 (12勝6敗)</option>
# >> <option value="2020-07">2020-07</option>
# >> <option value="2020-06">2020-06</option>
# >> <option value="2020-05">2020-05</option>
# >> <option value="2020-04">2020-04</option>
# >> <option value="2020-03">2020-03 (0勝3敗)</option>
# >> <option value="2020-02">2020-02</option>
# >> <option value="2020-01">2020-01</option>
# >> <option value="2019-12">2019-12</option>
# >> <option value="2019-11">2019-11 (6勝12敗)</option>
# >> <option value="2019-10">2019-10</option>
# >> <option value="2019-09">2019-09</option>
# >> <option value="2019-08">2019-08</option>
# >> <option value="2019-07">2019-07</option>
# >> <option value="2019-06">2019-06</option>
# >> <option value="2019-05">2019-05</option>
# >> <option value="2019-04">2019-04</option>
# >> <option value="2019-03">2019-03</option>
# >> <option value="2019-02">2019-02</option>
# >> <option value="2019-01">2019-01</option>
# >> <option value="2018-12">2018-12</option>
# >> <option value="2018-11">2018-11</option>
# >> <option value="2018-10">2018-10</option>
# >> <option value="2018-09">2018-09</option>
# >> <option value="2018-08">2018-08</option>
# >> <option value="2018-07">2018-07</option>
# >> <option value="2018-06">2018-06</option>
# >> <option value="2018-05">2018-05</option>
# >> <option value="2018-04">2018-04</option>
# >> <option value="2018-03">2018-03</option>
# >> <option value="2018-02">2018-02</option>
# >> <option value="2018-01">2018-01</option>
# >> <option value="2017-12">2017-12</option>
# >> <option value="2017-11">2017-11</option>
# >> <option value="2017-10">2017-10</option>
# >> <option value="2017-09">2017-09</option>
# >> <option value="2017-08">2017-08</option>
# >> <option value="2017-07">2017-07</option>
# >> <option value="2017-06">2017-06</option>
# >> <option value="2017-05">2017-05</option>
# >> <option value="2017-04">2017-04</option>
# >> <option value="2017-03">2017-03</option>
# >> <option value="2017-02">2017-02</option>
# >> <option value="2017-01">2017-01</option>
# >> <option value="2016-12">2016-12</option>
# >> <option value="2016-11">2016-11</option>
# >> <option value="2016-10">2016-10</option>
# >> <option value="2016-09">2016-09</option>
# >> <option value="2016-08">2016-08</option>
# >> <option value="2016-07">2016-07</option>
# >> <option value="2016-06">2016-06</option>
# >> <option value="2016-05">2016-05</option>
# >> <option value="2016-04">2016-04</option>
# >> <option value="2016-03">2016-03</option>
# >> <option value="2016-02">2016-02</option>
# >> <option value="2016-01">2016-01</option>
# >> <option value="2015-12">2015-12</option>
# >> <option value="2015-11">2015-11</option>
# >> <option value="2015-10">2015-10</option>
# >> <option value="2015-09">2015-09</option>
# >> <option value="2015-08">2015-08</option>
# >> <option value="2015-07">2015-07</option>
# >> <option value="2015-06">2015-06</option>
# >> <option value="2015-05">2015-05</option>
# >> <option value="2015-04">2015-04</option>
# >> <option value="2015-03">2015-03</option>
# >> <option value="2015-02">2015-02</option>
# >> <option value="2015-01">2015-01</option>
# >> <option value="2014-12">2014-12</option>
# >> <option value="2014-11">2014-11</option>
# >> <option value="2014-10">2014-10</option>
# >> <option value="2014-09">2014-09</option>
# >> <option value="2014-08">2014-08</option>
# >> <option value="2014-07">2014-07</option>
# >> <option value="2014-06">2014-06</option>
# >> <option value="2014-05">2014-05</option>
# >> <option value="2014-04">2014-04</option>
# >> <option value="2014-03">2014-03</option>
# >> <option value="2014-02">2014-02</option>
# >> <option value="2014-01">2014-01</option>
# >> <option value="2013-12">2013-12</option>
# >> <option value="2013-11">2013-11</option>
# >> <option value="2013-10">2013-10</option>
# >> <option value="2013-09">2013-09</option>
# >> <option value="2013-08">2013-08</option>
# >> <option value="2013-07">2013-07</option>
# >> <option value="2013-06">2013-06</option>
# >> <option value="2013-05">2013-05</option>
# >> <option value="2013-04">2013-04</option>
# >> <option value="2013-03">2013-03</option>
# >> <option value="2013-02">2013-02</option>
# >> <option value="2013-01">2013-01</option>
# >> <option value="2012-12">2012-12</option>
# >> <option value="2012-11">2012-11</option>
# >> <option value="2012-10">2012-10</option>
# >> <option value="2012-09">2012-09</option>
# >> <option value="2012-08">2012-08</option>
# >> <option value="2012-07">2012-07</option>
# >> <option value="2012-06">2012-06</option>
# >> <option value="2012-05">2012-05</option>
# >> <option value="2012-04">2012-04</option>
# >> <option value="2012-03">2012-03</option>
# >> <option value="2012-02">2012-02</option>
# >> <option value="2012-01">2012-01</option></select>
# >>         </div>
# >> 
# >>         <div id="enable_month_search" data-enable-month-search="false"></div>
# >>         <div id="wars_store_guidance_message" data-wars-store-guidance-message="1ヶ月以上前の棋譜を閲覧するには「プレミアム」もしくは「スーパープレミアム」にご登録いただく必要があります。"></div>
# >>         <div id="wars_store_url" data-wars-store-url="/stores/stripe?locale=ja"></div>
# >>         <div id="wars_store_btn_str" data-wars-store-btn-str="ウォーズストア"></div>
# >> 
# >>         <input value="true" id="is_latest" autocomplete="off" type="hidden" name="is_latest" />
# >> 
# >>         <input value="" autocomplete="off" type="hidden" name="version" id="version" />
# >>         <input value="ja" autocomplete="off" type="hidden" name="locale" id="locale" />
# >>         <input value="testarossa00" autocomplete="off" type="hidden" name="user_id" id="user_id" />
# >>         <input value="" id="gtype" autocomplete="off" type="hidden" name="gtype" />
# >> </form>  </div>
# >>       </div>
# >>       <div id="list">
# >>         <script src="//shogiwars-cdn.heroz.jp/assets/lib/tab_list-310f7a4b49a1e5c14f4b09405899cd3367909939ef803613cd6480da7ace0cfc.js"></script>
# >> <script src="//shogiwars-cdn.heroz.jp/assets/games/_list-3c94f27384eb834a9dd9f069b1b3ef458486cff1cae7cc1ec6ce6a601bc0a000.js"></script>
# >> <link rel="stylesheet" media="screen" href="//shogiwars-cdn.heroz.jp/assets/games/_list-4251a52a93e15524f5a55a0bafe9006f75916fa29ab663c7623ff6c4eb3e7d99.css" />
# >> 
# >> <script type="text/javascript">
# >>     var analysisClick = false;
# >> 
# >> 
# >>     function appAnalysis(id){
# >>         analysisClick = true;
# >> 
# >>         var url = "/games/history?gtype=&page=1&user_id=testarossa00";
# >>         if(url.match(/back_mypage=true/) == null){
# >>             url = "/games/history?gtype=&page=1&user_id=testarossa00" + "&back_mypage=true";
# >>         }
# >> 
# >>         var params = {game_id: id, back_url: url};
# >>         AppInterface.callToUnity("analysis", params);
# >>     }
# >> </script>
# >> 
# >> 
# >>       </div>
# >>     </div>
# >>   </div>
# >> 
# >> 
# >> <br clear="all" />
# >> 
# >>     <div id="copyright">©HEROZ, Inc. All Rights Reserved.</div>
# >>   </div>
# >>   <div id="topNavigation">
# >>     <div><a href="javascript:void(0)" onClick="goTop()">▲TOP</a></div>
# >> </div>
# >> 
# >>   <div id="web_base_url" data-web-base-url="//shogiwars-cdn.heroz.jp"></div>
# >> </body>
# >> </html>
