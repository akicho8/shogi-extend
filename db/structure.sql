
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `active_storage_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `active_storage_attachments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `record_type` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `record_id` bigint NOT NULL,
  `blob_id` bigint NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_active_storage_attachments_uniqueness` (`record_type`,`record_id`,`name`,`blob_id`),
  KEY `index_active_storage_attachments_on_blob_id` (`blob_id`),
  CONSTRAINT `fk_rails_c3b3935057` FOREIGN KEY (`blob_id`) REFERENCES `active_storage_blobs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `active_storage_blobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `active_storage_blobs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `content_type` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `metadata` text COLLATE utf8mb4_bin,
  `byte_size` bigint NOT NULL,
  `checksum` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `service_name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_active_storage_blobs_on_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `active_storage_variant_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `active_storage_variant_records` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `blob_id` bigint NOT NULL,
  `variation_digest` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_active_storage_variant_records_uniqueness` (`blob_id`,`variation_digest`),
  CONSTRAINT `fk_rails_993965df05` FOREIGN KEY (`blob_id`) REFERENCES `active_storage_blobs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `aggregate_caches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `aggregate_caches` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_name` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT 'スコープ',
  `generation` int NOT NULL COMMENT '世代',
  `aggregated_value` json NOT NULL COMMENT '集計済みデータ',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_aggregate_caches_on_group_name_and_generation` (`group_name`,`generation`),
  KEY `index_aggregate_caches_on_group_name` (`group_name`),
  KEY `index_aggregate_caches_on_generation` (`generation`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `app_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `app_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `level` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `emoji` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `subject` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `body` text COLLATE utf8mb4_bin NOT NULL,
  `process_id` int NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `value` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `auth_infos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_infos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT 'ユーザー',
  `provider` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '何経由でログインしたか',
  `uid` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '長い内部ID(providerとペアではユニーク)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_auth_infos_on_provider_and_uid` (`provider`,`uid`),
  KEY `index_auth_infos_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_c410a39830` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cpu_battle_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cpu_battle_records` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL COMMENT 'ログインしているならそのユーザー',
  `judge_key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '結果',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_cpu_battle_records_on_user_id` (`user_id`),
  KEY `index_cpu_battle_records_on_judge_key` (`judge_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `free_battles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `free_battles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_bin NOT NULL COMMENT 'URL識別子',
  `title` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `kifu_body` text COLLATE utf8mb4_bin NOT NULL COMMENT '棋譜本文',
  `sfen_body` text COLLATE utf8mb4_bin NOT NULL COMMENT 'SFEN形式',
  `turn_max` int NOT NULL COMMENT '手数',
  `meta_info` text COLLATE utf8mb4_bin NOT NULL COMMENT '棋譜メタ情報',
  `battled_at` datetime NOT NULL COMMENT '対局開始日時',
  `use_key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `accessed_at` datetime NOT NULL COMMENT '最終参照日時',
  `user_id` bigint DEFAULT NULL,
  `description` text COLLATE utf8mb4_bin NOT NULL,
  `sfen_hash` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `start_turn` int DEFAULT NULL COMMENT '???',
  `critical_turn` int DEFAULT NULL COMMENT '開戦',
  `outbreak_turn` int DEFAULT NULL COMMENT '中盤',
  `image_turn` int DEFAULT NULL COMMENT '???',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `preset_id` bigint DEFAULT NULL COMMENT '手合割',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_free_battles_on_key` (`key`),
  KEY `index_free_battles_on_turn_max` (`turn_max`),
  KEY `index_free_battles_on_battled_at` (`battled_at`),
  KEY `index_free_battles_on_use_key` (`use_key`),
  KEY `index_free_battles_on_accessed_at` (`accessed_at`),
  KEY `index_free_battles_on_user_id` (`user_id`),
  KEY `index_free_battles_on_start_turn` (`start_turn`),
  KEY `index_free_battles_on_critical_turn` (`critical_turn`),
  KEY `index_free_battles_on_outbreak_turn` (`outbreak_turn`),
  KEY `index_free_battles_on_preset_id` (`preset_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `google_api_expiration_trackers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `google_api_expiration_trackers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `spreadsheet_id` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `holidays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `holidays` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `holiday_on` date NOT NULL COMMENT '祝日',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_holidays_on_holiday_on` (`holiday_on`)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `judges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `judges` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int DEFAULT NULL COMMENT '順序',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_judges_on_key` (`key`),
  KEY `index_judges_on_position` (`position`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `kiwi_access_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kiwi_access_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL COMMENT '参照者',
  `banana_id` bigint NOT NULL COMMENT '動画',
  `created_at` datetime NOT NULL COMMENT '記録日時',
  PRIMARY KEY (`id`),
  KEY `index_kiwi_access_logs_on_user_id` (`user_id`),
  KEY `index_kiwi_access_logs_on_banana_id` (`banana_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `kiwi_banana_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kiwi_banana_messages` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '発言者',
  `banana_id` bigint NOT NULL COMMENT '動画',
  `body` varchar(512) COLLATE utf8mb4_bin NOT NULL COMMENT '発言',
  `position` int NOT NULL COMMENT '番号',
  `deleted_at` datetime DEFAULT NULL COMMENT '削除日時',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_kiwi_banana_messages_on_banana_id_and_position` (`banana_id`,`position`),
  KEY `index_kiwi_banana_messages_on_user_id` (`user_id`),
  KEY `index_kiwi_banana_messages_on_banana_id` (`banana_id`),
  KEY `index_kiwi_banana_messages_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `kiwi_bananas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kiwi_bananas` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `user_id` bigint NOT NULL COMMENT '作成者',
  `folder_id` bigint NOT NULL COMMENT 'フォルダ',
  `lemon_id` bigint NOT NULL COMMENT '動画',
  `title` varchar(100) COLLATE utf8mb4_bin NOT NULL COMMENT 'タイトル',
  `description` text COLLATE utf8mb4_bin NOT NULL COMMENT '説明',
  `thumbnail_pos` float NOT NULL COMMENT 'サムネ位置',
  `banana_messages_count` int NOT NULL DEFAULT '0' COMMENT 'コメント数',
  `access_logs_count` int NOT NULL DEFAULT '0' COMMENT '総アクセス数',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_kiwi_bananas_on_key` (`key`),
  UNIQUE KEY `index_kiwi_bananas_on_lemon_id` (`lemon_id`),
  KEY `index_kiwi_bananas_on_user_id` (`user_id`),
  KEY `index_kiwi_bananas_on_folder_id` (`folder_id`),
  KEY `index_kiwi_bananas_on_banana_messages_count` (`banana_messages_count`),
  KEY `index_kiwi_bananas_on_access_logs_count` (`access_logs_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `kiwi_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kiwi_folders` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int NOT NULL,
  `bananas_count` int NOT NULL DEFAULT '0' COMMENT '問題集数',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_kiwi_folders_on_key` (`key`),
  KEY `index_kiwi_folders_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `kiwi_lemons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kiwi_lemons` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '所有者',
  `recordable_type` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `recordable_id` bigint NOT NULL COMMENT '対象レコード',
  `all_params` text COLLATE utf8mb4_bin NOT NULL COMMENT '変換パラメータ全部入り',
  `process_begin_at` datetime DEFAULT NULL COMMENT '処理開始日時',
  `process_end_at` datetime DEFAULT NULL COMMENT '処理終了日時',
  `successed_at` datetime DEFAULT NULL COMMENT '成功日時',
  `errored_at` datetime DEFAULT NULL COMMENT 'エラー日時',
  `error_message` text COLLATE utf8mb4_bin COMMENT 'エラーメッセージ',
  `content_type` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'コンテンツタイプ',
  `file_size` int DEFAULT NULL COMMENT 'ファイルサイズ',
  `ffprobe_info` text COLLATE utf8mb4_bin COMMENT '変換パラメータ',
  `browser_path` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '生成したファイルへのパス',
  `filename_human` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'ダウンロードファイル名',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_kiwi_lemons_on_user_id` (`user_id`),
  KEY `index_kiwi_lemons_on_recordable_type_and_recordable_id` (`recordable_type`,`recordable_id`),
  KEY `index_kiwi_lemons_on_process_begin_at` (`process_begin_at`),
  KEY `index_kiwi_lemons_on_process_end_at` (`process_end_at`),
  KEY `index_kiwi_lemons_on_successed_at` (`successed_at`),
  KEY `index_kiwi_lemons_on_errored_at` (`errored_at`),
  KEY `index_kiwi_lemons_on_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `locations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int DEFAULT NULL COMMENT '順序',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_locations_on_key` (`key`),
  KEY `index_locations_on_position` (`position`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `permanent_variables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permanent_variables` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT 'キー',
  `value` json NOT NULL COMMENT '値',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_permanent_variables_on_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `presets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `presets` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int DEFAULT NULL COMMENT '順序',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_presets_on_key` (`key`),
  KEY `index_presets_on_position` (`position`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `profiles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT 'ユーザー',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_profiles_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_e424190865` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `share_board_battles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `share_board_battles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `room_id` bigint NOT NULL COMMENT '部屋',
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '対局識別子',
  `title` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT 'タイトル',
  `sfen` text COLLATE utf8mb4_bin NOT NULL,
  `turn` int NOT NULL COMMENT '手数',
  `win_location_id` bigint NOT NULL COMMENT '勝利側',
  `position` int DEFAULT NULL COMMENT '順序',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_share_board_battles_on_key` (`key`),
  KEY `index_share_board_battles_on_room_id` (`room_id`),
  KEY `index_share_board_battles_on_turn` (`turn`),
  KEY `index_share_board_battles_on_win_location_id` (`win_location_id`),
  KEY `index_share_board_battles_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `share_board_chat_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `share_board_chat_messages` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `room_id` bigint NOT NULL COMMENT '部屋',
  `user_id` bigint NOT NULL COMMENT '発言者(キーは名前だけなのですり変われる)',
  `message_scope_id` bigint NOT NULL COMMENT 'スコープ',
  `content` varchar(256) COLLATE utf8mb4_bin NOT NULL COMMENT '発言内容',
  `performed_at` bigint NOT NULL COMMENT '実行開始日時(ms)',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `session_user_id` bigint DEFAULT NULL COMMENT 'ログインユーザー',
  `from_connection_id` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'null なら bot 等',
  `primary_emoji` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '優先する絵文字',
  PRIMARY KEY (`id`),
  KEY `index_share_board_chat_messages_on_room_id` (`room_id`),
  KEY `index_share_board_chat_messages_on_user_id` (`user_id`),
  KEY `index_share_board_chat_messages_on_message_scope_id` (`message_scope_id`),
  KEY `index_share_board_chat_messages_on_session_user_id` (`session_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `share_board_memberships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `share_board_memberships` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `battle_id` bigint NOT NULL COMMENT '対局',
  `user_id` bigint NOT NULL COMMENT '対局者',
  `judge_id` bigint NOT NULL COMMENT '勝・敗・引き分け',
  `location_id` bigint NOT NULL COMMENT '▲△',
  `position` int DEFAULT NULL COMMENT '順序',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_share_board_memberships_on_battle_id` (`battle_id`),
  KEY `index_share_board_memberships_on_user_id` (`user_id`),
  KEY `index_share_board_memberships_on_judge_id` (`judge_id`),
  KEY `index_share_board_memberships_on_location_id` (`location_id`),
  KEY `index_share_board_memberships_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `share_board_message_scopes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `share_board_message_scopes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int DEFAULT NULL COMMENT '順序',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_share_board_message_scopes_on_key` (`key`),
  KEY `index_share_board_message_scopes_on_position` (`position`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `share_board_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `share_board_rooms` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '部屋識別子',
  `battles_count` int DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `chat_messages_count` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_share_board_rooms_on_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `share_board_roomships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `share_board_roomships` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `room_id` bigint NOT NULL COMMENT '部屋',
  `user_id` bigint NOT NULL COMMENT '対局者',
  `win_count` int NOT NULL COMMENT '勝数',
  `lose_count` int NOT NULL COMMENT '負数',
  `battles_count` int NOT NULL COMMENT '対局数',
  `win_rate` float NOT NULL COMMENT '勝率',
  `score` int NOT NULL COMMENT 'スコア',
  `rank` int NOT NULL COMMENT '順位',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_share_board_roomships_on_room_id` (`room_id`),
  KEY `index_share_board_roomships_on_user_id` (`user_id`),
  KEY `index_share_board_roomships_on_win_count` (`win_count`),
  KEY `index_share_board_roomships_on_lose_count` (`lose_count`),
  KEY `index_share_board_roomships_on_win_rate` (`win_rate`),
  KEY `index_share_board_roomships_on_score` (`score`),
  KEY `index_share_board_roomships_on_rank` (`rank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `share_board_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `share_board_users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '対局者名',
  `memberships_count` int DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `chat_messages_count` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_share_board_users_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `short_url_access_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `short_url_access_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `component_id` bigint DEFAULT NULL COMMENT 'コンポーネント',
  `created_at` datetime NOT NULL COMMENT '記録日時',
  PRIMARY KEY (`id`),
  KEY `index_short_url_access_logs_on_component_id` (`component_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `short_url_components`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `short_url_components` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT 'ハッシュ',
  `original_url` varchar(2048) COLLATE utf8mb4_bin NOT NULL COMMENT '元URL',
  `access_logs_count` int NOT NULL DEFAULT '0' COMMENT '総アクセス数',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_short_url_components_on_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_ban_crawl_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `swars_ban_crawl_requests` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT 'BAN判定対象者',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_swars_ban_crawl_requests_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_battles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `swars_battles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '対局識別子',
  `battled_at` datetime NOT NULL COMMENT '対局開始日時',
  `csa_seq` text COLLATE utf8mb4_bin NOT NULL COMMENT '棋譜の断片',
  `win_user_id` bigint DEFAULT NULL COMMENT '勝者(ショートカット用)',
  `turn_max` int NOT NULL COMMENT '手数',
  `meta_info` text COLLATE utf8mb4_bin NOT NULL COMMENT '棋譜メタ情報',
  `accessed_at` datetime NOT NULL COMMENT '最終参照日時',
  `sfen_body` text COLLATE utf8mb4_bin NOT NULL,
  `sfen_hash` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `start_turn` int DEFAULT NULL COMMENT '???',
  `critical_turn` int DEFAULT NULL COMMENT '開戦',
  `outbreak_turn` int DEFAULT NULL COMMENT '中盤',
  `image_turn` int DEFAULT NULL COMMENT '???',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `xmode_id` bigint NOT NULL COMMENT '対局モード',
  `preset_id` bigint NOT NULL COMMENT '手合割',
  `rule_id` bigint NOT NULL COMMENT '持ち時間',
  `final_id` bigint NOT NULL COMMENT '結末',
  `analysis_version` int NOT NULL DEFAULT '0' COMMENT '戦法解析バージョン',
  `starting_position` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '初期配置',
  `imode_id` bigint NOT NULL COMMENT '開始モード',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_swars_battles_on_key` (`key`),
  KEY `index_swars_battles_on_battled_at` (`battled_at`),
  KEY `index_swars_battles_on_win_user_id` (`win_user_id`),
  KEY `index_swars_battles_on_turn_max` (`turn_max`),
  KEY `index_swars_battles_on_accessed_at` (`accessed_at`),
  KEY `index_swars_battles_on_start_turn` (`start_turn`),
  KEY `index_swars_battles_on_critical_turn` (`critical_turn`),
  KEY `index_swars_battles_on_outbreak_turn` (`outbreak_turn`),
  KEY `index_swars_battles_on_xmode_id` (`xmode_id`),
  KEY `index_swars_battles_on_preset_id` (`preset_id`),
  KEY `index_swars_battles_on_rule_id` (`rule_id`),
  KEY `index_swars_battles_on_final_id` (`final_id`),
  KEY `index_swars_battles_on_imode_id` (`imode_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_crawl_reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `swars_crawl_reservations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '登録者',
  `target_user_key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '対象者',
  `attachment_mode` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT 'ZIPファイル添付の有無',
  `processed_at` datetime DEFAULT NULL COMMENT '処理完了日時',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_swars_crawl_reservations_on_user_id` (`user_id`),
  KEY `index_swars_crawl_reservations_on_attachment_mode` (`attachment_mode`),
  CONSTRAINT `fk_rails_5d22a228b8` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_finals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `swars_finals` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int DEFAULT NULL COMMENT '順序',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_swars_finals_on_key` (`key`),
  KEY `index_swars_finals_on_position` (`position`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `swars_grades` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `priority` int NOT NULL COMMENT '優劣',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_swars_grades_on_key` (`key`),
  KEY `index_swars_grades_on_priority` (`priority`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_imodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `swars_imodes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int DEFAULT NULL COMMENT '順序',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_swars_imodes_on_key` (`key`),
  KEY `index_swars_imodes_on_position` (`position`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_membership_extras`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `swars_membership_extras` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `membership_id` bigint NOT NULL COMMENT '対局情報',
  `used_piece_counts` json NOT NULL COMMENT '駒の使用頻度',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_swars_membership_extras_on_membership_id` (`membership_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_memberships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `swars_memberships` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `battle_id` bigint NOT NULL COMMENT '対局',
  `user_id` bigint NOT NULL COMMENT '対局者',
  `op_user_id` bigint DEFAULT NULL COMMENT '相手',
  `grade_id` bigint NOT NULL COMMENT '対局時の段級',
  `position` int DEFAULT NULL COMMENT '手番の順序',
  `grade_diff` int NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `think_all_avg` int DEFAULT NULL COMMENT '指し手の平均秒数(全体)',
  `think_end_avg` int DEFAULT NULL COMMENT '指し手の平均秒数(最後5手)',
  `think_last` int DEFAULT NULL COMMENT '最後の指し手の秒数',
  `think_max` int DEFAULT NULL COMMENT '最大考慮秒数',
  `ai_drop_total` int DEFAULT NULL COMMENT '棋神を使って指した総手数',
  `judge_id` bigint NOT NULL COMMENT '勝敗',
  `location_id` bigint NOT NULL COMMENT '位置',
  `style_id` bigint DEFAULT NULL COMMENT '棋風',
  `ek_score_without_cond` int DEFAULT NULL COMMENT '入玉宣言時の得点(仮)',
  `ek_score_with_cond` int DEFAULT NULL COMMENT '入玉宣言時の得点(条件考慮)',
  `ai_wave_count` int DEFAULT NULL COMMENT '棋神使用模様個数',
  `ai_two_freq` float DEFAULT NULL COMMENT '2手差し頻出度',
  `ai_noizy_two_max` int DEFAULT NULL COMMENT '22221パターンを考慮した2の並び個数最大値',
  `ai_gear_freq` float DEFAULT NULL COMMENT '121頻出度',
  `opponent_id` bigint DEFAULT NULL COMMENT '相手レコード',
  PRIMARY KEY (`id`),
  UNIQUE KEY `memberships_sbri_sbui` (`battle_id`,`user_id`),
  UNIQUE KEY `memberships_sbri_lk` (`battle_id`,`location_id`),
  UNIQUE KEY `memberships_bid_ouid` (`battle_id`,`op_user_id`),
  UNIQUE KEY `index_swars_memberships_on_opponent_id` (`opponent_id`),
  KEY `index_swars_memberships_on_battle_id` (`battle_id`),
  KEY `index_swars_memberships_on_user_id` (`user_id`),
  KEY `index_swars_memberships_on_op_user_id` (`op_user_id`),
  KEY `index_swars_memberships_on_grade_id` (`grade_id`),
  KEY `index_swars_memberships_on_position` (`position`),
  KEY `index_swars_memberships_on_judge_id` (`judge_id`),
  KEY `index_swars_memberships_on_location_id` (`location_id`),
  KEY `index_swars_memberships_on_style_id` (`style_id`),
  CONSTRAINT `fk_rails_d0aeb0e4e3` FOREIGN KEY (`battle_id`) REFERENCES `swars_battles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `swars_profiles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '対局者',
  `ban_at` datetime DEFAULT NULL COMMENT '垢BAN日時',
  `ban_crawled_at` datetime NOT NULL COMMENT '垢BANクロール日時',
  `ban_crawled_count` int DEFAULT NULL COMMENT '垢BANクロール回数',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_swars_profiles_on_user_id` (`user_id`),
  KEY `index_swars_profiles_on_ban_at` (`ban_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `swars_rules` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int DEFAULT NULL COMMENT '順序',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_swars_rules_on_key` (`key`),
  KEY `index_swars_rules_on_position` (`position`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_search_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `swars_search_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT 'プレイヤー',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_swars_search_logs_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_styles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `swars_styles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int DEFAULT NULL COMMENT '順序',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_swars_styles_on_key` (`key`),
  KEY `index_swars_styles_on_position` (`position`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `swars_users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '対局者名',
  `grade_id` bigint NOT NULL COMMENT '最高段級',
  `last_reception_at` datetime DEFAULT NULL COMMENT '受容日時',
  `search_logs_count` int DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `ban_at` datetime DEFAULT NULL COMMENT '垢BAN日時',
  `latest_battled_at` datetime NOT NULL COMMENT '直近の対局日時',
  `soft_crawled_at` datetime DEFAULT NULL COMMENT 'クロール(全体)',
  `hard_crawled_at` datetime DEFAULT NULL COMMENT 'クロール(1ページ目のみ)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_swars_users_on_user_key` (`user_key`),
  KEY `index_swars_users_on_grade_id` (`grade_id`),
  KEY `index_swars_users_on_last_reception_at` (`last_reception_at`),
  KEY `index_swars_users_on_updated_at` (`updated_at`),
  KEY `index_swars_users_on_ban_at` (`ban_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_xmodes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `swars_xmodes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int DEFAULT NULL COMMENT '順序',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_swars_xmodes_on_key` (`key`),
  KEY `index_swars_xmodes_on_position` (`position`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_zip_dl_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `swars_zip_dl_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '登録者',
  `swars_user_id` bigint NOT NULL COMMENT '対象者',
  `query` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT 'クエリ全体(予備)',
  `dl_count` int NOT NULL COMMENT 'ダウンロード数(記録用)',
  `begin_at` datetime NOT NULL COMMENT 'スコープ(開始・記録用)',
  `end_at` datetime NOT NULL COMMENT 'スコープ(終了)',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_swars_zip_dl_logs_on_user_id` (`user_id`),
  KEY `index_swars_zip_dl_logs_on_swars_user_id` (`swars_user_id`),
  KEY `index_swars_zip_dl_logs_on_end_at` (`end_at`),
  KEY `index_swars_zip_dl_logs_on_created_at` (`created_at`),
  CONSTRAINT `fk_rails_5edb845d8e` FOREIGN KEY (`swars_user_id`) REFERENCES `swars_users` (`id`),
  CONSTRAINT `fk_rails_ffe7d8a4c6` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `taggings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taggings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tag_id` int DEFAULT NULL,
  `taggable_type` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `taggable_id` int DEFAULT NULL,
  `tagger_type` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `tagger_id` int DEFAULT NULL,
  `context` varchar(128) COLLATE utf8mb4_bin DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `taggings_idx` (`tag_id`,`taggable_id`,`taggable_type`,`context`,`tagger_id`,`tagger_type`),
  KEY `index_taggings_on_taggable_id_and_taggable_type_and_context` (`taggable_id`,`taggable_type`,`context`),
  KEY `index_taggings_on_tag_id` (`tag_id`),
  KEY `index_taggings_on_taggable_id` (`taggable_id`),
  KEY `index_taggings_on_taggable_type` (`taggable_type`),
  KEY `index_taggings_on_tagger_id` (`tagger_id`),
  KEY `index_taggings_on_context` (`context`),
  KEY `index_taggings_on_tagger_id_and_tagger_type` (`tagger_id`,`tagger_type`),
  KEY `taggings_idy` (`taggable_id`,`taggable_type`,`tagger_id`,`context`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tags` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `taggings_count` int DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_tags_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tsl_leagues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tsl_leagues` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `generation` int NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tsl_leagues_on_generation` (`generation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tsl_memberships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tsl_memberships` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `league_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `result_key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '結果',
  `start_pos` int NOT NULL COMMENT '初期順位',
  `age` int DEFAULT NULL,
  `win` int DEFAULT NULL,
  `lose` int DEFAULT NULL,
  `ox` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `previous_runner_up_count` int NOT NULL COMMENT 'これまでの次点回数',
  `seat_count` int NOT NULL COMMENT 'これまでの在籍数',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_tsl_memberships_on_league_id_and_user_id` (`league_id`,`user_id`),
  KEY `index_tsl_memberships_on_league_id` (`league_id`),
  KEY `index_tsl_memberships_on_user_id` (`user_id`),
  KEY `index_tsl_memberships_on_result_key` (`result_key`),
  KEY `index_tsl_memberships_on_start_pos` (`start_pos`),
  KEY `index_tsl_memberships_on_win` (`win`),
  KEY `index_tsl_memberships_on_lose` (`lose`),
  KEY `index_tsl_memberships_on_previous_runner_up_count` (`previous_runner_up_count`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tsl_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tsl_users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `first_age` int DEFAULT NULL COMMENT 'リーグ入り年齢',
  `last_age` int DEFAULT NULL COMMENT 'リーグ最後の年齢',
  `memberships_count` int DEFAULT '0',
  `runner_up_count` int NOT NULL COMMENT '次点個数',
  `level_up_generation` int DEFAULT NULL COMMENT 'プロになった世代',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_tsl_users_on_name` (`name`),
  KEY `index_tsl_users_on_level_up_generation` (`level_up_generation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT 'キー',
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '名前',
  `race_key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '種族',
  `name_input_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `encrypted_password` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `reset_password_token` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int NOT NULL DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `confirmation_token` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `confirmation_sent_at` datetime DEFAULT NULL,
  `unconfirmed_email` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `failed_attempts` int NOT NULL DEFAULT '0',
  `unlock_token` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `locked_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_key` (`key`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`),
  UNIQUE KEY `index_users_on_confirmation_token` (`confirmation_token`),
  UNIQUE KEY `index_users_on_unlock_token` (`unlock_token`),
  KEY `index_users_on_race_key` (`race_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `wkbk_access_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wkbk_access_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL COMMENT '参照者',
  `book_id` bigint NOT NULL COMMENT '問題集',
  `created_at` datetime NOT NULL COMMENT '記録日時',
  PRIMARY KEY (`id`),
  KEY `index_wkbk_access_logs_on_user_id` (`user_id`),
  KEY `index_wkbk_access_logs_on_book_id` (`book_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `wkbk_answer_kinds`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wkbk_answer_kinds` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_wkbk_answer_kinds_on_key` (`key`),
  KEY `index_wkbk_answer_kinds_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `wkbk_answer_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wkbk_answer_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `article_id` bigint NOT NULL COMMENT '出題',
  `answer_kind_id` bigint NOT NULL COMMENT '解答',
  `book_id` bigint NOT NULL COMMENT '対戦部屋',
  `user_id` bigint NOT NULL COMMENT '自分',
  `spent_sec` int NOT NULL COMMENT '使用時間',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_wkbk_answer_logs_on_article_id` (`article_id`),
  KEY `index_wkbk_answer_logs_on_answer_kind_id` (`answer_kind_id`),
  KEY `index_wkbk_answer_logs_on_book_id` (`book_id`),
  KEY `index_wkbk_answer_logs_on_user_id` (`user_id`),
  KEY `index_wkbk_answer_logs_on_spent_sec` (`spent_sec`),
  KEY `index_wkbk_answer_logs_on_created_at` (`created_at`),
  CONSTRAINT `fk_rails_c2fb887f6e` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_d0ad6b6cc7` FOREIGN KEY (`answer_kind_id`) REFERENCES `wkbk_answer_kinds` (`id`),
  CONSTRAINT `fk_rails_eb31249ac9` FOREIGN KEY (`book_id`) REFERENCES `wkbk_books` (`id`),
  CONSTRAINT `fk_rails_fd4f2b6aef` FOREIGN KEY (`article_id`) REFERENCES `wkbk_articles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `wkbk_articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wkbk_articles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `user_id` bigint NOT NULL COMMENT '作成者',
  `folder_id` bigint NOT NULL COMMENT 'フォルダ',
  `lineage_id` bigint NOT NULL COMMENT '種類',
  `init_sfen` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '問題',
  `viewpoint` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '視点',
  `title` varchar(100) COLLATE utf8mb4_bin NOT NULL COMMENT 'タイトル',
  `description` text COLLATE utf8mb4_bin NOT NULL COMMENT '説明',
  `direction_message` varchar(100) COLLATE utf8mb4_bin NOT NULL COMMENT 'メッセージ',
  `turn_max` int NOT NULL COMMENT '最大手数',
  `mate_skip` tinyint(1) NOT NULL COMMENT '詰みチェックをスキップする',
  `moves_answers_count` int NOT NULL DEFAULT '0' COMMENT '解答数',
  `difficulty` int NOT NULL COMMENT '難易度',
  `answer_logs_count` int NOT NULL DEFAULT '0' COMMENT '解答数',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_wkbk_articles_on_key` (`key`),
  KEY `index_wkbk_articles_on_user_id` (`user_id`),
  KEY `index_wkbk_articles_on_folder_id` (`folder_id`),
  KEY `index_wkbk_articles_on_lineage_id` (`lineage_id`),
  KEY `index_wkbk_articles_on_init_sfen` (`init_sfen`),
  KEY `index_wkbk_articles_on_turn_max` (`turn_max`),
  KEY `index_wkbk_articles_on_difficulty` (`difficulty`),
  CONSTRAINT `fk_rails_7748a2a1da` FOREIGN KEY (`lineage_id`) REFERENCES `wkbk_lineages` (`id`),
  CONSTRAINT `fk_rails_819a1bdac0` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_aad2792528` FOREIGN KEY (`folder_id`) REFERENCES `wkbk_folders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `wkbk_books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wkbk_books` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `user_id` bigint NOT NULL COMMENT '作成者',
  `folder_id` bigint NOT NULL COMMENT 'フォルダ',
  `sequence_id` bigint NOT NULL COMMENT '順序',
  `title` varchar(100) COLLATE utf8mb4_bin NOT NULL COMMENT 'タイトル',
  `description` text COLLATE utf8mb4_bin NOT NULL COMMENT '説明',
  `bookships_count` int NOT NULL DEFAULT '0' COMMENT '記事数',
  `answer_logs_count` int NOT NULL DEFAULT '0' COMMENT '解答数',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `access_logs_count` int NOT NULL DEFAULT '0' COMMENT '総アクセス数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_wkbk_books_on_key` (`key`),
  KEY `index_wkbk_books_on_user_id` (`user_id`),
  KEY `index_wkbk_books_on_folder_id` (`folder_id`),
  KEY `index_wkbk_books_on_sequence_id` (`sequence_id`),
  KEY `index_wkbk_books_on_access_logs_count` (`access_logs_count`),
  CONSTRAINT `fk_rails_44fef78592` FOREIGN KEY (`folder_id`) REFERENCES `wkbk_folders` (`id`),
  CONSTRAINT `fk_rails_e41ea88b96` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_f6d4c81ca5` FOREIGN KEY (`sequence_id`) REFERENCES `wkbk_sequences` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `wkbk_bookships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wkbk_bookships` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL COMMENT '作成者',
  `book_id` bigint NOT NULL COMMENT '問題集',
  `article_id` bigint NOT NULL COMMENT '問題',
  `position` int NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_wkbk_bookships_on_book_id_and_article_id` (`book_id`,`article_id`),
  KEY `index_wkbk_bookships_on_user_id` (`user_id`),
  KEY `index_wkbk_bookships_on_book_id` (`book_id`),
  KEY `index_wkbk_bookships_on_article_id` (`article_id`),
  KEY `index_wkbk_bookships_on_position` (`position`),
  CONSTRAINT `fk_rails_086541430d` FOREIGN KEY (`book_id`) REFERENCES `wkbk_books` (`id`),
  CONSTRAINT `fk_rails_4606d8c214` FOREIGN KEY (`article_id`) REFERENCES `wkbk_articles` (`id`),
  CONSTRAINT `fk_rails_8f080017eb` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `wkbk_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wkbk_folders` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int NOT NULL,
  `books_count` int NOT NULL DEFAULT '0' COMMENT '問題集数',
  `articles_count` int NOT NULL DEFAULT '0' COMMENT '問題数',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_wkbk_folders_on_key` (`key`),
  KEY `index_wkbk_folders_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `wkbk_lineages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wkbk_lineages` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_wkbk_lineages_on_key` (`key`),
  KEY `index_wkbk_lineages_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `wkbk_moves_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wkbk_moves_answers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `article_id` bigint NOT NULL COMMENT '問題',
  `moves_count` int NOT NULL COMMENT 'N手',
  `moves_str` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT '連続した指し手',
  `moves_human_str` text CHARACTER SET utf8mb4 COLLATE utf8mb4_bin COMMENT '人間向け指し手',
  `position` int NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_wkbk_moves_answers_on_article_id` (`article_id`),
  KEY `index_wkbk_moves_answers_on_moves_count` (`moves_count`),
  KEY `index_wkbk_moves_answers_on_position` (`position`),
  CONSTRAINT `fk_rails_c8b1910065` FOREIGN KEY (`article_id`) REFERENCES `wkbk_articles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `wkbk_sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wkbk_sequences` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_wkbk_sequences_on_key` (`key`),
  KEY `index_wkbk_sequences_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `xsettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xsettings` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `var_key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `var_value` text COLLATE utf8mb4_bin,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_xsettings_on_var_key` (`var_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `xy_master_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xy_master_rules` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_xy_master_rules_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `xy_master_time_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `xy_master_time_records` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `rule_id` bigint NOT NULL COMMENT 'ルール',
  `entry_name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `summary` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `x_count` int NOT NULL,
  `spent_sec` float NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_xy_master_time_records_on_user_id` (`user_id`),
  KEY `index_xy_master_time_records_on_rule_id` (`rule_id`),
  KEY `index_xy_master_time_records_on_entry_name` (`entry_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

INSERT INTO `schema_migrations` (version) VALUES
('20250512000000'),
('20250401000070'),
('20250401000069'),
('20250401000068'),
('20250401000067'),
('20250308000066'),
('20250226000001'),
('20250226000000'),
('20250120000064'),
('20250120000063'),
('20241127000000'),
('20241121000000'),
('20241030000000'),
('20240819000061'),
('20240819000060'),
('20240818000005'),
('20240720300057'),
('20240720300056'),
('20240720300055'),
('20240720300054'),
('20240713000003'),
('20240710300051'),
('20240710000002'),
('20240710000001'),
('20240503000053'),
('20240503000052'),
('20240503000050'),
('20240503000047'),
('20240503000046'),
('20240503000044'),
('20240503000043'),
('20240503000042'),
('20240503000036'),
('20240503000035'),
('20240503000034'),
('20240503000033'),
('20240503000032'),
('20240503000031'),
('20240503000030'),
('20240503000009'),
('20240503000007'),
('20240503000006'),
('20240503000005'),
('20240503000004'),
('20240503000003'),
('20240503000002'),
('20240503000001'),
('20231217000003'),
('20231217000002'),
('20231126000004'),
('20231126000003'),
('20231122194851'),
('20231107000001'),
('20230916000001'),
('20230515000001'),
('20230326000001'),
('20230326000000'),
('20230324123144'),
('20221211000002'),
('20221211000001'),
('20221211000000'),
('20221210224516'),
('20221003152700'),
('20220528152700'),
('20220528135100'),
('20220528120100'),
('20220526170100'),
('20220524184701'),
('20220501150000'),
('20220501140000'),
('20220501130000'),
('20220501120000'),
('20220501110000'),
('20220416082500'),
('20211127151200'),
('20211107165600'),
('20211027075600'),
('20211010103000'),
('20210804111800'),
('20210708113128'),
('20210708113127'),
('20210307111420'),
('20210307111410'),
('20210307111409'),
('20210307111407'),
('20210307111406'),
('20210307111405'),
('20210307111404'),
('20210307111400'),
('20210304143001'),
('20210304082700'),
('20210215234700'),
('20201125220100'),
('20201107095900'),
('20200920154202'),
('20200701201700'),
('20200321005132'),
('20191115121600'),
('20190806151001'),
('20180712043012'),
('20180527071050'),
('20170211211100'),
('20170123115400'),
('20170113000000'),
('20151206160056'),
('20151206160055'),
('20151206160054'),
('20151206160053'),
('20151206160052'),
('20151206160051'),
('0');

