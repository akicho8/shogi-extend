# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## プロジェクト概要

SHOGI-EXTEND (https://www.shogi-extend.com/) は Rails + Nuxt.js で構築された将棋アプリケーション。

主要機能:
- **Swars**: 将棋ウォーズの棋譜検索・分析 (`app/models/swars/`)
- **Free Battles**: 棋譜投稿機能 (`app/models/free_battle.rb`)
- **Share Board**: 共有将棋盤 (`app/models/share_board/`)
- **Wkbk**: 問題集機能 (`app/models/wkbk/`)
- **XY Master**: トレーニングバトル (`app/models/xy_master/`)

## 開発コマンド

### セットアップ

```bash
# 初回セットアップ（データベース作成・シード実行・テスト実行含む）
bin/setup

# Node.js 環境セットアップ
bin/setup-node.sh
bin/setup-nuxt.sh
```

### サーバー起動

```bash
# Foreman で全サービスを起動（Rails、Webpack、Sidekiq、Nuxt.js）
foreman start -f Procfile.home

# または個別に起動
bundle exec rails server -p 3000
cd nuxt_side && nuxt dev -p 4000
sidekiq
bundle exec bin/webpack-dev-server
```

### テスト実行

```bash
# 全テスト
rspec

# モデルテストのみ（高速実行）
rake spec:models SPEC_OPTS='--fail-fast'

# コントローラーテストのみ
rake spec:controllers SPEC_OPTS='--fail-fast'

# 失敗したテストのみ再実行
rspec --only-failures --fail-fast

# 特定のタグを除外/含める
rspec -t ~share_board_spec              # share_board_spec タグを除外
rspec -t share_board_spec               # share_board_spec タグのみ
SHARE_BOARD_SPEC_SKIP=1 rspec           # 環境変数で除外

# システムテスト
rspec spec/system/share_board/**/*_spec.rb
```

### Linter

```bash
# RuboCop 実行（rubocop-rails-omakase 設定）
rubocop

# 自動修正
rubocop -a
```

### データベース

```bash
# マイグレーション
bin/rails db:migrate

# ロールバック
bin/rails db:rollback

# リセット（drop + create + migrate + seed）
bin/rails db:drop:_unsafe
bin/rails db:migrate:reset
SETUP=1 rails db:seed

# スキーマダンプ（SQL と Ruby 両方）
bin/rails db:schema:dump SCHEMA_FORMAT=sql
bin/rails db:schema:dump SCHEMA_FORMAT=ruby
```

### アセット

```bash
# Webpack コンパイル
bundle exec bin/webpack

# テスト用アセットプリコンパイル
RAILS_ENV=test rails assets:precompile
```

### Redis 操作

```bash
# タイムレコードクリア
bin/rails r "XyMaster::TimeRecord.delete_all"
bin/rails r "XyMaster::RuleInfo.redis.flushdb"
```

## アーキテクチャ

### ディレクトリ構造

- **app/models/**: ActiveRecord モデルとドメインロジック
  - `swars/`: 将棋ウォーズ関連（Battle, User, Agent, Crawler など）
  - `share_board/`: 共有将棋盤（Room, ChatAI など）
  - `wkbk/`: 問題集（Article, Book, MovesAnswer など）
  - `talk/`: 音声読み上げ API（AWS Polly）
  - `quick_script/`: 管理用スクリプト群
  - `backend_script/`, `frontend_script/`: スクリプト実行基盤
- **app/controllers/**: Rails コントローラー（API とビュー両方）
- **nuxt_side/**: Nuxt.js フロントエンド（ポート 4000）
  - `pages/`: ページコンポーネント
  - `components/`: 再利用可能コンポーネント
  - `store/`: Vuex ストア
- **spec/**: RSpec テスト
  - `models/`, `controllers/`, `system/`: 各種テスト
  - `factories/`: FactoryBot ファクトリ定義

### 技術スタック

- **Backend**: Rails 8.1.2, Trilogy (MySQL), Redis, Sidekiq
- **Frontend**: Nuxt.js (nuxt_side/), Webpacker 5
- **将棋ロジック**: bioshogi gem（GitHub の master ブランチから取得）
- **認証**: Devise + OmniAuth（Google, Twitter, GitHub）
- **音声**: AWS Polly
- **AI**: OpenAI API
- **外部API**: Google Sheets/Drive API

### 重要な規約

1. **タイムゾーン**: `Asia/Tokyo` (config/application.rb)
2. **ロケール**: `:ja` (日本語)
3. **テストで Timecop を使用する場合**: テスト後に必ず `Timecop.return` を実行すること（外部 API 呼び出しに影響するため）
4. **コミットメッセージ**: 既存のコミットログを参考に、`[refactor]`, `[fix]`, `[feat]`, `[test]` などのプレフィックスを使用
5. **RuboCop**: trailing comma を無効化しているため、配列・ハッシュの末尾カンマは任意

### デプロイ

```bash
# Capistrano デプロイ
cap production deploy
cap staging deploy
```

デプロイ設定:
- `config/deploy.rb`: 共通設定
- `config/deploy/`: 環境別設定
- `config/ik1_production_server/`, `config/tk2_staging_server/`: サーバー設定

### バッチジョブ・スケジューラー

- **Sidekiq**: 非同期ジョブ処理（`app/jobs/`）
- **Whenever**: cron スケジュール管理（`config/schedule.rb`）
- **MaintenanceTasks**: データ移行・メンテナンスタスク（`/admin/maintenance_tasks` で管理）

### 単一ファイルテスト実行

```bash
# 特定のファイルをテスト
rspec spec/models/swars/battle_spec.rb

# 特定の行のテストのみ
rspec spec/models/swars/battle_spec.rb:42
```

### 開発時の注意点

- `bin/setup` は初回セットアップ用で、データベースを完全にリセットし、全テストを実行する（時間がかかる）
- `Procfile.home` の IP アドレスは `ifconfig | grep inet` で調べた IP に変更すること
- Nuxt.js の環境設定は `nuxt_side/.env.home` に記述
- システムテストがダウンしている場合は `SYSTEM_TEST_DOWN.org` を参照

### モデル/コントローラーの命名規則

- モデルは `app/models/` 以下のディレクトリで機能ごとに整理
- コントローラーは concern を活用（`*_methods.rb` ファイル）してロジックを共有
- `ApplicationMemoryRecord` を継承した MemoryRecord モデルが多数存在（DB を使わない設定値など）
