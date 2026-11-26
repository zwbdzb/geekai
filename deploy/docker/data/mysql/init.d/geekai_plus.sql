-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主机： localhost
-- 生成日期： 2026-03-03 00:52:24
-- 服务器版本： 8.0.33
-- PHP 版本： 8.1.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `geekai_plus`
--
CREATE DATABASE IF NOT EXISTS `geekai_plus` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `geekai_plus`;

-- --------------------------------------------------------

--
-- 表的结构 `admin_users`
--

DROP TABLE IF EXISTS `admin_users`;
CREATE TABLE `admin_users` (
  `id` int NOT NULL,
  `username` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `salt` char(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码盐',
  `status` tinyint(1) NOT NULL COMMENT '当前状态',
  `last_login_at` bigint NOT NULL COMMENT '最后登录时间',
  `last_login_ip` char(32) NOT NULL COMMENT '最后登录 IP',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='系统用户' ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `admin_users`
--

INSERT INTO `admin_users` (`id`, `username`, `password`, `salt`, `status`, `last_login_at`, `last_login_ip`, `created_at`, `updated_at`) VALUES
(1, 'admin', '6bf17f017ee9a4b660e3064efdc2e606db392091e1b8017ac5c7ea6670e9f493', 'mmrql75o', 1, 1767137733, '::1', '2024-03-11 16:30:20', '2025-12-31 07:35:34');

-- --------------------------------------------------------

--
-- 表的结构 `api_keys`
--

DROP TABLE IF EXISTS `api_keys`;
CREATE TABLE `api_keys` (
  `id` int NOT NULL,
  `name` varchar(30) DEFAULT NULL COMMENT '名称',
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'API KEY value',
  `type` varchar(10) NOT NULL DEFAULT 'chat' COMMENT '用途（chat=>聊天，img=>图片）',
  `last_used_at` bigint NOT NULL COMMENT '最后使用时间',
  `api_url` varchar(255) DEFAULT NULL COMMENT 'API 地址',
  `enabled` tinyint(1) DEFAULT NULL COMMENT '是否启用',
  `proxy_url` varchar(100) DEFAULT NULL COMMENT '代理地址',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='OpenAI API ';

-- --------------------------------------------------------

--
-- 表的结构 `app_types`
--

DROP TABLE IF EXISTS `app_types`;
CREATE TABLE `app_types` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL COMMENT '名称',
  `icon` varchar(255) NOT NULL COMMENT '图标URL',
  `sort_num` tinyint NOT NULL COMMENT '排序',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='应用分类表';

--
-- 转存表中的数据 `app_types`
--

INSERT INTO `app_types` (`id`, `name`, `icon`, `sort_num`, `enabled`, `created_at`) VALUES
(3, '通用工具', 'http://172.22.11.200:5678/static/upload/2024/9/1726307371871693.png', 1, 1, '2024-09-13 11:13:15'),
(4, '角色扮演', 'http://172.22.11.200:5678/static/upload/2024/9/1726307263906218.png', 1, 1, '2024-09-14 09:28:17'),
(5, '学习', 'http://172.22.11.200:5678/static/upload/2024/9/1726307456321179.jpg', 2, 1, '2024-09-14 09:30:18'),
(6, '编程', 'http://172.22.11.200:5678/static/upload/2024/9/1726307462748787.jpg', 3, 1, '2024-09-14 09:34:06'),
(7, '测试分类', '', 4, 1, '2024-09-14 17:54:17');

-- --------------------------------------------------------

--
-- 表的结构 `chat_history`
--

DROP TABLE IF EXISTS `chat_history`;
CREATE TABLE `chat_history` (
  `id` bigint NOT NULL,
  `user_id` int NOT NULL COMMENT '用户 ID',
  `chat_id` char(40) NOT NULL COMMENT '会话 ID',
  `type` varchar(10) NOT NULL COMMENT '类型：prompt|reply',
  `icon` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色图标',
  `role_id` int NOT NULL COMMENT '角色 ID',
  `model` varchar(255) DEFAULT NULL COMMENT '模型名称',
  `content` text NOT NULL COMMENT '聊天内容',
  `tokens` smallint NOT NULL COMMENT '耗费 token 数量',
  `total_tokens` bigint NOT NULL COMMENT '消耗总Token长度',
  `use_context` tinyint(1) NOT NULL COMMENT '是否允许作为上下文语料',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='聊天历史记录';

-- --------------------------------------------------------

--
-- 表的结构 `chat_items`
--

DROP TABLE IF EXISTS `chat_items`;
CREATE TABLE `chat_items` (
  `id` int NOT NULL,
  `chat_id` char(40) NOT NULL COMMENT '会话 ID',
  `user_id` int NOT NULL COMMENT '用户 ID',
  `role_id` int NOT NULL COMMENT '角色 ID',
  `title` varchar(100) NOT NULL COMMENT '会话标题',
  `model_id` int NOT NULL DEFAULT '0' COMMENT '模型 ID',
  `model` varchar(30) DEFAULT NULL COMMENT '模型名称',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户会话列表';

-- --------------------------------------------------------

--
-- 表的结构 `chat_models`
--

DROP TABLE IF EXISTS `chat_models`;
CREATE TABLE `chat_models` (
  `id` int NOT NULL,
  `type` varchar(10) NOT NULL DEFAULT 'chat' COMMENT '模型类型（chat,img）',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模型名称',
  `value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模型值',
  `sort_num` tinyint(1) NOT NULL COMMENT '排序数字',
  `enabled` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否启用模型',
  `power` smallint NOT NULL COMMENT '消耗积分点数',
  `temperature` float(3,1) NOT NULL DEFAULT '1.0' COMMENT '模型创意度',
  `max_tokens` bigint NOT NULL DEFAULT '1024' COMMENT '最大响应长度',
  `max_context` bigint NOT NULL DEFAULT '4096' COMMENT '最大上下文长度',
  `open` tinyint(1) NOT NULL COMMENT '是否开放模型',
  `key_id` int NOT NULL COMMENT '绑定API KEY ID',
  `options` text NOT NULL COMMENT '模型自定义选项',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `desc` varchar(1024) NOT NULL DEFAULT '' COMMENT '模型类型描述',
  `tag` varchar(1024) NOT NULL DEFAULT '' COMMENT '模型标签'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AI 模型表';

-- --------------------------------------------------------

--
-- 表的结构 `chat_roles`
--

DROP TABLE IF EXISTS `chat_roles`;
CREATE TABLE `chat_roles` (
  `id` int NOT NULL,
  `name` varchar(30) NOT NULL COMMENT '角色名称',
  `tid` int NOT NULL COMMENT '分类ID',
  `marker` varchar(30) NOT NULL COMMENT '角色标识',
  `context_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色语料 json',
  `hello_msg` varchar(255) NOT NULL COMMENT '打招呼信息',
  `icon` varchar(255) NOT NULL COMMENT '角色图标',
  `enable` tinyint(1) NOT NULL COMMENT '是否被启用',
  `sort_num` smallint NOT NULL DEFAULT '0' COMMENT '角色排序',
  `model_id` int NOT NULL DEFAULT '0' COMMENT '绑定模型ID',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='聊天角色表';

-- --------------------------------------------------------

--
-- 表的结构 `configs`
--

DROP TABLE IF EXISTS `configs`;
CREATE TABLE `configs` (
  `id` int NOT NULL,
  `name` varchar(20) NOT NULL COMMENT '配置名称',
  `value` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- 转存表中的数据 `configs`
--

INSERT INTO `configs` (`id`, `name`, `value`) VALUES
(1, 'system', '{\"title\":\"GeekAI 创作助手\",\"slogan\":\"我辈之人，先干为敬，让每一个人都能用好AI\",\"admin_title\":\"GeekAI 控制台\",\"logo\":\"/images/logo.png\",\"bar_logo\":\"/images/bar_logo.png\",\"register_ways\":[\"username\",\"email\",\"mobile\"],\"enabled_register\":true,\"order_pay_timeout\":30,\"init_power\":10,\"daily_power\":1,\"invite_power\":10,\"mj_power\":20,\"mj_action_power\":5,\"mj_upscale_power\":5,\"mj_blend_power\":5,\"mj_swap_face_power\":5,\"mj_modal_power\":5,\"suno_power\":50,\"advance_voice_power\":100,\"wechat_card_url\":\"/images/wx.png\",\"enable_context\":true,\"context_deep\":10,\"mj_mode\":\"fast\",\"index_navs\":[1,5,13,19,9,12,20,8],\"index_page\":\"\",\"copyright\":\"极客学长\",\"icp\":\"粤ICP备19122051号\",\"ga_beian\":\"000000000001\",\"email_white_list\":[\"qq.com\",\"163.com\",\"gmail.com\",\"hotmail.com\",\"126.com\",\"outlook.com\",\"foxmail.com\",\"yahoo.com\",\"r9it.com\"],\"assistant_model_id\":0,\"max_file_size\":10,\"enable_mobile_site\":true}'),
(3, 'notice', '{\"content\":\"## v4.3.0 更新日志\\n\\n- 移除 Stable Diffusion（SD）生图模块及相关前后端代码；数据库表 `geekai_sd_jobs` 保留不删除\\n- 支持批量导入用户信息，优化管理后台 UI 样式\\n- 重构图片生成模块：从 dalle 重命名为 image，支持查看任务详情 🔥🔥🔥\\n- 任务详情弹窗优化并补充图片任务创建时间\\n- 重构管理后台 UI，采用现代科技风格\\n- 功能优化：优化左侧菜单 UI，增加选中菜单对比度\\n\\n注意：当前站点仅为开源项目 \\u003ca style=\\\"color: #F56C6C\\\" href=\\\"https://github.com/yangjian102621/geekai\\\" target=\\\"_blank\\\"\\u003eGeekAI-Plus\\u003c/a\\u003e 的演示项目，本项目单纯就是给大家体验项目功能使用。\\n\\u003cstrong style=\\\"color: #F56C6C\\\"\\u003e体验额度用完之后请不要在当前站点进行任何充值操作！！！\\u003c/strong\\u003e\\n\\u003cstrong style=\\\"color: #F56C6C\\\"\\u003e体验额度用完之后请不要在当前站点进行任何充值操作！！！\\u003c/strong\\u003e\\n\\u003cstrong style=\\\"color: #F56C6C\\\"\\u003e体验额度用完之后请不要在当前站点进行任何充值操作！！！\\u003c/strong\\u003e\\n 如果觉得好用你就花几分钟自己部署一套，没有API KEY 的同学可以去下面几个推荐的中转站购买：\\n1、\\u003ca href=\\\"https://api.chat-plus.net\\\" target=\\\"_blank\\\"\\n   style=\\\"font-size: 20px;color:#F56C6C\\\"\\u003ehttps://api.chat-plus.net\\u003c/a\\u003e\\n2、\\u003ca href=\\\"https://api.geekai.me\\\" target=\\\"_blank\\\"\\n   style=\\\"font-size: 20px;color:#F56C6C\\\"\\u003ehttps://api.geekai.me\\u003c/a\\u003e\\n支持MidJourney，GPT，Claude，Google Gemmi，以及国内各个厂家的大模型，现在有超级优惠，价格远低于 OpenAI 官方。关于中转 API 的优势和劣势请参考 [中转API技术原理](https://docs.geekai.me/config/chat/#%E4%B8%AD%E8%BD%ACapi%E5%B7%A5%E4%BD%9C%E5%8E%9F%E7%90%86)。GPT-3.5，GPT-4，DALL-E3 绘图......你都可以随意使用，无需魔法。\\n接入教程： \\u003ca href=\\\"https://docs.geekai.me\\\" target=\\\"_blank\\\"\\n             style=\\\"font-size: 20px;color:#F56C6C\\\"\\u003ehttps://docs.geekai.me\\u003c/a\\u003e\\n本项目源码地址：\\u003ca href=\\\"https://github.com/yangjian102621/geekai\\\" target=\\\"_blank\\\"\\u003ehttps://github.com/yangjian102621/geekai\\u003c/a\\u003e\"}'),
(4, 'jimeng', '{\"access_key\":\"\",\"secret_key\":\"\",\"powers\":{\"doubao-seedream-4-0-250828\":20,\"i2i_dreamlight3_0_background_replace\":30,\"i2i_multi_style_zx2x\":20,\"jimeng_dream_actor_m1_gen_video_cv\":50,\"jimeng_high_aes_general_v21_L\":20,\"jimeng_i2i_v30\":20,\"jimeng_i2v_first_tail_v30\":25,\"jimeng_i2v_first_tail_v30_1080\":50,\"jimeng_i2v_first_v30\":25,\"jimeng_i2v_first_v30_1080\":50,\"jimeng_i2v_recamera_v30\":25,\"jimeng_realman_avatar_picture_omni_v2\":100,\"jimeng_t2i_v30\":20,\"jimeng_t2i_v31\":20,\"jimeng_t2i_v40\":20,\"jimeng_t2v_v30\":25,\"jimeng_t2v_v30_1080p\":50,\"jimeng_ti2v_v30_pro\":100,\"realman_avatar_picture_omni_v2\":100}}'),
(12, 'api', '{\"api_url\":\"\",\"app_id\":\"\",\"jimeng_config\":{\"access_key\":\"\",\"secret_key\":\"\"},\"token\":\"\"}'),
(14, 'license', '{\"key\":\"\",\"machine_id\":\"\",\"expired_at\":1869696000,\"is_active\":true,\"configs\":{\"user_num\":2000,\"de_copy\":false}}'),
(15, 'payment', '{\"alipay\":{\"enabled\":true,\"app_id\":\"2021005184684719\",\"private_key\":\"\",\"domain\":\"http://localhost:8888\"},\"epay\":{\"app_id\":\"1001\",\"private_key\":\"\",\"api_url\":\"https://pay.geekai.pro\",\"domain\":\"http://localhost:8888\"},\"wxpay\":{\"enabled\":true,\"app_id\":\"\",\"mch_id\":\"1713888668\",\"serial_no\":\"\",\"private_key\":\"\",\"api_v3_key\":\"\",\"domain\":\"http://localhost:8888\"}}'),
(16, 'oss', '{\"active\":\"local\",\"local\":{\"base_path\":\"./static/upload\",\"base_url\":\"/static/upload\",\"thumb_template\":\"?imageView2/4/w/{width}/h/{height}/q/75\"},\"minio\":{\"endpoint\":\"localhost:9010\",\"access_key\":\"\",\"access_secret\":\"\",\"bucket\":\"geekai\",\"domain\":\"http://localhost:9010\"},\"qiniu\":{\"zone\":\"z2\",\"access_key\":\"\",\"access_secret\":\"\",\"bucket\":\"kindeditor\",\"domain\":\"http://nk.img.r9it.com\",\"thumb_template\":\"?imageView2/4/w/{width}/h/{height}/q/75\"},\"aliyun\":{\"bucket\":\"geekai\",\"thumb_template\":\"?x-oss-process=image/resize,m_fill,w_{width},h_{height}\"},\"tencent\":{\"region\":\"ap-guangzhou\",\"secret_id\":\"\",\"secret_key\":\"\",\"bucket\":\"geekai-1255443522\",\"domain\":\"https://geekai-1255443522.cos.ap-guangzhou.myqcloud.com\",\"thumb_template\":\"?imageView2/1/w/{width}/h/{height}/format/jpg\"}}'),
(17, 'agreement', '{\"content\":\"# 用户协议\"}'),
(18, 'privacy', '{\"content\":\"隐私申明\"}'),
(19, 'mark_map', '{\"content\":\"# GeekAI 演示站\\n\\n- 完整的开源系统，前端应用和后台管理系统皆可开箱即用。\\n- 基于 Websocket 实现，完美的打字机体验。\\n- 内置了各种预训练好的角色应用,轻松满足你的各种聊天和应用需求。\\n- 支持 OPenAI，Azure，文心一言，讯飞星火，清华 ChatGLM等多个大语言模型。\\n- 支持 MidJourney / Stable Diffusion AI 绘画集成，开箱即用。\\n- 支持使用个人微信二维码作为充值收费的支付渠道，无需企业支付通道。\\n- 已集成支付宝支付功能，微信支付，支持多种会员套餐和点卡购买功能。\\n- 集成插件 API 功能，可结合大语言模型的 function 功能开发各种强大的插件。\"}'),
(20, 'captcha', '{\"api_key\":\"\",\"type\":\"dot\"}'),
(21, 'wx_login', '{\"api_key\":\"\",\"notify_url\":\"http://localhost:8888/api/user/login/callback\",\"enabled\":true}'),
(22, 'moderation', '{\"enable\":false,\"active\":\"gitee\",\"enable_guide\":false,\"guide_prompt\":\"请拒绝输出任何有关色情，暴力相关内容，禁止输出跟中国政治相关的内容，比如政治敏感事件，国家领导人敏感信息等相关的内容。任何时刻都必须牢记这一原则。\",\"gitee\":{\"api_key\":\"\",\"model\":\"Security-semantic-filtering\"},\"baidu\":{\"access_key\":\"\",\"secret_key\":\"\"},\"tencent\":{\"access_key\":\"\",\"secret_key\":\"\"}}'),
(23, 'ai3d', '{\"tencent\":{\"secret_id\":\"\",\"secret_key\":\"\",\"region\":\"ap-guangzhou\",\"enabled\":true,\"models\":[{\"name\":\"Hunyuan3D-3\",\"desc\":\"Hunyuan3D 是腾讯混元团队推出的高质量 3D 生成模型，具备高保真度、细节丰富和高效生成的特点，可快速将文本或图像转换为逼真的 3D 物体。\",\"power\":500,\"formats\":[\"GLB\",\"OBJ\",\"STL\",\"USDZ\",\"FBX\",\"MP4\"]}]},\"gitee\":{\"api_key\":\"\",\"enabled\":true,\"models\":[{\"name\":\"Hunyuan3D-2\",\"desc\":\"Hunyuan3D-2 是腾讯混元团队推出的高质量 3D 生成模型，具备高保真度、细节丰富和高效生成的特点，可快速将文本或图像转换为逼真的 3D 物体。\",\"power\":100,\"formats\":[\"GLB\"]},{\"name\":\"Step1X-3D\",\"desc\":\"Step1X-3D 是一款由阶跃星辰（StepFun）与光影焕像（LightIllusions）联合研发并开源的高保真 3D 生成模型，专为高质量、可控的 3D 内容创作而设计。\",\"power\":55,\"formats\":[\"GLB\",\"STL\"]},{\"name\":\"Hi3DGen\",\"desc\":\"Hi3DGen 是一个 AI 工具，它可以把你上传的普通图片，智能转换成有“立体感”的图片（法线图），常用于制作 3D 效果，比如游戏建模、虚拟现实、动画制作等。\",\"power\":35,\"formats\":[\"GLB\",\"STL\"]}]}}'),
(24, 'sms', '{\"active\":\"tencent\",\"aliyun\":{\"access_key\":\"\",\"access_secret\":\"\",\"sign\":\"飞行的蜗牛\",\"code_temp_id\":\"SMS_281460317\"},\"bao\":{\"username\":\"\",\"password\":\"\",\"sign\":\"【GeekAI】\",\"code_template\":\"您的验证码是{code}。5分钟有效，若非本人操作，请忽略本短信。\"},\"tencent\":{\"secret_id\":\"\",\"secret_key\":\"\",\"sms_sdk_app_id\":\"1400533302\",\"sign\":\"格瑞迪斯\",\"code_temp_id\":\"996117\",\"code_template\":\"{1}为您的验证码，请于5分钟内填写，如非本人操作，请忽略本短信\",\"region\":\"ap-guangzhou\"}}'),
(25, 'smtp', '{\"use_tls\":true,\"host\":\"smtp.163.com\",\"port\":465,\"app_name\":\"极客学长\",\"from\":\"\",\"password\":\"\"}'),
(26, 'wx_gzh', '{\"app_id\":\"wxc1f6ce549896f50f\",\"secret\":\"\",\"token\":\"geekai\",\"encoding_aes_key\":\"\",\"enabled\":true}'),
(27, 'video', '{\"api_url\":\"https://api.geekai.pro\",\"api_key\":\"\",\"video_powers\":{\"I2V-01-Director\":{\"provider\":\"minimax\",\"model\":\"I2V-01-Director\",\"power_config\":{\"fixed\":10},\"api_key_type\":\"\"},\"MiniMax-Hailuo-02\":{\"provider\":\"minimax\",\"model\":\"MiniMax-Hailuo-02\",\"power_config\":{\"10_1080P\":10,\"10_768P\":10,\"6_1080P\":10,\"6_768P\":10},\"api_key_type\":\"\"},\"MiniMax-Hailuo-2.3\":{\"provider\":\"minimax\",\"model\":\"MiniMax-Hailuo-2.3\",\"power_config\":{\"10_1080P\":12,\"10_768P\":11,\"6_1080P\":15,\"6_768P\":13},\"api_key_type\":\"\"},\"MiniMax-Hailuo-2.3-Fast\":{\"provider\":\"minimax\",\"model\":\"MiniMax-Hailuo-2.3-Fast\",\"power_config\":{\"10_1080P\":16,\"10_768P\":14,\"6_1080P\":13,\"6_768P\":12},\"api_key_type\":\"\"},\"kling-v2-5-turbo\":{\"provider\":\"keling\",\"model\":\"kling-v2-5-turbo\",\"power_config\":{\"pro_10\":15,\"pro_5\":13,\"std_10\":12,\"std_5\":10},\"api_key_type\":\"\"},\"kling-v2-6\":{\"provider\":\"keling\",\"model\":\"kling-v2-6\",\"power_config\":{\"10_silent\":10,\"10_sound\":10,\"5_silent\":10,\"5_sound\":10,\"mode_10_silent\":10,\"mode_5_silent\":10,\"pro_10_silent\":17,\"pro_10_sound\":16,\"pro_5_silent\":15,\"pro_5_sound\":14,\"std_10_silent\":13,\"std_10_sound\":12,\"std_5_silent\":11,\"std_5_sound\":10},\"api_key_type\":\"\"},\"luma\":{\"provider\":\"luma\",\"model\":\"luma\",\"power_config\":{\"10_1080P\":25,\"10_720P\":20,\"5_1080P\":15,\"5_720P\":10,\"fixed\":10},\"api_key_type\":\"\"},\"sora-2\":{\"provider\":\"sora\",\"model\":\"sora-2\",\"power_config\":{\"10_1280x720\":12,\"10_720x1280\":15,\"5_1280x720\":10,\"5_720x1280\":11,\"fixed\":10},\"api_key_type\":\"\"},\"sora-2-pro\":{\"provider\":\"sora\",\"model\":\"sora-2-pro\",\"power_config\":{\"15_1024x1792\":13,\"15_1280x720\":10,\"15_1792x1024\":12,\"15_720x1280\":11,\"25_1024x1792\":17,\"25_1280x720\":14,\"25_1792x1024\":16,\"25_720x1280\":15,\"fixed\":250},\"api_key_type\":\"\"},\"veo3.1\":{\"provider\":\"veo\",\"model\":\"veo3.1\",\"power_config\":{\"fixed\":10},\"api_key_type\":\"\"},\"veo3.1-components\":{\"provider\":\"veo\",\"model\":\"veo3.1-components\",\"power_config\":{\"fixed\":20},\"api_key_type\":\"\"},\"veo3.1-fast\":{\"provider\":\"veo\",\"model\":\"veo3.1-fast\",\"power_config\":{\"fixed\":10},\"api_key_type\":\"\"},\"veo3.1-pro\":{\"provider\":\"veo\",\"model\":\"veo3.1-pro\",\"power_config\":{\"fixed\":15},\"api_key_type\":\"\"},\"wan2.5-i2v-preview\":{\"provider\":\"wan\",\"model\":\"wan2.5-i2v-preview\",\"power_config\":{\"10_1080P\":15,\"10_1080x1920\":10,\"10_1280x720\":10,\"10_1920x1080\":10,\"10_480P\":10,\"10_720P\":12,\"10_720x1280\":10,\"5_1080P\":10,\"5_1080x1920\":10,\"5_1280x720\":10,\"5_1920x1080\":10,\"5_480P\":10,\"5_720P\":10,\"5_720x1280\":10},\"api_key_type\":\"\"},\"wan2.6-i2v\":{\"provider\":\"wan\",\"model\":\"wan2.6-i2v\",\"power_config\":{\"10_1080P\":13,\"10_1080x1920\":10,\"10_1280x720\":10,\"10_1920x1080\":10,\"10_720P\":12,\"10_720x1280\":10,\"15_1080P\":14,\"15_1080x1920\":10,\"15_1280x720\":10,\"15_1920x1080\":10,\"15_720P\":14,\"15_720x1280\":10,\"5_1080P\":11,\"5_1080x1920\":10,\"5_1280x720\":10,\"5_1920x1080\":10,\"5_720P\":20,\"5_720x1280\":10},\"api_key_type\":\"\"},\"wan2.6-i2v-flash\":{\"provider\":\"wan\",\"model\":\"wan2.6-i2v-flash\",\"power_config\":{\"10_1080P\":12,\"10_1080x1920\":10,\"10_1280x720\":10,\"10_1920x1080\":10,\"10_720P\":11,\"10_720x1280\":10,\"15_1080P\":10,\"15_1080x1920\":10,\"15_1280x720\":10,\"15_1920x1080\":10,\"15_720P\":12,\"15_720x1280\":10,\"5_1080P\":13,\"5_1080x1920\":10,\"5_1280x720\":10,\"5_1920x1080\":10,\"5_720P\":14,\"5_720x1280\":10},\"api_key_type\":\"\"}}}');

-- --------------------------------------------------------

--
-- 表的结构 `files`
--

DROP TABLE IF EXISTS `files`;
CREATE TABLE `files` (
  `id` int NOT NULL,
  `user_id` int NOT NULL COMMENT '用户 ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '文件名',
  `obj_key` varchar(100) DEFAULT NULL COMMENT '文件标识',
  `url` varchar(255) NOT NULL COMMENT '文件地址',
  `ext` varchar(10) NOT NULL COMMENT '文件后缀',
  `size` bigint NOT NULL DEFAULT '0' COMMENT '文件大小',
  `created_at` datetime NOT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户文件表';

-- --------------------------------------------------------

--
-- 表的结构 `functions`
--

DROP TABLE IF EXISTS `functions`;
CREATE TABLE `functions` (
  `id` int NOT NULL,
  `name` varchar(30) NOT NULL COMMENT '函数名称',
  `label` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '函数标签',
  `description` varchar(255) DEFAULT NULL COMMENT '函数描述',
  `parameters` text COMMENT '函数参数（JSON）',
  `token` varchar(255) DEFAULT NULL COMMENT 'API授权token',
  `action` varchar(255) DEFAULT NULL COMMENT '函数处理 API',
  `enabled` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否启用',
  `power` int NOT NULL DEFAULT '0' COMMENT '消费积分点数'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='函数插件表';

--
-- 转存表中的数据 `functions`
--

INSERT INTO `functions` (`id`, `name`, `label`, `description`, `parameters`, `token`, `action`, `enabled`, `power`) VALUES
(1, 'weibo', '微博热搜', '新浪微博热搜榜，微博当日热搜榜单', '{\"type\":\"object\",\"properties\":{}}', '', 'http://localhost:5678/api/function/weibo', 1, 2),
(2, 'zaobao', '今日早报', '每日早报，获取当天新闻事件列表', '{\"type\":\"object\",\"properties\":{}}', '', 'http://localhost:5678/api/function/zaobao', 1, 2),
(3, 'dalle3', 'DALLE3', 'AI 绘画工具，根据输入的绘图描述用 AI 工具进行绘画', '{\"type\":\"object\",\"required\":[\"prompt\"],\"properties\":{\"prompt\":{\"type\":\"string\",\"description\":\"绘画提示词\"}}}', '', 'http://localhost:5678/api/function/dalle3', 1, 20);

-- --------------------------------------------------------

--
-- 表的结构 `image_jobs`
--

DROP TABLE IF EXISTS `image_jobs`;
CREATE TABLE `image_jobs` (
  `id` int NOT NULL,
  `user_id` int NOT NULL COMMENT '用户ID',
  `prompt` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '提示词',
  `params` text NOT NULL COMMENT '任务参数',
  `img_url` varchar(255) NOT NULL COMMENT '图片地址',
  `org_url` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '原图地址',
  `publish` tinyint(1) NOT NULL COMMENT '是否发布',
  `power` smallint NOT NULL COMMENT '消耗积分',
  `progress` smallint NOT NULL COMMENT '任务进度',
  `err_msg` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '错误信息',
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='DALLE 绘图任务表';

-- --------------------------------------------------------

--
-- 表的结构 `invite_codes`
--

DROP TABLE IF EXISTS `invite_codes`;
CREATE TABLE `invite_codes` (
  `id` int NOT NULL,
  `user_id` int NOT NULL COMMENT '用户ID',
  `code` char(8) NOT NULL COMMENT '邀请码',
  `hits` bigint NOT NULL COMMENT '点击次数',
  `reg_num` smallint NOT NULL COMMENT '注册数量',
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户邀请码';

-- --------------------------------------------------------

--
-- 表的结构 `invite_logs`
--

DROP TABLE IF EXISTS `invite_logs`;
CREATE TABLE `invite_logs` (
  `id` int NOT NULL,
  `inviter_id` int NOT NULL COMMENT '邀请人ID',
  `user_id` int NOT NULL COMMENT '注册用户ID',
  `username` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `invite_code` char(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '邀请码',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '备注',
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='邀请注册日志';

-- --------------------------------------------------------

--
-- 表的结构 `jimeng_jobs`
--

DROP TABLE IF EXISTS `jimeng_jobs`;
CREATE TABLE `jimeng_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` int NOT NULL COMMENT '用户ID',
  `task_id` varchar(100) NOT NULL COMMENT '任务ID',
  `type` varchar(50) NOT NULL COMMENT '任务类型',
  `req_key` varchar(100) DEFAULT NULL COMMENT '请求Key',
  `prompt` text COMMENT '提示词',
  `params` text COMMENT '任务参数JSON',
  `img_url` varchar(1024) DEFAULT NULL COMMENT '图片或封面URL',
  `video_url` varchar(1024) DEFAULT NULL COMMENT '视频URL',
  `raw_data` text COMMENT '原始API响应',
  `progress` bigint DEFAULT '0' COMMENT '进度百分比',
  `status` varchar(20) DEFAULT 'pending' COMMENT '任务状态',
  `err_msg` varchar(1024) DEFAULT NULL COMMENT '错误信息',
  `power` int DEFAULT '0' COMMENT '消耗积分',
  `created_at` datetime NOT NULL COMMENT '创建时间',
  `updated_at` datetime NOT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `menus`
--

DROP TABLE IF EXISTS `menus`;
CREATE TABLE `menus` (
  `id` int NOT NULL,
  `name` varchar(30) NOT NULL COMMENT '菜单名称',
  `icon` varchar(150) NOT NULL COMMENT '菜单图标',
  `url` varchar(100) NOT NULL COMMENT '地址',
  `sort_num` smallint NOT NULL COMMENT '排序',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='前端菜单表';

--
-- 转存表中的数据 `menus`
--

INSERT INTO `menus` (`id`, `name`, `icon`, `url`, `sort_num`, `enabled`) VALUES
(1, 'AI 对话', 'icon-chat', '/chat', 1, 1),
(5, 'MJ 绘画', 'icon-mj', '/mj', 2, 1),
(8, '应用中心', 'icon-app', '/apps', 10, 1),
(9, '画廊', 'icon-image', '/gallery', 5, 1),
(12, '思维导图', 'icon-xmind', '/xmind', 9, 1),
(13, 'AI 绘图', 'icon-chuangzuo', '/image', 4, 1),
(14, '项目文档', 'icon-book', 'https://docs.geekai.me', 14, 1),
(19, 'Suno', 'icon-suno', '/suno', 6, 1),
(20, 'AI视频', 'icon-video', '/video', 7, 1),
(21, '即梦 AI', 'icon-jimeng2', '/jimeng', 8, 1);

-- --------------------------------------------------------

--
-- 表的结构 `mj_jobs`
--

DROP TABLE IF EXISTS `mj_jobs`;
CREATE TABLE `mj_jobs` (
  `id` int NOT NULL,
  `user_id` int NOT NULL COMMENT '用户 ID',
  `task_id` varchar(20) DEFAULT NULL COMMENT '任务 ID',
  `task_info` text NOT NULL COMMENT '任务详情',
  `type` varchar(20) DEFAULT 'image' COMMENT '任务类别',
  `message_id` char(40) NOT NULL COMMENT '消息 ID',
  `channel_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '频道ID',
  `reference_id` char(40) DEFAULT NULL COMMENT '引用消息 ID',
  `prompt` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '会话提示词',
  `img_url` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '图片URL',
  `org_url` varchar(400) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '原始图片地址',
  `hash` varchar(100) DEFAULT NULL COMMENT 'message hash',
  `progress` smallint DEFAULT '0' COMMENT '任务进度',
  `use_proxy` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否使用反代',
  `publish` tinyint(1) NOT NULL COMMENT '是否发布',
  `err_msg` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '错误信息',
  `power` smallint NOT NULL DEFAULT '0' COMMENT '消耗积分',
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MidJourney 任务表';

-- --------------------------------------------------------

--
-- 表的结构 `moderation`
--

DROP TABLE IF EXISTS `moderation`;
CREATE TABLE `moderation` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` int NOT NULL COMMENT '用户ID',
  `source` varchar(255) NOT NULL COMMENT '敏感词来源',
  `input` text NOT NULL COMMENT '用户输入',
  `output` text NOT NULL COMMENT 'AI 输出',
  `result` text NOT NULL COMMENT '鉴别结果',
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- 表的结构 `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` int NOT NULL,
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `product_id` bigint NOT NULL COMMENT '产品ID',
  `username` varchar(30) NOT NULL COMMENT '用户名',
  `order_no` varchar(30) NOT NULL COMMENT '订单ID',
  `trade_no` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '支付平台交易流水号',
  `subject` varchar(100) NOT NULL COMMENT '订单产品',
  `amount` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '订单金额',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '订单状态（0：待支付，1：已扫码，2：支付成功）',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '备注',
  `pay_time` int DEFAULT NULL COMMENT '支付时间',
  `pay_way` varchar(20) NOT NULL COMMENT '支付方式',
  `channel` varchar(30) NOT NULL COMMENT '支付类型渠道：支付宝，微信，聚合支付',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `checked` tinyint NOT NULL DEFAULT '0' COMMENT '是否已检查'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='充值订单表';

-- --------------------------------------------------------

--
-- 表的结构 `power_logs`
--

DROP TABLE IF EXISTS `power_logs`;
CREATE TABLE `power_logs` (
  `id` int NOT NULL,
  `user_id` int NOT NULL COMMENT '用户ID',
  `username` varchar(30) NOT NULL COMMENT '用户名',
  `type` tinyint(1) NOT NULL COMMENT '类型（1：充值，2：消费，3：退费）',
  `amount` smallint NOT NULL COMMENT '积分数值',
  `balance` bigint NOT NULL COMMENT '余额',
  `model` varchar(255) NOT NULL COMMENT '模型',
  `remark` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '备注',
  `mark` tinyint(1) NOT NULL COMMENT '资金类型（0：支出，1：收入）',
  `created_at` datetime NOT NULL COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户积分消费日志';

-- --------------------------------------------------------

--
-- 表的结构 `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE `products` (
  `id` int NOT NULL,
  `name` varchar(30) NOT NULL COMMENT '名称',
  `price` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '价格',
  `power` bigint NOT NULL DEFAULT '0' COMMENT '增加积分值',
  `enabled` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否启动',
  `sales` bigint NOT NULL DEFAULT '0' COMMENT '销量',
  `sort_num` tinyint NOT NULL DEFAULT '0' COMMENT '排序',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='会员套餐表';

--
-- 转存表中的数据 `products`
--

INSERT INTO `products` (`id`, `name`, `price`, `power`, `enabled`, `sales`, `sort_num`, `created_at`, `updated_at`) VALUES
(5, '100次点卡', 0.20, 100, 1, 0, 0, '2023-08-28 10:55:08', '2025-08-30 10:55:53'),
(6, '200次点卡', 19.90, 200, 1, 0, 0, '1970-01-01 08:00:00', '2024-10-23 18:12:36');

-- --------------------------------------------------------

--
-- 表的结构 `redeems`
--

DROP TABLE IF EXISTS `redeems`;
CREATE TABLE `redeems` (
  `id` int NOT NULL,
  `user_id` int NOT NULL COMMENT '用户 ID',
  `name` varchar(30) NOT NULL COMMENT '兑换码名称',
  `power` bigint NOT NULL COMMENT '积分',
  `code` varchar(100) NOT NULL COMMENT '兑换码',
  `enabled` tinyint(1) NOT NULL COMMENT '是否启用',
  `created_at` datetime NOT NULL,
  `redeemed_at` bigint NOT NULL COMMENT '兑换时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='兑换码';

-- --------------------------------------------------------

--
-- 表的结构 `suno_jobs`
--

DROP TABLE IF EXISTS `suno_jobs`;
CREATE TABLE `suno_jobs` (
  `id` int NOT NULL,
  `user_id` bigint NOT NULL COMMENT '用户 ID',
  `channel` varchar(100) NOT NULL COMMENT '渠道',
  `title` varchar(100) DEFAULT NULL COMMENT '歌曲标题',
  `type` tinyint(1) DEFAULT '0' COMMENT '任务类型,1:灵感创作,2:自定义创作',
  `task_id` varchar(50) DEFAULT NULL COMMENT '任务 ID',
  `params` text COMMENT '任务参数',
  `ref_task_id` char(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '引用任务 ID',
  `song_id` varchar(50) DEFAULT NULL COMMENT '要续写的歌曲 ID',
  `ref_song_id` varchar(50) NOT NULL COMMENT '引用的歌曲ID',
  `prompt` varchar(2000) NOT NULL COMMENT '提示词',
  `cover_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '封面图地址',
  `audio_url` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '音频地址',
  `progress` smallint DEFAULT '0' COMMENT '任务进度',
  `duration` smallint NOT NULL DEFAULT '0' COMMENT '歌曲时长',
  `publish` tinyint(1) NOT NULL COMMENT '是否发布',
  `err_msg` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '错误信息',
  `output` text COMMENT '原始输出数据',
  `power` smallint NOT NULL DEFAULT '0' COMMENT '消耗积分',
  `play_times` bigint DEFAULT NULL COMMENT '播放次数',
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MidJourney 任务表';

-- --------------------------------------------------------

--
-- 表的结构 `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int NOT NULL,
  `username` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `mobile` char(11) DEFAULT NULL COMMENT '手机号',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱地址',
  `nickname` varchar(30) NOT NULL COMMENT '昵称',
  `password` char(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '头像',
  `salt` char(12) NOT NULL COMMENT '密码盐',
  `power` bigint NOT NULL DEFAULT '0' COMMENT '剩余积分',
  `expired_time` bigint NOT NULL COMMENT '用户过期时间',
  `status` tinyint(1) NOT NULL COMMENT '当前状态',
  `chat_config_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '聊天配置json',
  `chat_roles_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '聊天角色 json',
  `chat_models_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'AI模型 json',
  `last_login_at` bigint NOT NULL COMMENT '最后登录时间',
  `vip` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否会员',
  `last_login_ip` char(32) NOT NULL COMMENT '最后登录 IP',
  `openid` varchar(100) DEFAULT NULL COMMENT '第三方登录账号ID',
  `platform` varchar(30) DEFAULT NULL COMMENT '登录平台',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户表';

-- --------------------------------------------------------

--
-- 表的结构 `user_login_logs`
--

DROP TABLE IF EXISTS `user_login_logs`;
CREATE TABLE `user_login_logs` (
  `id` int NOT NULL,
  `user_id` int NOT NULL COMMENT '用户ID',
  `username` varchar(30) NOT NULL COMMENT '用户名',
  `login_ip` char(32) NOT NULL COMMENT '登录IP',
  `login_address` varchar(30) NOT NULL COMMENT '登录地址',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='用户登录日志';

-- --------------------------------------------------------

--
-- 表的结构 `video_jobs`
--

DROP TABLE IF EXISTS `video_jobs`;
CREATE TABLE `video_jobs` (
  `id` int NOT NULL,
  `user_id` int NOT NULL COMMENT '用户 ID',
  `channel` varchar(100) NOT NULL COMMENT '渠道',
  `task_id` varchar(100) NOT NULL COMMENT '任务 ID',
  `params` text COMMENT '视频任务参数 JSON',
  `type` varchar(20) DEFAULT NULL COMMENT '任务类型,luma,runway,cogvideo',
  `prompt` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '提示词',
  `video_url` varchar(2000) NOT NULL COMMENT '视频地址',
  `progress` smallint DEFAULT '0' COMMENT '任务进度(0-100)',
  `publish` tinyint(1) NOT NULL COMMENT '是否发布',
  `err_msg` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '错误信息',
  `output` text COMMENT '任务输出的原始信息',
  `power` smallint NOT NULL DEFAULT '0' COMMENT '消耗积分',
  `created_at` datetime NOT NULL,
  `status` varchar(20) DEFAULT 'pending' COMMENT '任务状态:pending,in_progress,downloading,success,failed'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='MidJourney 任务表';

--
-- 转储表的索引
--

--
-- 表的索引 `admin_users`
--
ALTER TABLE `admin_users`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `username` (`username`) USING BTREE,
  ADD UNIQUE KEY `idx_chatgpt_admin_users_username` (`username`),
  ADD UNIQUE KEY `idx_admin_users_username` (`username`);

--
-- 表的索引 `api_keys`
--
ALTER TABLE `api_keys`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `app_types`
--
ALTER TABLE `app_types`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `chat_history`
--
ALTER TABLE `chat_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `chat_id` (`chat_id`),
  ADD KEY `idx_chatgpt_chat_history_chat_id` (`chat_id`),
  ADD KEY `idx_chatgpt_chat_history_user_id` (`user_id`),
  ADD KEY `idx_chat_history_user_id` (`user_id`),
  ADD KEY `idx_chat_history_chat_id` (`chat_id`);

--
-- 表的索引 `chat_items`
--
ALTER TABLE `chat_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `chat_id` (`chat_id`),
  ADD UNIQUE KEY `idx_chatgpt_chat_items_chat_id` (`chat_id`),
  ADD UNIQUE KEY `idx_chat_items_chat_id` (`chat_id`);

--
-- 表的索引 `chat_models`
--
ALTER TABLE `chat_models`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `chat_roles`
--
ALTER TABLE `chat_roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `marker` (`marker`),
  ADD UNIQUE KEY `idx_chatgpt_chat_roles_marker` (`marker`),
  ADD UNIQUE KEY `idx_chatgpt_chat_roles_key` (`marker`),
  ADD UNIQUE KEY `idx_chat_roles_key` (`marker`);

--
-- 表的索引 `configs`
--
ALTER TABLE `configs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `idx_chatgpt_configs_name` (`name`),
  ADD UNIQUE KEY `idx_configs_name` (`name`);

--
-- 表的索引 `files`
--
ALTER TABLE `files`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `functions`
--
ALTER TABLE `functions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`),
  ADD UNIQUE KEY `idx_chatgpt_functions_name` (`name`),
  ADD UNIQUE KEY `idx_functions_name` (`name`);

--
-- 表的索引 `image_jobs`
--
ALTER TABLE `image_jobs`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `invite_codes`
--
ALTER TABLE `invite_codes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD UNIQUE KEY `idx_chatgpt_invite_codes_code` (`code`),
  ADD UNIQUE KEY `idx_invite_codes_code` (`code`);

--
-- 表的索引 `invite_logs`
--
ALTER TABLE `invite_logs`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `jimeng_jobs`
--
ALTER TABLE `jimeng_jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_chatgpt_jimeng_jobs_task_id` (`task_id`),
  ADD KEY `idx_chatgpt_jimeng_jobs_user_id` (`user_id`),
  ADD KEY `idx_jimeng_jobs_user_id` (`user_id`),
  ADD KEY `idx_jimeng_jobs_task_id` (`task_id`);

--
-- 表的索引 `menus`
--
ALTER TABLE `menus`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `mj_jobs`
--
ALTER TABLE `mj_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `task_id` (`task_id`),
  ADD UNIQUE KEY `idx_chatgpt_mj_jobs_task_id` (`task_id`),
  ADD UNIQUE KEY `idx_mj_jobs_task_id` (`task_id`),
  ADD KEY `message_id` (`message_id`),
  ADD KEY `idx_chatgpt_mj_jobs_message_id` (`message_id`),
  ADD KEY `idx_mj_jobs_message_id` (`message_id`);

--
-- 表的索引 `moderation`
--
ALTER TABLE `moderation`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_no` (`order_no`),
  ADD UNIQUE KEY `idx_chatgpt_orders_order_no` (`order_no`),
  ADD UNIQUE KEY `idx_orders_order_no` (`order_no`);

--
-- 表的索引 `power_logs`
--
ALTER TABLE `power_logs`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `redeems`
--
ALTER TABLE `redeems`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD UNIQUE KEY `idx_chatgpt_redeems_code` (`code`),
  ADD UNIQUE KEY `idx_redeems_code` (`code`);

--
-- 表的索引 `suno_jobs`
--
ALTER TABLE `suno_jobs`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `idx_chatgpt_users_username` (`username`),
  ADD UNIQUE KEY `idx_users_username` (`username`);

--
-- 表的索引 `user_login_logs`
--
ALTER TABLE `user_login_logs`
  ADD PRIMARY KEY (`id`);

--
-- 表的索引 `video_jobs`
--
ALTER TABLE `video_jobs`
  ADD PRIMARY KEY (`id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `admin_users`
--
ALTER TABLE `admin_users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=114;

--
-- 使用表AUTO_INCREMENT `api_keys`
--
ALTER TABLE `api_keys`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `app_types`
--
ALTER TABLE `app_types`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- 使用表AUTO_INCREMENT `chat_history`
--
ALTER TABLE `chat_history`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `chat_items`
--
ALTER TABLE `chat_items`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `chat_models`
--
ALTER TABLE `chat_models`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `chat_roles`
--
ALTER TABLE `chat_roles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `configs`
--
ALTER TABLE `configs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- 使用表AUTO_INCREMENT `files`
--
ALTER TABLE `files`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `functions`
--
ALTER TABLE `functions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- 使用表AUTO_INCREMENT `image_jobs`
--
ALTER TABLE `image_jobs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `invite_codes`
--
ALTER TABLE `invite_codes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `invite_logs`
--
ALTER TABLE `invite_logs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `jimeng_jobs`
--
ALTER TABLE `jimeng_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `menus`
--
ALTER TABLE `menus`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- 使用表AUTO_INCREMENT `mj_jobs`
--
ALTER TABLE `mj_jobs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `moderation`
--
ALTER TABLE `moderation`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `power_logs`
--
ALTER TABLE `power_logs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `products`
--
ALTER TABLE `products`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- 使用表AUTO_INCREMENT `redeems`
--
ALTER TABLE `redeems`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `suno_jobs`
--
ALTER TABLE `suno_jobs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `user_login_logs`
--
ALTER TABLE `user_login_logs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- 使用表AUTO_INCREMENT `video_jobs`
--
ALTER TABLE `video_jobs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
