
CREATE DATABASE IF NOT EXISTS `lanaya`; 
USE `lanaya`;


CREATE TABLE IF NOT EXISTS `ld_group` (
  `group_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `group_name` varchar(50) NOT NULL COMMENT '终端分组名称',
  `phones` varchar(1000) DEFAULT NULL COMMENT '联系人',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='终端分组';

INSERT INTO `ld_group` (`group_name`) VALUES
	('home');
	
CREATE TABLE IF NOT EXISTS `ld_term` (
  `term_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `group_id` int(11) NOT NULL COMMENT '终端分组id，外键',
  `sn` varchar(50) NOT NULL COMMENT '终端编号',
  `name` varchar(50) NOT NULL COMMENT '终端名称',
  `contact` varchar(50) DEFAULT NULL COMMENT '联系人',
  `phone` varchar(50) DEFAULT NULL COMMENT '联系电话',
  `link_status` tinyint(4) DEFAULT '2' COMMENT '终端连接状态，1表示在线，2表示离线。',
  `run_status` tinyint(4) DEFAULT '2' COMMENT '终端运行状态，1表示正常运行，2表示离线。',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`term_id`),
  KEY `FK_ld_term_ld_group` (`group_id`),
  CONSTRAINT `FK_ld_term_ld_group` FOREIGN KEY (`group_id`) REFERENCES `ld_group` (`group_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='终端';

CREATE TABLE IF NOT EXISTS `ld_sensor_type` (
  `type_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `type_name` varchar(30) NOT NULL COMMENT '类型名称',
  `type_no` int(11) DEFAULT NULL,
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='传感器类型';

INSERT INTO `ld_sensor_type` (`type_name`, `type_no`) VALUES
	('数据1(单位:)', 1),
	('数据2(单位:)', 2),
	('数据3(单位:)', 3),
	('数据4(单位:)', 4);

CREATE TABLE IF NOT EXISTS `ld_sensor_data` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `term_id` int(11) NOT NULL COMMENT '终端id，外键',
  `type_id` int(11) NOT NULL COMMENT '传感器id，外键',
  `data` float DEFAULT NULL COMMENT '数据',
  `upload_time` datetime NOT NULL COMMENT '上传时间',
  PRIMARY KEY (`id`),
  KEY `FK_term_id` (`term_id`),
  KEY `FK_sensor_id` (`type_id`),
  CONSTRAINT `FK_term_id` FOREIGN KEY (`term_id`) REFERENCES `ld_term` (`group_id`) ON DELETE CASCADE,
  CONSTRAINT `FK_sensor_id` FOREIGN KEY (`type_id`) REFERENCES `ld_sensor_type` (`type_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COMMENT='传感器数据';
