
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `actb_bad_marks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_bad_marks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '自分',
  `question_id` bigint(20) NOT NULL COMMENT '出題',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_actb_bad_marks_on_user_id_and_question_id` (`user_id`,`question_id`),
  KEY `index_actb_bad_marks_on_user_id` (`user_id`),
  KEY `index_actb_bad_marks_on_question_id` (`question_id`),
  CONSTRAINT `fk_rails_e94209d24a` FOREIGN KEY (`question_id`) REFERENCES `actb_questions` (`id`),
  CONSTRAINT `fk_rails_fb9ae7ace7` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_battle_memberships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_battle_memberships` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `battle_id` bigint(20) NOT NULL COMMENT '対戦',
  `user_id` bigint(20) NOT NULL COMMENT '対戦者',
  `judge_id` bigint(20) NOT NULL COMMENT '勝敗',
  `position` int(11) NOT NULL COMMENT '順序',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_actb_battle_memberships_on_battle_id_and_user_id` (`battle_id`,`user_id`),
  KEY `index_actb_battle_memberships_on_battle_id` (`battle_id`),
  KEY `index_actb_battle_memberships_on_user_id` (`user_id`),
  KEY `index_actb_battle_memberships_on_judge_id` (`judge_id`),
  KEY `index_actb_battle_memberships_on_position` (`position`),
  CONSTRAINT `fk_rails_a9252ecc65` FOREIGN KEY (`battle_id`) REFERENCES `actb_battles` (`id`),
  CONSTRAINT `fk_rails_ce5fbaef35` FOREIGN KEY (`judge_id`) REFERENCES `actb_judges` (`id`),
  CONSTRAINT `fk_rails_e3d6e9467c` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_battles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_battles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `room_id` bigint(20) NOT NULL COMMENT '部屋',
  `parent_id` bigint(20) DEFAULT NULL COMMENT '親',
  `rule_id` bigint(20) NOT NULL COMMENT 'ルール',
  `final_id` bigint(20) NOT NULL COMMENT '結果',
  `begin_at` datetime NOT NULL COMMENT '対戦開始日時',
  `end_at` datetime DEFAULT NULL COMMENT '対戦終了日時',
  `battle_pos` int(11) NOT NULL COMMENT '連戦インデックス',
  `practice` tinyint(1) DEFAULT NULL COMMENT '練習バトル？',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_battles_on_room_id` (`room_id`),
  KEY `index_actb_battles_on_parent_id` (`parent_id`),
  KEY `index_actb_battles_on_rule_id` (`rule_id`),
  KEY `index_actb_battles_on_final_id` (`final_id`),
  KEY `index_actb_battles_on_begin_at` (`begin_at`),
  KEY `index_actb_battles_on_end_at` (`end_at`),
  KEY `index_actb_battles_on_battle_pos` (`battle_pos`),
  CONSTRAINT `fk_rails_2017b49127` FOREIGN KEY (`parent_id`) REFERENCES `actb_battles` (`id`),
  CONSTRAINT `fk_rails_43bff87661` FOREIGN KEY (`rule_id`) REFERENCES `actb_rules` (`id`),
  CONSTRAINT `fk_rails_e180c154bd` FOREIGN KEY (`room_id`) REFERENCES `actb_rooms` (`id`),
  CONSTRAINT `fk_rails_e3dc358216` FOREIGN KEY (`final_id`) REFERENCES `actb_finals` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_clip_marks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_clip_marks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '自分',
  `question_id` bigint(20) NOT NULL COMMENT '出題',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_actb_clip_marks_on_user_id_and_question_id` (`user_id`,`question_id`),
  KEY `index_actb_clip_marks_on_user_id` (`user_id`),
  KEY `index_actb_clip_marks_on_question_id` (`question_id`),
  CONSTRAINT `fk_rails_9a652cb6d2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_e37a260859` FOREIGN KEY (`question_id`) REFERENCES `actb_questions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_emotion_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_emotion_folders` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_emotion_folders_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_emotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_emotions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '所有者',
  `folder_id` bigint(20) NOT NULL COMMENT 'フォルダ',
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT 'トリガー名',
  `message` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '表示用伝言',
  `voice` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '発声用文言',
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_emotions_on_user_id` (`user_id`),
  KEY `index_actb_emotions_on_folder_id` (`folder_id`),
  KEY `index_actb_emotions_on_position` (`position`),
  CONSTRAINT `fk_rails_05e576eb2e` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_4abdd94cdf` FOREIGN KEY (`folder_id`) REFERENCES `actb_emotion_folders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_finals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_finals` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_finals_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_folders` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT 'for STI',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_actb_folders_on_type_and_user_id` (`type`,`user_id`),
  KEY `index_actb_folders_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_f1ac2d2586` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_good_marks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_good_marks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '自分',
  `question_id` bigint(20) NOT NULL COMMENT '出題',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_actb_good_marks_on_user_id_and_question_id` (`user_id`,`question_id`),
  KEY `index_actb_good_marks_on_user_id` (`user_id`),
  KEY `index_actb_good_marks_on_question_id` (`question_id`),
  CONSTRAINT `fk_rails_9040e4e864` FOREIGN KEY (`question_id`) REFERENCES `actb_questions` (`id`),
  CONSTRAINT `fk_rails_c33753ab28` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_histories` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '自分',
  `question_id` bigint(20) NOT NULL COMMENT '出題',
  `room_id` bigint(20) DEFAULT NULL COMMENT '対戦部屋',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `ox_mark_id` bigint(20) NOT NULL COMMENT '解答',
  PRIMARY KEY (`id`),
  KEY `index_actb_histories_on_user_id` (`user_id`),
  KEY `index_actb_histories_on_question_id` (`question_id`),
  KEY `index_actb_histories_on_room_id` (`room_id`),
  KEY `index_actb_histories_on_ox_mark_id` (`ox_mark_id`),
  CONSTRAINT `fk_rails_09aa60b90e` FOREIGN KEY (`room_id`) REFERENCES `actb_rooms` (`id`),
  CONSTRAINT `fk_rails_2856700a8b` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_4edf53cdf7` FOREIGN KEY (`question_id`) REFERENCES `actb_questions` (`id`),
  CONSTRAINT `fk_rails_ed732ff51a` FOREIGN KEY (`ox_mark_id`) REFERENCES `actb_ox_marks` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_judges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_judges` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_judges_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_lineages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_lineages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_lineages_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_lobby_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_lobby_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '対戦者',
  `body` varchar(512) COLLATE utf8mb4_bin NOT NULL COMMENT '発言',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_lobby_messages_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_1ce1f74320` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_main_xrecords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_main_xrecords` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '対戦者',
  `judge_id` bigint(20) NOT NULL COMMENT '直前の勝敗',
  `final_id` bigint(20) NOT NULL COMMENT '直前の結果',
  `battle_count` int(11) NOT NULL COMMENT '対戦数',
  `win_count` int(11) NOT NULL COMMENT '勝ち数',
  `lose_count` int(11) NOT NULL COMMENT '負け数',
  `win_rate` float NOT NULL COMMENT '勝率',
  `rating` float NOT NULL COMMENT 'レーティング',
  `rating_diff` float NOT NULL COMMENT '直近レーティング変化',
  `rating_max` float NOT NULL COMMENT 'レーティング(最大)',
  `straight_win_count` int(11) NOT NULL COMMENT '連勝数',
  `straight_lose_count` int(11) NOT NULL COMMENT '連敗数',
  `straight_win_max` int(11) NOT NULL COMMENT '連勝数(最大)',
  `straight_lose_max` int(11) NOT NULL COMMENT '連敗数(最大)',
  `skill_id` bigint(20) NOT NULL COMMENT 'ウデマエ',
  `skill_point` float NOT NULL COMMENT 'ウデマエの内部ポイント',
  `skill_last_diff` float NOT NULL COMMENT '直近ウデマエ変化度',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `disconnect_count` int(11) NOT NULL COMMENT '切断数',
  `disconnected_at` datetime DEFAULT NULL COMMENT '最終切断日時',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_actb_main_xrecords_on_user_id` (`user_id`),
  KEY `index_actb_main_xrecords_on_judge_id` (`judge_id`),
  KEY `index_actb_main_xrecords_on_final_id` (`final_id`),
  KEY `index_actb_main_xrecords_on_battle_count` (`battle_count`),
  KEY `index_actb_main_xrecords_on_win_count` (`win_count`),
  KEY `index_actb_main_xrecords_on_lose_count` (`lose_count`),
  KEY `index_actb_main_xrecords_on_win_rate` (`win_rate`),
  KEY `index_actb_main_xrecords_on_rating` (`rating`),
  KEY `index_actb_main_xrecords_on_rating_diff` (`rating_diff`),
  KEY `index_actb_main_xrecords_on_rating_max` (`rating_max`),
  KEY `index_actb_main_xrecords_on_straight_win_count` (`straight_win_count`),
  KEY `index_actb_main_xrecords_on_straight_lose_count` (`straight_lose_count`),
  KEY `index_actb_main_xrecords_on_straight_win_max` (`straight_win_max`),
  KEY `index_actb_main_xrecords_on_straight_lose_max` (`straight_lose_max`),
  KEY `index_actb_main_xrecords_on_skill_id` (`skill_id`),
  KEY `index_actb_main_xrecords_on_disconnect_count` (`disconnect_count`),
  CONSTRAINT `fk_rails_2c8612bc12` FOREIGN KEY (`judge_id`) REFERENCES `actb_judges` (`id`),
  CONSTRAINT `fk_rails_338b4d60cc` FOREIGN KEY (`final_id`) REFERENCES `actb_finals` (`id`),
  CONSTRAINT `fk_rails_61a47067f6` FOREIGN KEY (`skill_id`) REFERENCES `actb_skills` (`id`),
  CONSTRAINT `fk_rails_84e93637da` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_moves_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_moves_answers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `question_id` bigint(20) NOT NULL COMMENT '問題',
  `moves_count` int(11) NOT NULL COMMENT 'N手',
  `moves_str` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '連続した指し手',
  `end_sfen` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '最後の局面',
  `moves_human_str` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '人間向け指し手',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_moves_answers_on_question_id` (`question_id`),
  KEY `index_actb_moves_answers_on_moves_count` (`moves_count`),
  CONSTRAINT `fk_rails_a356510439` FOREIGN KEY (`question_id`) REFERENCES `actb_questions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_notifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `question_message_id` bigint(20) NOT NULL COMMENT '問題コメント',
  `user_id` bigint(20) NOT NULL COMMENT '通知先',
  `opened_at` datetime DEFAULT NULL COMMENT '開封日時',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_notifications_on_question_message_id` (`question_message_id`),
  KEY `index_actb_notifications_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_35cb18483c` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_7bced87fe6` FOREIGN KEY (`question_message_id`) REFERENCES `actb_question_messages` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_ox_marks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_ox_marks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '正解・不正解',
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_ox_marks_on_key` (`key`),
  KEY `index_actb_ox_marks_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_ox_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_ox_records` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `question_id` bigint(20) NOT NULL COMMENT '問題',
  `o_count` int(11) NOT NULL COMMENT '正解数',
  `x_count` int(11) NOT NULL COMMENT '不正解数',
  `ox_total` int(11) NOT NULL COMMENT '出題数',
  `o_rate` float DEFAULT NULL COMMENT '高評価率',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_actb_ox_records_on_question_id` (`question_id`),
  KEY `index_actb_ox_records_on_o_count` (`o_count`),
  KEY `index_actb_ox_records_on_x_count` (`x_count`),
  KEY `index_actb_ox_records_on_ox_total` (`ox_total`),
  KEY `index_actb_ox_records_on_o_rate` (`o_rate`),
  CONSTRAINT `fk_rails_50b63a0f84` FOREIGN KEY (`question_id`) REFERENCES `actb_questions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_question_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_question_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '発言者',
  `question_id` bigint(20) NOT NULL COMMENT '問題',
  `body` varchar(512) COLLATE utf8mb4_bin NOT NULL COMMENT '発言',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_question_messages_on_user_id` (`user_id`),
  KEY `index_actb_question_messages_on_question_id` (`question_id`),
  CONSTRAINT `fk_rails_64c7c4a096` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_8bb8fd7f0a` FOREIGN KEY (`question_id`) REFERENCES `actb_questions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_questions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `user_id` bigint(20) NOT NULL COMMENT '作成者',
  `folder_id` bigint(20) NOT NULL COMMENT 'フォルダ',
  `lineage_id` bigint(20) NOT NULL COMMENT '種類',
  `init_sfen` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '問題',
  `time_limit_sec` int(11) DEFAULT NULL COMMENT '制限時間(秒)',
  `difficulty_level` int(11) DEFAULT NULL COMMENT '難易度',
  `title` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'タイトル',
  `description` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '説明',
  `hint_desc` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'ヒント',
  `source_author` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '作者',
  `source_media_name` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '出典メディア',
  `source_media_url` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '出典URL',
  `source_published_on` date DEFAULT NULL COMMENT '出典年月日',
  `source_about_id` bigint(20) DEFAULT NULL COMMENT '所在',
  `turn_max` int(11) DEFAULT NULL COMMENT '最大手数',
  `mate_skip` tinyint(1) DEFAULT NULL COMMENT '詰みチェックをスキップする',
  `direction_message` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'メッセージ',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `good_rate` float DEFAULT NULL COMMENT '高評価率',
  `moves_answers_count` int(11) NOT NULL DEFAULT '0' COMMENT '解答数',
  `histories_count` int(11) NOT NULL DEFAULT '0' COMMENT '履歴数(出題数とは異なる)',
  `good_marks_count` int(11) NOT NULL DEFAULT '0' COMMENT '高評価数',
  `bad_marks_count` int(11) NOT NULL DEFAULT '0' COMMENT '低評価数',
  `clip_marks_count` int(11) NOT NULL DEFAULT '0' COMMENT '保存された数',
  `messages_count` int(11) NOT NULL DEFAULT '0' COMMENT 'コメント数',
  PRIMARY KEY (`id`),
  KEY `index_actb_questions_on_key` (`key`),
  KEY `index_actb_questions_on_user_id` (`user_id`),
  KEY `index_actb_questions_on_folder_id` (`folder_id`),
  KEY `index_actb_questions_on_lineage_id` (`lineage_id`),
  KEY `index_actb_questions_on_init_sfen` (`init_sfen`),
  KEY `index_actb_questions_on_time_limit_sec` (`time_limit_sec`),
  KEY `index_actb_questions_on_difficulty_level` (`difficulty_level`),
  KEY `index_actb_questions_on_source_about_id` (`source_about_id`),
  KEY `index_actb_questions_on_turn_max` (`turn_max`),
  KEY `index_actb_questions_on_good_rate` (`good_rate`),
  KEY `index_actb_questions_on_histories_count` (`histories_count`),
  KEY `index_actb_questions_on_good_marks_count` (`good_marks_count`),
  KEY `index_actb_questions_on_bad_marks_count` (`bad_marks_count`),
  KEY `index_actb_questions_on_clip_marks_count` (`clip_marks_count`),
  KEY `index_actb_questions_on_messages_count` (`messages_count`),
  CONSTRAINT `fk_rails_243f259526` FOREIGN KEY (`source_about_id`) REFERENCES `actb_source_abouts` (`id`),
  CONSTRAINT `fk_rails_4c1f4628cc` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_f5a8dc663c` FOREIGN KEY (`lineage_id`) REFERENCES `actb_lineages` (`id`),
  CONSTRAINT `fk_rails_f941a04d67` FOREIGN KEY (`folder_id`) REFERENCES `actb_folders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_room_memberships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_room_memberships` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `room_id` bigint(20) NOT NULL COMMENT '対戦部屋',
  `user_id` bigint(20) NOT NULL COMMENT '対戦者',
  `position` int(11) NOT NULL COMMENT '順序',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_actb_room_memberships_on_room_id_and_user_id` (`room_id`,`user_id`),
  KEY `index_actb_room_memberships_on_room_id` (`room_id`),
  KEY `index_actb_room_memberships_on_user_id` (`user_id`),
  KEY `index_actb_room_memberships_on_position` (`position`),
  CONSTRAINT `fk_rails_98e1d257c4` FOREIGN KEY (`room_id`) REFERENCES `actb_rooms` (`id`),
  CONSTRAINT `fk_rails_bc78850729` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_room_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_room_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '対戦者',
  `room_id` bigint(20) NOT NULL COMMENT '対戦部屋',
  `body` varchar(512) COLLATE utf8mb4_bin NOT NULL COMMENT '発言',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_room_messages_on_user_id` (`user_id`),
  KEY `index_actb_room_messages_on_room_id` (`room_id`),
  CONSTRAINT `fk_rails_9b71b468e7` FOREIGN KEY (`room_id`) REFERENCES `actb_rooms` (`id`),
  CONSTRAINT `fk_rails_9d637ef76d` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_rooms` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `begin_at` datetime NOT NULL COMMENT '対戦開始日時',
  `end_at` datetime DEFAULT NULL COMMENT '対戦終了日時',
  `rule_id` bigint(20) NOT NULL COMMENT 'ルール',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `battles_count` int(11) NOT NULL DEFAULT '0' COMMENT '連戦数',
  `practice` tinyint(1) DEFAULT NULL COMMENT '練習バトル？',
  `bot_user_id` bigint(20) DEFAULT NULL COMMENT '練習相手',
  PRIMARY KEY (`id`),
  KEY `index_actb_rooms_on_begin_at` (`begin_at`),
  KEY `index_actb_rooms_on_end_at` (`end_at`),
  KEY `index_actb_rooms_on_rule_id` (`rule_id`),
  KEY `index_actb_rooms_on_battles_count` (`battles_count`),
  KEY `index_actb_rooms_on_bot_user_id` (`bot_user_id`),
  CONSTRAINT `fk_rails_4e7eff2ea3` FOREIGN KEY (`rule_id`) REFERENCES `actb_rules` (`id`),
  CONSTRAINT `fk_rails_ec99663ced` FOREIGN KEY (`bot_user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_rules` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_rules_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_season_xrecords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_season_xrecords` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `judge_id` bigint(20) NOT NULL COMMENT '直前の勝敗',
  `final_id` bigint(20) NOT NULL COMMENT '直前の結果',
  `battle_count` int(11) NOT NULL COMMENT '対戦数',
  `win_count` int(11) NOT NULL COMMENT '勝ち数',
  `lose_count` int(11) NOT NULL COMMENT '負け数',
  `win_rate` float NOT NULL COMMENT '勝率',
  `rating` float NOT NULL COMMENT 'レーティング',
  `rating_diff` float NOT NULL COMMENT '直近レーティング変化',
  `rating_max` float NOT NULL COMMENT 'レーティング(最大)',
  `straight_win_count` int(11) NOT NULL COMMENT '連勝数',
  `straight_lose_count` int(11) NOT NULL COMMENT '連敗数',
  `straight_win_max` int(11) NOT NULL COMMENT '連勝数(最大)',
  `straight_lose_max` int(11) NOT NULL COMMENT '連敗数(最大)',
  `skill_id` bigint(20) NOT NULL COMMENT 'ウデマエ',
  `skill_point` float NOT NULL COMMENT 'ウデマエの内部ポイント',
  `skill_last_diff` float NOT NULL COMMENT '直近ウデマエ変化度',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `disconnect_count` int(11) NOT NULL COMMENT '切断数',
  `disconnected_at` datetime DEFAULT NULL COMMENT '最終切断日時',
  `user_id` bigint(20) NOT NULL COMMENT '対戦者',
  `season_id` bigint(20) NOT NULL COMMENT '期',
  `create_count` int(11) NOT NULL COMMENT 'users.actb_season_xrecord.create_count は users.actb_season_xrecords.count と一致',
  `generation` int(11) NOT NULL COMMENT '世代(seasons.generationと一致)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_actb_season_xrecords_on_user_id_and_season_id` (`user_id`,`season_id`),
  KEY `index_actb_season_xrecords_on_judge_id` (`judge_id`),
  KEY `index_actb_season_xrecords_on_final_id` (`final_id`),
  KEY `index_actb_season_xrecords_on_battle_count` (`battle_count`),
  KEY `index_actb_season_xrecords_on_win_count` (`win_count`),
  KEY `index_actb_season_xrecords_on_lose_count` (`lose_count`),
  KEY `index_actb_season_xrecords_on_win_rate` (`win_rate`),
  KEY `index_actb_season_xrecords_on_rating` (`rating`),
  KEY `index_actb_season_xrecords_on_rating_diff` (`rating_diff`),
  KEY `index_actb_season_xrecords_on_rating_max` (`rating_max`),
  KEY `index_actb_season_xrecords_on_straight_win_count` (`straight_win_count`),
  KEY `index_actb_season_xrecords_on_straight_lose_count` (`straight_lose_count`),
  KEY `index_actb_season_xrecords_on_straight_win_max` (`straight_win_max`),
  KEY `index_actb_season_xrecords_on_straight_lose_max` (`straight_lose_max`),
  KEY `index_actb_season_xrecords_on_skill_id` (`skill_id`),
  KEY `index_actb_season_xrecords_on_disconnect_count` (`disconnect_count`),
  KEY `index_actb_season_xrecords_on_user_id` (`user_id`),
  KEY `index_actb_season_xrecords_on_season_id` (`season_id`),
  KEY `index_actb_season_xrecords_on_create_count` (`create_count`),
  KEY `index_actb_season_xrecords_on_generation` (`generation`),
  CONSTRAINT `fk_rails_14f0a157bc` FOREIGN KEY (`judge_id`) REFERENCES `actb_judges` (`id`),
  CONSTRAINT `fk_rails_41f6ac9d2e` FOREIGN KEY (`skill_id`) REFERENCES `actb_skills` (`id`),
  CONSTRAINT `fk_rails_b271444b65` FOREIGN KEY (`final_id`) REFERENCES `actb_finals` (`id`),
  CONSTRAINT `fk_rails_cd71661a89` FOREIGN KEY (`season_id`) REFERENCES `actb_seasons` (`id`),
  CONSTRAINT `fk_rails_e60abeb968` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_seasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_seasons` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT 'レーティング',
  `generation` int(11) NOT NULL COMMENT '世代',
  `begin_at` datetime NOT NULL COMMENT '期間開始日時',
  `end_at` datetime NOT NULL COMMENT '期間終了日時',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_seasons_on_generation` (`generation`),
  KEY `index_actb_seasons_on_begin_at` (`begin_at`),
  KEY `index_actb_seasons_on_end_at` (`end_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_settings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '自分',
  `rule_id` bigint(20) NOT NULL COMMENT '選択ルール',
  `session_lock_token` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '複数開いていてもSTARTを押したユーザーを特定できる超重要なトークン',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_settings_on_user_id` (`user_id`),
  KEY `index_actb_settings_on_rule_id` (`rule_id`),
  CONSTRAINT `fk_rails_036e1b3ba9` FOREIGN KEY (`rule_id`) REFERENCES `actb_rules` (`id`),
  CONSTRAINT `fk_rails_4f2ef941c3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_skills` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_skills_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_source_abouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_source_abouts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_source_abouts_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `actb_vs_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actb_vs_records` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `battle_id` bigint(20) NOT NULL COMMENT '対戦',
  `sfen_body` varchar(1536) COLLATE utf8mb4_bin NOT NULL COMMENT '棋譜',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_actb_vs_records_on_battle_id` (`battle_id`),
  CONSTRAINT `fk_rails_8ba1e4c013` FOREIGN KEY (`battle_id`) REFERENCES `actb_battles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `active_storage_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_storage_attachments` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `record_type` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `record_id` bigint(20) NOT NULL,
  `blob_id` bigint(20) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_active_storage_attachments_uniqueness` (`record_type`,`record_id`,`name`,`blob_id`),
  KEY `index_active_storage_attachments_on_blob_id` (`blob_id`),
  CONSTRAINT `fk_rails_c3b3935057` FOREIGN KEY (`blob_id`) REFERENCES `active_storage_blobs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `active_storage_blobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `active_storage_blobs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `content_type` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `metadata` text COLLATE utf8mb4_bin,
  `byte_size` bigint(20) NOT NULL,
  `checksum` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_active_storage_blobs_on_key` (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `alert_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert_logs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `subject` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `body` varchar(8192) COLLATE utf8mb4_bin NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_infos` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT 'ユーザー',
  `provider` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '何経由でログインしたか',
  `uid` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '長い内部ID(providerとペアではユニーク)',
  `meta_info` text COLLATE utf8mb4_bin COMMENT 'とれた情報をハッシュで持っとく用',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_auth_infos_on_provider_and_uid` (`provider`,`uid`),
  KEY `index_auth_infos_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cpu_battle_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cpu_battle_records` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL COMMENT 'ログインしているならそのユーザー',
  `judge_key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '結果',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_cpu_battle_records_on_user_id` (`user_id`),
  KEY `index_cpu_battle_records_on_judge_key` (`judge_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_bad_marks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_bad_marks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '自分',
  `question_id` bigint(20) NOT NULL COMMENT '出題',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_emox_bad_marks_on_user_id_and_question_id` (`user_id`,`question_id`),
  KEY `index_emox_bad_marks_on_user_id` (`user_id`),
  KEY `index_emox_bad_marks_on_question_id` (`question_id`),
  CONSTRAINT `fk_rails_628f595bb8` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_ab63a650ba` FOREIGN KEY (`question_id`) REFERENCES `emox_questions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_battle_memberships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_battle_memberships` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `battle_id` bigint(20) NOT NULL COMMENT '対戦',
  `user_id` bigint(20) NOT NULL COMMENT '対戦者',
  `judge_id` bigint(20) NOT NULL COMMENT '勝敗',
  `position` int(11) NOT NULL COMMENT '順序',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_emox_battle_memberships_on_battle_id_and_user_id` (`battle_id`,`user_id`),
  KEY `index_emox_battle_memberships_on_battle_id` (`battle_id`),
  KEY `index_emox_battle_memberships_on_user_id` (`user_id`),
  KEY `index_emox_battle_memberships_on_judge_id` (`judge_id`),
  KEY `index_emox_battle_memberships_on_position` (`position`),
  CONSTRAINT `fk_rails_7a3ee0482f` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_b21b7d16d2` FOREIGN KEY (`battle_id`) REFERENCES `emox_battles` (`id`),
  CONSTRAINT `fk_rails_d89e7b1bdc` FOREIGN KEY (`judge_id`) REFERENCES `emox_judges` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_battles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_battles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `room_id` bigint(20) NOT NULL COMMENT '部屋',
  `parent_id` bigint(20) DEFAULT NULL COMMENT '親',
  `rule_id` bigint(20) NOT NULL COMMENT 'ルール',
  `final_id` bigint(20) NOT NULL COMMENT '結果',
  `begin_at` datetime NOT NULL COMMENT '対戦開始日時',
  `end_at` datetime DEFAULT NULL COMMENT '対戦終了日時',
  `battle_pos` int(11) NOT NULL COMMENT '連戦インデックス',
  `practice` tinyint(1) DEFAULT NULL COMMENT '練習バトル？',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_battles_on_room_id` (`room_id`),
  KEY `index_emox_battles_on_parent_id` (`parent_id`),
  KEY `index_emox_battles_on_rule_id` (`rule_id`),
  KEY `index_emox_battles_on_final_id` (`final_id`),
  KEY `index_emox_battles_on_begin_at` (`begin_at`),
  KEY `index_emox_battles_on_end_at` (`end_at`),
  KEY `index_emox_battles_on_battle_pos` (`battle_pos`),
  CONSTRAINT `fk_rails_2ef3846e15` FOREIGN KEY (`parent_id`) REFERENCES `emox_battles` (`id`),
  CONSTRAINT `fk_rails_3bba30c60f` FOREIGN KEY (`final_id`) REFERENCES `emox_finals` (`id`),
  CONSTRAINT `fk_rails_c12d86d7b3` FOREIGN KEY (`room_id`) REFERENCES `emox_rooms` (`id`),
  CONSTRAINT `fk_rails_c25a0a91d1` FOREIGN KEY (`rule_id`) REFERENCES `emox_rules` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_clip_marks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_clip_marks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '自分',
  `question_id` bigint(20) NOT NULL COMMENT '出題',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_emox_clip_marks_on_user_id_and_question_id` (`user_id`,`question_id`),
  KEY `index_emox_clip_marks_on_user_id` (`user_id`),
  KEY `index_emox_clip_marks_on_question_id` (`question_id`),
  CONSTRAINT `fk_rails_045a5d4961` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_357276229f` FOREIGN KEY (`question_id`) REFERENCES `emox_questions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_emotion_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_emotion_folders` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_emotion_folders_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_emotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_emotions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '所有者',
  `folder_id` bigint(20) NOT NULL COMMENT 'フォルダ',
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT 'トリガー名',
  `message` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '表示用伝言',
  `voice` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '発声用文言',
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_emotions_on_user_id` (`user_id`),
  KEY `index_emox_emotions_on_folder_id` (`folder_id`),
  KEY `index_emox_emotions_on_position` (`position`),
  CONSTRAINT `fk_rails_1e7d82b920` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_de75e332bd` FOREIGN KEY (`folder_id`) REFERENCES `emox_emotion_folders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_finals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_finals` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_finals_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_folders` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT 'for STI',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_emox_folders_on_type_and_user_id` (`type`,`user_id`),
  KEY `index_emox_folders_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_0abb719ff9` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_good_marks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_good_marks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '自分',
  `question_id` bigint(20) NOT NULL COMMENT '出題',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_emox_good_marks_on_user_id_and_question_id` (`user_id`,`question_id`),
  KEY `index_emox_good_marks_on_user_id` (`user_id`),
  KEY `index_emox_good_marks_on_question_id` (`question_id`),
  CONSTRAINT `fk_rails_73832c4cb7` FOREIGN KEY (`question_id`) REFERENCES `emox_questions` (`id`),
  CONSTRAINT `fk_rails_aba0728484` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_histories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_histories` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '自分',
  `question_id` bigint(20) NOT NULL COMMENT '出題',
  `room_id` bigint(20) DEFAULT NULL COMMENT '対戦部屋',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `ox_mark_id` bigint(20) NOT NULL COMMENT '解答',
  PRIMARY KEY (`id`),
  KEY `index_emox_histories_on_user_id` (`user_id`),
  KEY `index_emox_histories_on_question_id` (`question_id`),
  KEY `index_emox_histories_on_room_id` (`room_id`),
  KEY `index_emox_histories_on_ox_mark_id` (`ox_mark_id`),
  CONSTRAINT `fk_rails_1f4a5de447` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_46e68d3b57` FOREIGN KEY (`room_id`) REFERENCES `emox_rooms` (`id`),
  CONSTRAINT `fk_rails_6105a40d6c` FOREIGN KEY (`ox_mark_id`) REFERENCES `emox_ox_marks` (`id`),
  CONSTRAINT `fk_rails_c584dc8d63` FOREIGN KEY (`question_id`) REFERENCES `emox_questions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_judges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_judges` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_judges_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_lineages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_lineages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_lineages_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_lobby_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_lobby_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '対戦者',
  `body` varchar(512) COLLATE utf8mb4_bin NOT NULL COMMENT '発言',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_lobby_messages_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_9d9ea13983` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_main_xrecords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_main_xrecords` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '対戦者',
  `judge_id` bigint(20) NOT NULL COMMENT '直前の勝敗',
  `final_id` bigint(20) NOT NULL COMMENT '直前の結果',
  `battle_count` int(11) NOT NULL COMMENT '対戦数',
  `win_count` int(11) NOT NULL COMMENT '勝ち数',
  `lose_count` int(11) NOT NULL COMMENT '負け数',
  `win_rate` float NOT NULL COMMENT '勝率',
  `rating` float NOT NULL COMMENT 'レーティング',
  `rating_diff` float NOT NULL COMMENT '直近レーティング変化',
  `rating_max` float NOT NULL COMMENT 'レーティング(最大)',
  `straight_win_count` int(11) NOT NULL COMMENT '連勝数',
  `straight_lose_count` int(11) NOT NULL COMMENT '連敗数',
  `straight_win_max` int(11) NOT NULL COMMENT '連勝数(最大)',
  `straight_lose_max` int(11) NOT NULL COMMENT '連敗数(最大)',
  `skill_id` bigint(20) NOT NULL COMMENT 'ウデマエ',
  `skill_point` float NOT NULL COMMENT 'ウデマエの内部ポイント',
  `skill_last_diff` float NOT NULL COMMENT '直近ウデマエ変化度',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `disconnect_count` int(11) NOT NULL COMMENT '切断数',
  `disconnected_at` datetime DEFAULT NULL COMMENT '最終切断日時',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_emox_main_xrecords_on_user_id` (`user_id`),
  KEY `index_emox_main_xrecords_on_judge_id` (`judge_id`),
  KEY `index_emox_main_xrecords_on_final_id` (`final_id`),
  KEY `index_emox_main_xrecords_on_battle_count` (`battle_count`),
  KEY `index_emox_main_xrecords_on_win_count` (`win_count`),
  KEY `index_emox_main_xrecords_on_lose_count` (`lose_count`),
  KEY `index_emox_main_xrecords_on_win_rate` (`win_rate`),
  KEY `index_emox_main_xrecords_on_rating` (`rating`),
  KEY `index_emox_main_xrecords_on_rating_diff` (`rating_diff`),
  KEY `index_emox_main_xrecords_on_rating_max` (`rating_max`),
  KEY `index_emox_main_xrecords_on_straight_win_count` (`straight_win_count`),
  KEY `index_emox_main_xrecords_on_straight_lose_count` (`straight_lose_count`),
  KEY `index_emox_main_xrecords_on_straight_win_max` (`straight_win_max`),
  KEY `index_emox_main_xrecords_on_straight_lose_max` (`straight_lose_max`),
  KEY `index_emox_main_xrecords_on_skill_id` (`skill_id`),
  KEY `index_emox_main_xrecords_on_disconnect_count` (`disconnect_count`),
  CONSTRAINT `fk_rails_4a4cb64494` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_86a3e6887a` FOREIGN KEY (`judge_id`) REFERENCES `emox_judges` (`id`),
  CONSTRAINT `fk_rails_b94164bd52` FOREIGN KEY (`skill_id`) REFERENCES `emox_skills` (`id`),
  CONSTRAINT `fk_rails_e7c15644f3` FOREIGN KEY (`final_id`) REFERENCES `emox_finals` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_moves_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_moves_answers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `question_id` bigint(20) NOT NULL COMMENT '問題',
  `moves_count` int(11) NOT NULL COMMENT 'N手',
  `moves_str` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '連続した指し手',
  `end_sfen` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '最後の局面',
  `moves_human_str` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '人間向け指し手',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_moves_answers_on_question_id` (`question_id`),
  KEY `index_emox_moves_answers_on_moves_count` (`moves_count`),
  CONSTRAINT `fk_rails_4f4c69d946` FOREIGN KEY (`question_id`) REFERENCES `emox_questions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_notifications` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `question_message_id` bigint(20) NOT NULL COMMENT '問題コメント',
  `user_id` bigint(20) NOT NULL COMMENT '通知先',
  `opened_at` datetime DEFAULT NULL COMMENT '開封日時',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_notifications_on_question_message_id` (`question_message_id`),
  KEY `index_emox_notifications_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_5dafc1ecf7` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_f07adeccdc` FOREIGN KEY (`question_message_id`) REFERENCES `emox_question_messages` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_ox_marks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_ox_marks` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '正解・不正解',
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_ox_marks_on_key` (`key`),
  KEY `index_emox_ox_marks_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_ox_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_ox_records` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `question_id` bigint(20) NOT NULL COMMENT '問題',
  `o_count` int(11) NOT NULL COMMENT '正解数',
  `x_count` int(11) NOT NULL COMMENT '不正解数',
  `ox_total` int(11) NOT NULL COMMENT '出題数',
  `o_rate` float DEFAULT NULL COMMENT '高評価率',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_emox_ox_records_on_question_id` (`question_id`),
  KEY `index_emox_ox_records_on_o_count` (`o_count`),
  KEY `index_emox_ox_records_on_x_count` (`x_count`),
  KEY `index_emox_ox_records_on_ox_total` (`ox_total`),
  KEY `index_emox_ox_records_on_o_rate` (`o_rate`),
  CONSTRAINT `fk_rails_11b1f62b22` FOREIGN KEY (`question_id`) REFERENCES `emox_questions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_question_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_question_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '発言者',
  `question_id` bigint(20) NOT NULL COMMENT '問題',
  `body` varchar(512) COLLATE utf8mb4_bin NOT NULL COMMENT '発言',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_question_messages_on_user_id` (`user_id`),
  KEY `index_emox_question_messages_on_question_id` (`question_id`),
  CONSTRAINT `fk_rails_b0c6e9ee5f` FOREIGN KEY (`question_id`) REFERENCES `emox_questions` (`id`),
  CONSTRAINT `fk_rails_d0f7c1686d` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_questions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `user_id` bigint(20) NOT NULL COMMENT '作成者',
  `folder_id` bigint(20) NOT NULL COMMENT 'フォルダ',
  `lineage_id` bigint(20) NOT NULL COMMENT '種類',
  `init_sfen` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '問題',
  `time_limit_sec` int(11) DEFAULT NULL COMMENT '制限時間(秒)',
  `difficulty_level` int(11) DEFAULT NULL COMMENT '難易度',
  `title` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'タイトル',
  `description` varchar(512) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '説明',
  `hint_desc` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'ヒント',
  `source_author` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '作者',
  `source_media_name` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '出典メディア',
  `source_media_url` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '出典URL',
  `source_published_on` date DEFAULT NULL COMMENT '出典年月日',
  `source_about_id` bigint(20) DEFAULT NULL COMMENT '所在',
  `turn_max` int(11) DEFAULT NULL COMMENT '最大手数',
  `mate_skip` tinyint(1) DEFAULT NULL COMMENT '詰みチェックをスキップする',
  `direction_message` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'メッセージ',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `good_rate` float DEFAULT NULL COMMENT '高評価率',
  `moves_answers_count` int(11) NOT NULL DEFAULT '0' COMMENT '解答数',
  `histories_count` int(11) NOT NULL DEFAULT '0' COMMENT '履歴数(出題数とは異なる)',
  `good_marks_count` int(11) NOT NULL DEFAULT '0' COMMENT '高評価数',
  `bad_marks_count` int(11) NOT NULL DEFAULT '0' COMMENT '低評価数',
  `clip_marks_count` int(11) NOT NULL DEFAULT '0' COMMENT '保存された数',
  `messages_count` int(11) NOT NULL DEFAULT '0' COMMENT 'コメント数',
  PRIMARY KEY (`id`),
  KEY `index_emox_questions_on_key` (`key`),
  KEY `index_emox_questions_on_user_id` (`user_id`),
  KEY `index_emox_questions_on_folder_id` (`folder_id`),
  KEY `index_emox_questions_on_lineage_id` (`lineage_id`),
  KEY `index_emox_questions_on_init_sfen` (`init_sfen`),
  KEY `index_emox_questions_on_time_limit_sec` (`time_limit_sec`),
  KEY `index_emox_questions_on_difficulty_level` (`difficulty_level`),
  KEY `index_emox_questions_on_source_about_id` (`source_about_id`),
  KEY `index_emox_questions_on_turn_max` (`turn_max`),
  KEY `index_emox_questions_on_good_rate` (`good_rate`),
  KEY `index_emox_questions_on_histories_count` (`histories_count`),
  KEY `index_emox_questions_on_good_marks_count` (`good_marks_count`),
  KEY `index_emox_questions_on_bad_marks_count` (`bad_marks_count`),
  KEY `index_emox_questions_on_clip_marks_count` (`clip_marks_count`),
  KEY `index_emox_questions_on_messages_count` (`messages_count`),
  CONSTRAINT `fk_rails_263239cde3` FOREIGN KEY (`lineage_id`) REFERENCES `emox_lineages` (`id`),
  CONSTRAINT `fk_rails_5861c2cbe1` FOREIGN KEY (`source_about_id`) REFERENCES `emox_source_abouts` (`id`),
  CONSTRAINT `fk_rails_8531cfdaeb` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_b87b51383c` FOREIGN KEY (`folder_id`) REFERENCES `emox_folders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_room_memberships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_room_memberships` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `room_id` bigint(20) NOT NULL COMMENT '対戦部屋',
  `user_id` bigint(20) NOT NULL COMMENT '対戦者',
  `position` int(11) NOT NULL COMMENT '順序',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_emox_room_memberships_on_room_id_and_user_id` (`room_id`,`user_id`),
  KEY `index_emox_room_memberships_on_room_id` (`room_id`),
  KEY `index_emox_room_memberships_on_user_id` (`user_id`),
  KEY `index_emox_room_memberships_on_position` (`position`),
  CONSTRAINT `fk_rails_cccbbf1fac` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_e89c90cffb` FOREIGN KEY (`room_id`) REFERENCES `emox_rooms` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_room_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_room_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '対戦者',
  `room_id` bigint(20) NOT NULL COMMENT '対戦部屋',
  `body` varchar(512) COLLATE utf8mb4_bin NOT NULL COMMENT '発言',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_room_messages_on_user_id` (`user_id`),
  KEY `index_emox_room_messages_on_room_id` (`room_id`),
  CONSTRAINT `fk_rails_16ea997c6d` FOREIGN KEY (`room_id`) REFERENCES `emox_rooms` (`id`),
  CONSTRAINT `fk_rails_b7eb8590b2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_rooms` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `begin_at` datetime NOT NULL COMMENT '対戦開始日時',
  `end_at` datetime DEFAULT NULL COMMENT '対戦終了日時',
  `rule_id` bigint(20) NOT NULL COMMENT 'ルール',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `battles_count` int(11) NOT NULL DEFAULT '0' COMMENT '連戦数',
  `practice` tinyint(1) DEFAULT NULL COMMENT '練習バトル？',
  `bot_user_id` bigint(20) DEFAULT NULL COMMENT '練習相手',
  PRIMARY KEY (`id`),
  KEY `index_emox_rooms_on_begin_at` (`begin_at`),
  KEY `index_emox_rooms_on_end_at` (`end_at`),
  KEY `index_emox_rooms_on_rule_id` (`rule_id`),
  KEY `index_emox_rooms_on_battles_count` (`battles_count`),
  KEY `index_emox_rooms_on_bot_user_id` (`bot_user_id`),
  CONSTRAINT `fk_rails_2f19240a81` FOREIGN KEY (`bot_user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_a20cf0d4cf` FOREIGN KEY (`rule_id`) REFERENCES `emox_rules` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_rules` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_rules_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_season_xrecords`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_season_xrecords` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `judge_id` bigint(20) NOT NULL COMMENT '直前の勝敗',
  `final_id` bigint(20) NOT NULL COMMENT '直前の結果',
  `battle_count` int(11) NOT NULL COMMENT '対戦数',
  `win_count` int(11) NOT NULL COMMENT '勝ち数',
  `lose_count` int(11) NOT NULL COMMENT '負け数',
  `win_rate` float NOT NULL COMMENT '勝率',
  `rating` float NOT NULL COMMENT 'レーティング',
  `rating_diff` float NOT NULL COMMENT '直近レーティング変化',
  `rating_max` float NOT NULL COMMENT 'レーティング(最大)',
  `straight_win_count` int(11) NOT NULL COMMENT '連勝数',
  `straight_lose_count` int(11) NOT NULL COMMENT '連敗数',
  `straight_win_max` int(11) NOT NULL COMMENT '連勝数(最大)',
  `straight_lose_max` int(11) NOT NULL COMMENT '連敗数(最大)',
  `skill_id` bigint(20) NOT NULL COMMENT 'ウデマエ',
  `skill_point` float NOT NULL COMMENT 'ウデマエの内部ポイント',
  `skill_last_diff` float NOT NULL COMMENT '直近ウデマエ変化度',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `disconnect_count` int(11) NOT NULL COMMENT '切断数',
  `disconnected_at` datetime DEFAULT NULL COMMENT '最終切断日時',
  `user_id` bigint(20) NOT NULL COMMENT '対戦者',
  `season_id` bigint(20) NOT NULL COMMENT '期',
  `create_count` int(11) NOT NULL COMMENT 'users.emox_season_xrecord.create_count は users.emox_season_xrecords.count と一致',
  `generation` int(11) NOT NULL COMMENT '世代(seasons.generationと一致)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_emox_season_xrecords_on_user_id_and_season_id` (`user_id`,`season_id`),
  KEY `index_emox_season_xrecords_on_judge_id` (`judge_id`),
  KEY `index_emox_season_xrecords_on_final_id` (`final_id`),
  KEY `index_emox_season_xrecords_on_battle_count` (`battle_count`),
  KEY `index_emox_season_xrecords_on_win_count` (`win_count`),
  KEY `index_emox_season_xrecords_on_lose_count` (`lose_count`),
  KEY `index_emox_season_xrecords_on_win_rate` (`win_rate`),
  KEY `index_emox_season_xrecords_on_rating` (`rating`),
  KEY `index_emox_season_xrecords_on_rating_diff` (`rating_diff`),
  KEY `index_emox_season_xrecords_on_rating_max` (`rating_max`),
  KEY `index_emox_season_xrecords_on_straight_win_count` (`straight_win_count`),
  KEY `index_emox_season_xrecords_on_straight_lose_count` (`straight_lose_count`),
  KEY `index_emox_season_xrecords_on_straight_win_max` (`straight_win_max`),
  KEY `index_emox_season_xrecords_on_straight_lose_max` (`straight_lose_max`),
  KEY `index_emox_season_xrecords_on_skill_id` (`skill_id`),
  KEY `index_emox_season_xrecords_on_disconnect_count` (`disconnect_count`),
  KEY `index_emox_season_xrecords_on_user_id` (`user_id`),
  KEY `index_emox_season_xrecords_on_season_id` (`season_id`),
  KEY `index_emox_season_xrecords_on_create_count` (`create_count`),
  KEY `index_emox_season_xrecords_on_generation` (`generation`),
  CONSTRAINT `fk_rails_6b43a8daac` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_8ae45fe675` FOREIGN KEY (`skill_id`) REFERENCES `emox_skills` (`id`),
  CONSTRAINT `fk_rails_99b1af5657` FOREIGN KEY (`season_id`) REFERENCES `emox_seasons` (`id`),
  CONSTRAINT `fk_rails_a99c79bb8a` FOREIGN KEY (`final_id`) REFERENCES `emox_finals` (`id`),
  CONSTRAINT `fk_rails_cc0f92d372` FOREIGN KEY (`judge_id`) REFERENCES `emox_judges` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_seasons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_seasons` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT 'レーティング',
  `generation` int(11) NOT NULL COMMENT '世代',
  `begin_at` datetime NOT NULL COMMENT '期間開始日時',
  `end_at` datetime NOT NULL COMMENT '期間終了日時',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_seasons_on_generation` (`generation`),
  KEY `index_emox_seasons_on_begin_at` (`begin_at`),
  KEY `index_emox_seasons_on_end_at` (`end_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_settings` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '自分',
  `rule_id` bigint(20) NOT NULL COMMENT '選択ルール',
  `session_lock_token` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '複数開いていてもSTARTを押したユーザーを特定できる超重要なトークン',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_settings_on_user_id` (`user_id`),
  KEY `index_emox_settings_on_rule_id` (`rule_id`),
  CONSTRAINT `fk_rails_2ddb432ed3` FOREIGN KEY (`rule_id`) REFERENCES `emox_rules` (`id`),
  CONSTRAINT `fk_rails_a5333674e3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_skills` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_skills_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_source_abouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_source_abouts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_source_abouts_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `emox_vs_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `emox_vs_records` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `battle_id` bigint(20) NOT NULL COMMENT '対戦',
  `sfen_body` varchar(1536) COLLATE utf8mb4_bin NOT NULL COMMENT '棋譜',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_emox_vs_records_on_battle_id` (`battle_id`),
  CONSTRAINT `fk_rails_d6513b4035` FOREIGN KEY (`battle_id`) REFERENCES `emox_battles` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `free_battles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `free_battles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL COMMENT 'URL識別子',
  `kifu_url` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '入力した棋譜URL',
  `title` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `kifu_body` mediumtext COLLATE utf8mb4_bin NOT NULL COMMENT '棋譜本文',
  `turn_max` int(11) NOT NULL COMMENT '手数',
  `meta_info` text COLLATE utf8mb4_bin NOT NULL COMMENT '棋譜メタ情報',
  `battled_at` datetime NOT NULL COMMENT '対局開始日時',
  `use_key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `accessed_at` datetime NOT NULL COMMENT '最終参照日時',
  `user_id` bigint(20) DEFAULT NULL,
  `preset_key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `description` text COLLATE utf8mb4_bin NOT NULL,
  `sfen_body` varchar(8192) COLLATE utf8mb4_bin NOT NULL,
  `sfen_hash` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `start_turn` int(11) DEFAULT NULL COMMENT '???',
  `critical_turn` int(11) DEFAULT NULL COMMENT '開戦',
  `outbreak_turn` int(11) DEFAULT NULL COMMENT '中盤',
  `image_turn` int(11) DEFAULT NULL COMMENT '???',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_free_battles_on_key` (`key`),
  KEY `index_free_battles_on_turn_max` (`turn_max`),
  KEY `index_free_battles_on_battled_at` (`battled_at`),
  KEY `index_free_battles_on_use_key` (`use_key`),
  KEY `index_free_battles_on_user_id` (`user_id`),
  KEY `index_free_battles_on_preset_key` (`preset_key`),
  KEY `index_free_battles_on_start_turn` (`start_turn`),
  KEY `index_free_battles_on_critical_turn` (`critical_turn`),
  KEY `index_free_battles_on_outbreak_turn` (`outbreak_turn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `profiles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT 'ユーザー',
  `description` varchar(512) COLLATE utf8mb4_bin NOT NULL COMMENT '自己紹介',
  `twitter_key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_profiles_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_battles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `swars_battles` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '対局識別子',
  `battled_at` datetime NOT NULL COMMENT '対局開始日時',
  `rule_key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT 'ルール',
  `csa_seq` text COLLATE utf8mb4_bin NOT NULL COMMENT '棋譜の断片',
  `final_key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '結果詳細',
  `win_user_id` bigint(20) DEFAULT NULL COMMENT '勝者(ショートカット用)',
  `turn_max` int(11) NOT NULL COMMENT '手数',
  `meta_info` text COLLATE utf8mb4_bin NOT NULL COMMENT '棋譜メタ情報',
  `accessed_at` datetime NOT NULL COMMENT '最終参照日時',
  `preset_key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `sfen_body` varchar(8192) COLLATE utf8mb4_bin NOT NULL,
  `sfen_hash` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `start_turn` int(11) DEFAULT NULL COMMENT '???',
  `critical_turn` int(11) DEFAULT NULL COMMENT '開戦',
  `outbreak_turn` int(11) DEFAULT NULL COMMENT '中盤',
  `image_turn` int(11) DEFAULT NULL COMMENT '???',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_swars_battles_on_key` (`key`),
  KEY `index_swars_battles_on_battled_at` (`battled_at`),
  KEY `index_swars_battles_on_rule_key` (`rule_key`),
  KEY `index_swars_battles_on_final_key` (`final_key`),
  KEY `index_swars_battles_on_win_user_id` (`win_user_id`),
  KEY `index_swars_battles_on_turn_max` (`turn_max`),
  KEY `index_swars_battles_on_preset_key` (`preset_key`),
  KEY `index_swars_battles_on_start_turn` (`start_turn`),
  KEY `index_swars_battles_on_critical_turn` (`critical_turn`),
  KEY `index_swars_battles_on_outbreak_turn` (`outbreak_turn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_crawl_reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `swars_crawl_reservations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '登録者',
  `target_user_key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '対象者',
  `to_email` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '完了通知先メールアドレス',
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
DROP TABLE IF EXISTS `swars_grades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `swars_grades` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `priority` int(11) NOT NULL COMMENT '優劣',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_swars_grades_on_key` (`key`),
  KEY `index_swars_grades_on_priority` (`priority`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_memberships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `swars_memberships` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `battle_id` bigint(20) NOT NULL COMMENT '対局',
  `user_id` bigint(20) NOT NULL COMMENT '対局者',
  `op_user_id` bigint(20) DEFAULT NULL COMMENT '相手',
  `grade_id` bigint(20) NOT NULL COMMENT '対局時の段級',
  `judge_key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '勝・敗・引き分け',
  `location_key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '▲△',
  `position` int(11) DEFAULT NULL COMMENT '手番の順序',
  `grade_diff` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `think_all_avg` int(11) DEFAULT NULL COMMENT '指し手の平均秒数(全体)',
  `think_end_avg` int(11) DEFAULT NULL COMMENT '指し手の平均秒数(最後5手)',
  `two_serial_max` int(11) DEFAULT NULL COMMENT '2秒の指し手が連続した回数',
  `think_last` int(11) DEFAULT NULL COMMENT '最後の指し手の秒数',
  `think_max` int(11) DEFAULT NULL COMMENT '最大考慮秒数',
  PRIMARY KEY (`id`),
  UNIQUE KEY `memberships_sbri_lk` (`battle_id`,`location_key`),
  UNIQUE KEY `memberships_sbri_sbui` (`battle_id`,`user_id`),
  UNIQUE KEY `memberships_bid_ouid` (`battle_id`,`op_user_id`),
  KEY `index_swars_memberships_on_battle_id` (`battle_id`),
  KEY `index_swars_memberships_on_user_id` (`user_id`),
  KEY `index_swars_memberships_on_op_user_id` (`op_user_id`),
  KEY `index_swars_memberships_on_grade_id` (`grade_id`),
  KEY `index_swars_memberships_on_judge_key` (`judge_key`),
  KEY `index_swars_memberships_on_location_key` (`location_key`),
  KEY `index_swars_memberships_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_search_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `swars_search_logs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT 'プレイヤー',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_swars_search_logs_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `swars_users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '対局者名',
  `grade_id` bigint(20) NOT NULL COMMENT '最高段級',
  `last_reception_at` datetime DEFAULT NULL COMMENT '受容日時',
  `search_logs_count` int(11) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_swars_users_on_user_key` (`user_key`),
  KEY `index_swars_users_on_grade_id` (`grade_id`),
  KEY `index_swars_users_on_last_reception_at` (`last_reception_at`),
  KEY `index_swars_users_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `swars_zip_dl_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `swars_zip_dl_logs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) NOT NULL COMMENT '登録者',
  `swars_user_id` bigint(20) NOT NULL COMMENT '対象者',
  `query` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT 'クエリ全体(予備)',
  `dl_count` int(11) NOT NULL COMMENT 'ダウンロード数(記録用)',
  `begin_at` datetime NOT NULL COMMENT 'スコープ(開始・記録用)',
  `end_at` datetime NOT NULL COMMENT 'スコープ(終了)',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_swars_zip_dl_logs_on_user_id` (`user_id`),
  KEY `index_swars_zip_dl_logs_on_swars_user_id` (`swars_user_id`),
  KEY `index_swars_zip_dl_logs_on_end_at` (`end_at`),
  CONSTRAINT `fk_rails_5edb845d8e` FOREIGN KEY (`swars_user_id`) REFERENCES `swars_users` (`id`),
  CONSTRAINT `fk_rails_ffe7d8a4c6` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `taggings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `taggings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag_id` int(11) DEFAULT NULL,
  `taggable_type` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `taggable_id` int(11) DEFAULT NULL,
  `tagger_type` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `tagger_id` int(11) DEFAULT NULL,
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL,
  `taggings_count` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_tags_on_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ts_master_questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ts_master_questions` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sfen` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `mate` int(11) NOT NULL,
  `position` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_ts_master_questions_on_mate_and_position` (`mate`,`position`),
  KEY `index_ts_master_questions_on_mate` (`mate`),
  KEY `index_ts_master_questions_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ts_master_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ts_master_rules` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ts_master_rules_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `ts_master_time_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ts_master_time_records` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `entry_name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `summary` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `rule_id` bigint(20) NOT NULL,
  `x_count` int(11) NOT NULL,
  `spent_sec` float NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_ts_master_time_records_on_user_id` (`user_id`),
  KEY `index_ts_master_time_records_on_entry_name` (`entry_name`),
  KEY `index_ts_master_time_records_on_rule_id` (`rule_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tsl_leagues`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tsl_leagues` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `generation` int(11) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_tsl_leagues_on_generation` (`generation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `tsl_memberships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tsl_memberships` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `league_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `result_key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '結果',
  `start_pos` int(11) NOT NULL COMMENT '初期順位',
  `age` int(11) DEFAULT NULL,
  `win` int(11) DEFAULT NULL,
  `lose` int(11) DEFAULT NULL,
  `ox` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `previous_runner_up_count` int(11) NOT NULL COMMENT 'これまでの次点回数',
  `seat_count` int(11) NOT NULL COMMENT 'これまでの在籍数',
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
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tsl_users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `first_age` int(11) DEFAULT NULL COMMENT 'リーグ入り年齢',
  `last_age` int(11) DEFAULT NULL COMMENT 'リーグ最後の年齢',
  `memberships_count` int(11) DEFAULT '0',
  `runner_up_count` int(11) NOT NULL COMMENT '次点個数',
  `level_up_generation` int(11) DEFAULT NULL COMMENT 'プロになった世代',
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_tsl_users_on_name` (`name`),
  KEY `index_tsl_users_on_level_up_generation` (`level_up_generation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT 'キー',
  `name` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '名前',
  `user_agent` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT 'ブラウザ情報',
  `race_key` varchar(255) COLLATE utf8mb4_bin NOT NULL COMMENT '種族',
  `name_input_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `encrypted_password` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `reset_password_token` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) NOT NULL DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `confirmation_token` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `confirmed_at` datetime DEFAULT NULL,
  `confirmation_sent_at` datetime DEFAULT NULL,
  `unconfirmed_email` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `failed_attempts` int(11) NOT NULL DEFAULT '0',
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
DROP TABLE IF EXISTS `xy_master_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xy_master_rules` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `key` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `position` int(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_xy_master_rules_on_position` (`position`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `xy_master_time_records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `xy_master_time_records` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) DEFAULT NULL,
  `rule_id` bigint(20) NOT NULL COMMENT 'ルール',
  `entry_name` varchar(255) COLLATE utf8mb4_bin NOT NULL,
  `summary` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `x_count` int(11) NOT NULL,
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
('20151206160051'),
('20151206160052'),
('20151206160053'),
('20151206160054'),
('20151206160055'),
('20151206160056'),
('20170113000000'),
('20170123115400'),
('20170211211100'),
('20180527071050'),
('20180712043012'),
('20190806151001'),
('20191115121600'),
('20200228142100'),
('20200321005132'),
('20200621164300'),
('20200701201700'),
('20200920154202'),
('20201103121300'),
('20201107095900'),
('20201125220100'),
('20201229171906');


