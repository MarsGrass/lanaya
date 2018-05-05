/*
Navicat MySQL Data Transfer

Source Server         : php
Source Server Version : 50717
Source Host           : 120.77.41.61:38438
Source Database       : keda

Target Server Type    : MYSQL
Target Server Version : 50717
File Encoding         : 65001

Date: 2018-05-05 21:33:14
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `gas_group`
-- ----------------------------
DROP TABLE IF EXISTS `gas_group`;
CREATE TABLE `gas_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `name` varchar(30) NOT NULL COMMENT '分组名称',
  `description` varchar(1000) DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COMMENT='终端分组';

-- ----------------------------
-- Records of gas_group
-- ----------------------------
INSERT INTO `gas_group` VALUES ('1', 'group one', 'group one');
INSERT INTO `gas_group` VALUES ('17', 'group two', 'group two');
INSERT INTO `gas_group` VALUES ('19', 'group three', 'group three');
INSERT INTO `gas_group` VALUES ('20', 'group four', 'group four');
INSERT INTO `gas_group` VALUES ('21', 'group five', 'group five');
INSERT INTO `gas_group` VALUES ('22', 'qq', '');

-- ----------------------------
-- Table structure for `gas_group_alarm_config`
-- ----------------------------
DROP TABLE IF EXISTS `gas_group_alarm_config`;
CREATE TABLE `gas_group_alarm_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `group_id` int(11) NOT NULL COMMENT '外键gas_group.id',
  `sensor_type_code` varchar(20) NOT NULL COMMENT '传感器类型编号',
  `threshold_min` decimal(10,2) NOT NULL COMMENT '报警最小值，低于这个值报警。',
  `threshold_max` decimal(10,2) NOT NULL COMMENT '报警最大值，大于这个值报警',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COMMENT='报警设置，以组为单位。';

-- ----------------------------
-- Records of gas_group_alarm_config
-- ----------------------------
INSERT INTO `gas_group_alarm_config` VALUES ('4', '1', '1', '11.00', '55.00', '2018-05-03 15:49:47');
INSERT INTO `gas_group_alarm_config` VALUES ('5', '15', '2', '44.00', '55.00', '2018-05-03 08:58:49');
INSERT INTO `gas_group_alarm_config` VALUES ('6', '15', '3', '77.00', '88.00', '2018-05-03 08:59:08');
INSERT INTO `gas_group_alarm_config` VALUES ('9', '1', '4', '5.00', '15.00', '2018-05-03 15:50:02');
INSERT INTO `gas_group_alarm_config` VALUES ('10', '1', '3', '22.00', '22.00', '2018-05-04 20:59:13');
INSERT INTO `gas_group_alarm_config` VALUES ('11', '1', '2', '22.00', '2.00', '2018-05-04 20:59:21');
INSERT INTO `gas_group_alarm_config` VALUES ('13', '1', '1', '44.00', '44.00', '2018-05-05 11:45:55');
INSERT INTO `gas_group_alarm_config` VALUES ('14', '22', '1', '1.00', '100.00', '2018-05-05 19:09:57');
INSERT INTO `gas_group_alarm_config` VALUES ('15', '22', '2', '1.00', '44.00', '2018-05-05 19:10:08');

-- ----------------------------
-- Table structure for `gas_sensor`
-- ----------------------------
DROP TABLE IF EXISTS `gas_sensor`;
CREATE TABLE `gas_sensor` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `skey` varchar(30) NOT NULL COMMENT '终端编号 + 传感器编号',
  `terminal_code` varchar(30) NOT NULL COMMENT '终端编号',
  `sensor_code` varchar(30) NOT NULL COMMENT '传感器编号（这里传感器编号和传感器类型编号一样）',
  `type_code` varchar(20) NOT NULL COMMENT '传感器类型编号',
  `latest_data` decimal(10,2) DEFAULT NULL COMMENT '最新上报数据',
  `latest_report_time` datetime DEFAULT NULL COMMENT '最新上报时间',
  PRIMARY KEY (`id`),
  KEY `skey` (`skey`),
  KEY `terminal_code` (`terminal_code`),
  KEY `sensor_code` (`sensor_code`),
  KEY `type_code` (`type_code`)
) ENGINE=InnoDB AUTO_INCREMENT=16753618 DEFAULT CHARSET=utf8 COMMENT='传感器';

-- ----------------------------
-- Records of gas_sensor
-- ----------------------------
INSERT INTO `gas_sensor` VALUES ('1', '111111', 'code1', 'sensor1', '1', '555.00', '2018-05-02 12:05:35');
INSERT INTO `gas_sensor` VALUES ('2', '222', 'code2', 'sensor2', '2', '44.00', '2018-05-03 11:42:17');
INSERT INTO `gas_sensor` VALUES ('16753610', 'code1rrrrr', 'code1', 'rrrrr', '1', '55.00', '2018-05-04 23:58:33');
INSERT INTO `gas_sensor` VALUES ('16753611', 'code1rreeeeeeeeeee', 'code1', 'rreeeeeeeeeee', '3', '55.00', '2018-05-04 23:58:34');
INSERT INTO `gas_sensor` VALUES ('16753612', 'code2rrr', 'code2', 'rrr', '2', '55.00', '2018-05-04 23:58:35');
INSERT INTO `gas_sensor` VALUES ('16753614', '3132333411', '31323334', '11', '1', '55.00', '2018-05-04 23:58:31');
INSERT INTO `gas_sensor` VALUES ('16753615', '3132333422', '31323334', '22', '2', '545.00', '2018-05-04 23:58:30');
INSERT INTO `gas_sensor` VALUES ('16753616', '3132333433', '31323334', '33', '3', '545.00', '2018-05-04 23:58:29');
INSERT INTO `gas_sensor` VALUES ('16753617', '3132333444', '31323334', '44', '4', '23.00', '2018-05-04 23:58:28');

-- ----------------------------
-- Table structure for `gas_sensor_data`
-- ----------------------------
DROP TABLE IF EXISTS `gas_sensor_data`;
CREATE TABLE `gas_sensor_data` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `skey` varchar(40) NOT NULL COMMENT '传感器唯一编码，值为''终端编号_传感器编号''',
  `terminal_code` varchar(40) NOT NULL COMMENT '终端编号',
  `sensor_code` varchar(30) NOT NULL COMMENT '传感器编号',
  `data` decimal(10,2) NOT NULL DEFAULT '0.00' COMMENT '数据',
  `report_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '上报时间',
  PRIMARY KEY (`id`),
  KEY `skey_report_time` (`skey`,`report_time`),
  KEY `terminal_code_report_time` (`terminal_code`,`report_time`),
  KEY `report_time` (`report_time`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='传感器数据';

-- ----------------------------
-- Records of gas_sensor_data
-- ----------------------------
INSERT INTO `gas_sensor_data` VALUES ('1', '111111', 'code1', 'sensor1', '44.00', '2018-05-03 15:56:00');

-- ----------------------------
-- Table structure for `gas_sensor_type`
-- ----------------------------
DROP TABLE IF EXISTS `gas_sensor_type`;
CREATE TABLE `gas_sensor_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `type_code` varchar(20) NOT NULL COMMENT '类型编号',
  `type_name` varchar(30) NOT NULL COMMENT '类型名称',
  PRIMARY KEY (`id`),
  KEY `type_code` (`type_code`)
) ENGINE=InnoDB AUTO_INCREMENT=266 DEFAULT CHARSET=utf8 COMMENT='传感器类型';

-- ----------------------------
-- Records of gas_sensor_type
-- ----------------------------
INSERT INTO `gas_sensor_type` VALUES ('256', '1', 'Air Temperature');
INSERT INTO `gas_sensor_type` VALUES ('257', '2', 'Air Humidity');
INSERT INTO `gas_sensor_type` VALUES ('258', '3', 'Illuminance');
INSERT INTO `gas_sensor_type` VALUES ('259', '4', 'Wind Speed');

-- ----------------------------
-- Table structure for `gas_terminal`
-- ----------------------------
DROP TABLE IF EXISTS `gas_terminal`;
CREATE TABLE `gas_terminal` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '自增主键',
  `group_id` int(11) NOT NULL COMMENT '终端分组id，外键',
  `code` varchar(50) NOT NULL COMMENT '终端编号',
  `name` varchar(50) NOT NULL COMMENT '终端名称',
  `contact` varchar(50) DEFAULT NULL COMMENT '联系人',
  `phone` varchar(50) DEFAULT NULL COMMENT '联系电话',
  `link_status` tinyint(4) DEFAULT '2' COMMENT '终端连接状态，1表示在线，2表示离线。',
  `run_status` tinyint(4) DEFAULT '2' COMMENT '终端工作状态，1表示正常运行，2表示离线。',
  `sample_freq` int(11) unsigned DEFAULT NULL COMMENT '采样频率',
  `description` varchar(500) DEFAULT NULL COMMENT '描述',
  PRIMARY KEY (`id`),
  KEY `group_id` (`group_id`),
  KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COMMENT='终端';

-- ----------------------------
-- Records of gas_terminal
-- ----------------------------
INSERT INTO `gas_terminal` VALUES ('34', '1', '31323334', 'test1', '111', '1111', '1', '1', '6', 'test 1');
INSERT INTO `gas_terminal` VALUES ('36', '1', '31323335', 'test2', null, null, '2', '2', null, '');

-- ----------------------------
-- Table structure for `gas_terminal_cmd`
-- ----------------------------
DROP TABLE IF EXISTS `gas_terminal_cmd`;
CREATE TABLE `gas_terminal_cmd` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `terminal_code` varchar(30) DEFAULT NULL COMMENT '终端编号',
  `content` varchar(1000) NOT NULL COMMENT '命令内容',
  `exec_status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '命令状态，0未下发，1已下发',
  `exec_time` datetime DEFAULT NULL COMMENT '命令下发时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  PRIMARY KEY (`id`),
  KEY `terminal_code` (`terminal_code`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COMMENT='终端命令';

-- ----------------------------
-- Records of gas_terminal_cmd
-- ----------------------------
INSERT INTO `gas_terminal_cmd` VALUES ('1', 'code1', '111', '1', '2018-05-02 18:22:50', '2018-05-03 18:43:26');
INSERT INTO `gas_terminal_cmd` VALUES ('2', 'code1', 'eee', '1', '2018-05-02 18:22:56', '2018-05-03 18:43:38');
INSERT INTO `gas_terminal_cmd` VALUES ('5', 'code2', 'rrr', '0', '2018-05-03 13:48:56', '2018-05-03 19:20:43');
INSERT INTO `gas_terminal_cmd` VALUES ('6', 'code2', 'rrrr', '0', '2018-05-03 19:20:53', '2018-05-03 19:20:54');

-- ----------------------------
-- Table structure for `spd_sys_dept`
-- ----------------------------
DROP TABLE IF EXISTS `spd_sys_dept`;
CREATE TABLE `spd_sys_dept` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(20) DEFAULT '0' COMMENT '上级部门，如果没有上级部门，值为0',
  `name` varchar(50) NOT NULL COMMENT '部门名称',
  `code` varchar(20) DEFAULT NULL COMMENT '部门编号，唯一',
  `phone` varchar(50) DEFAULT NULL COMMENT '部门电话',
  `email` varchar(100) DEFAULT NULL COMMENT '部门邮箱',
  `base_city_id` int(11) DEFAULT NULL COMMENT '外键spd_base_city.id',
  `base_county_id` int(11) DEFAULT NULL COMMENT '外键spd_base_county.id',
  `address` varchar(500) DEFAULT NULL COMMENT '详细地址',
  `sort` int(11) DEFAULT '1000' COMMENT '部门排序，值越小越靠前',
  `operate_time` datetime DEFAULT NULL COMMENT '操作时间',
  `operate_id` bigint(20) DEFAULT NULL COMMENT '操作人id',
  PRIMARY KEY (`id`),
  KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COMMENT='组织机构';

-- ----------------------------
-- Records of spd_sys_dept
-- ----------------------------
INSERT INTO `spd_sys_dept` VALUES ('7', '0', '单位信息管理', '450100000000', null, '', null, null, null, '1000', null, null);
INSERT INTO `spd_sys_dept` VALUES ('8', '7', '青秀区工商质监局', '450103000000', null, '', null, null, null, '1000', null, null);
INSERT INTO `spd_sys_dept` VALUES ('9', '8', '桃源工商质监所', '45010300000001', null, '', null, null, null, '1000', null, null);
INSERT INTO `spd_sys_dept` VALUES ('10', '8', '飞凤工商质监所', '45010300000002', null, '', null, null, null, '1000', null, null);
INSERT INTO `spd_sys_dept` VALUES ('11', '8', '埌西工商质监所', '45010300000003', null, '', null, null, null, '1000', null, null);
INSERT INTO `spd_sys_dept` VALUES ('12', '8', '金湖工商质监所', '45010300000004', null, '', null, null, null, '1000', null, null);
INSERT INTO `spd_sys_dept` VALUES ('13', '8', '建政工商质监所', '45010300000005', null, '', null, null, null, '1000', null, null);
INSERT INTO `spd_sys_dept` VALUES ('14', '8', '七星工商质监所', '45010300000006', null, '', null, null, null, '1000', null, null);
INSERT INTO `spd_sys_dept` VALUES ('15', '8', '埌东工商质监所', '45010300000007', null, '', null, null, null, '1000', null, null);
INSERT INTO `spd_sys_dept` VALUES ('16', '8', '东盟工商质监所', '45010300000008', null, '', null, null, null, '1000', null, null);
INSERT INTO `spd_sys_dept` VALUES ('17', '8', '长堽工商质监所', '45010300000009', null, '', null, null, null, '1000', null, null);
INSERT INTO `spd_sys_dept` VALUES ('18', '8', '仙葫工商质监所', '45010300000010', null, '', null, null, null, '1000', null, null);
INSERT INTO `spd_sys_dept` VALUES ('19', '8', '南阳工商质监所', '45010300000011', null, '', null, null, null, '1000', null, null);
INSERT INTO `spd_sys_dept` VALUES ('20', '8', '刘圩工商质监所', '45010300000012', null, '', null, null, null, '1000', null, null);
INSERT INTO `spd_sys_dept` VALUES ('21', '8', '长塘工商质监所', '45010300000013', null, '', null, null, null, '1000', null, null);
INSERT INTO `spd_sys_dept` VALUES ('22', '8', '伶俐工商质监所', '45010300000014', null, '', null, null, null, '1000', null, null);
INSERT INTO `spd_sys_dept` VALUES ('23', '8', '中国建设银行长湖路支行', '45010300000015', null, '', null, null, null, '1000', null, null);

-- ----------------------------
-- Table structure for `spd_sys_resource`
-- ----------------------------
DROP TABLE IF EXISTS `spd_sys_resource`;
CREATE TABLE `spd_sys_resource` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parent_id` bigint(20) DEFAULT '0' COMMENT '上级ID，如果没有上级的话值为0',
  `code` varchar(50) NOT NULL COMMENT '资源编号，唯一',
  `name` varchar(50) NOT NULL COMMENT '资源名称',
  `url` varchar(200) DEFAULT NULL COMMENT '访问路径，本站是相对路径，外站是全路径',
  `type` tinyint(4) DEFAULT '3' COMMENT '资源类型，1表示菜单，2表示按钮，3表示目录（无校验功能）',
  `icon` varchar(100) DEFAULT NULL COMMENT '资源图标',
  `sort` int(11) DEFAULT '1000' COMMENT '菜单或功能在同一级别的排序，越小越靠前，默认1000',
  `category` int(11) DEFAULT '1' COMMENT '资源类别，1表示普通资源（可以查询删除修改），2表示系统默认资源（只能查询，不能删除修改）',
  `status` int(11) DEFAULT '1' COMMENT '资源状态，1表示正常，2表示隐藏',
  `operate_time` datetime NOT NULL COMMENT '操作时间',
  `operate_id` bigint(20) NOT NULL COMMENT '操作人id',
  PRIMARY KEY (`id`),
  KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8 COMMENT='后台管理系统功能（URL区别）';

-- ----------------------------
-- Records of spd_sys_resource
-- ----------------------------
INSERT INTO `spd_sys_resource` VALUES ('65', '0', 'sysManager', 'System Management', ' ', '3', 'fa-cog', '1000', '1', '1', '2018-05-04 18:05:45', '0');
INSERT INTO `spd_sys_resource` VALUES ('71', '65', 'sysdept', '部门管理', '/admin/sysdept/pageView.do', '1', 'fa-sitemap', '3', '1', '1', '2017-04-04 10:46:50', '0');
INSERT INTO `spd_sys_resource` VALUES ('76', '65', 'sysresource', '菜单管理', '/admin/sysresource/pageView.do', '1', 'fa-sliders', '4', '1', '1', '2017-04-04 10:46:07', '0');
INSERT INTO `spd_sys_resource` VALUES ('77', '65', 'sysuser', '用户管理', '/admin/sysuser/pageView.do', '1', 'fa-user', '1', '1', '1', '2017-04-04 08:37:50', '0');
INSERT INTO `spd_sys_resource` VALUES ('78', '65', 'sysrole', '角色管理', '/admin/sysrole/pageView.do', '1', 'fa-users', '2', '1', '1', '2017-04-04 10:45:16', '0');
INSERT INTO `spd_sys_resource` VALUES ('79', '85', 'newsmanager', '新闻管理', ' ', '3', 'fa-newspaper-o', '100', '1', '1', '2017-04-04 11:10:21', '0');
INSERT INTO `spd_sys_resource` VALUES ('80', '79', 'newsCategory', '新闻分类', '/admin/news/category/pageView.do', '1', 'fa-tasks', '1', '1', '1', '2017-04-05 07:50:05', '0');
INSERT INTO `spd_sys_resource` VALUES ('81', '79', 'newsList', '新闻列表', '/admin/news/pageView.do', '1', 'fa-newspaper-o', '2', '1', '1', '2017-04-05 22:38:38', '0');
INSERT INTO `spd_sys_resource` VALUES ('82', '85', 'videomgr', '视频管理', ' ', '3', 'fa-video-camera', '200', '1', '1', '2017-05-18 14:04:48', '0');
INSERT INTO `spd_sys_resource` VALUES ('83', '82', 'videoCategory', '视频分类', '/admin/video/category/pageView.do', '1', 'fa-tasks', '1', '1', '1', '2017-04-24 17:37:36', '0');
INSERT INTO `spd_sys_resource` VALUES ('84', '82', 'videoList', '视频列表', '/admin/video/pageView.do', '1', 'fa-video-camera', '2', '1', '1', '2017-04-25 15:20:52', '0');
INSERT INTO `spd_sys_resource` VALUES ('85', '0', 'contentManager', '内容管理', ' ', '3', 'fa-newspaper-o', '100', '1', '2', '2018-05-02 10:05:11', '0');
INSERT INTO `spd_sys_resource` VALUES ('86', '0', 'wechatManager', '微信管理', ' ', '3', 'fa-comments-o', '102', '1', '2', '2018-05-01 22:42:01', '0');
INSERT INTO `spd_sys_resource` VALUES ('87', '86', 'wechatConfig', '公众号设置', '/admin/wechat/config/view.do', '1', 'fa-sliders', '1', '1', '1', '2017-04-27 16:48:59', '0');
INSERT INTO `spd_sys_resource` VALUES ('88', '86', 'wechatMenu', '微信菜单', '/admin/wechat/menu/view.do', '1', 'fa-sliders', '2', '1', '1', '2017-08-14 09:45:58', '0');
INSERT INTO `spd_sys_resource` VALUES ('89', '86', 'wechatReply', '回复管理', '/admin/wechat/replyView.do', '1', 'fa-sliders', '3', '1', '2', '2017-08-14 09:46:40', '0');
INSERT INTO `spd_sys_resource` VALUES ('90', '0', 'endUserManager', 'EndUserManager', ' ', '3', 'fa-user-o', '103', '1', '2', '2018-05-05 15:53:35', '0');
INSERT INTO `spd_sys_resource` VALUES ('91', '90', 'End User', '终端用户', '/admin/endUser/view.do', '1', 'fa-meh-o', '1', '1', '1', '2018-05-05 15:53:58', '0');
INSERT INTO `spd_sys_resource` VALUES ('92', '0', 'ysMgr', '预审管理', ' ', '3', 'fa-gavel', '95', '1', '2', '2018-05-01 22:42:26', '0');
INSERT INTO `spd_sys_resource` VALUES ('97', '0', 'document', 'document', '/doc/index.jsp', '1', 'fa-book', '1000', '1', '2', '2018-05-04 12:58:50', '0');
INSERT INTO `spd_sys_resource` VALUES ('98', '0', 'ysStat', '统计分析', ' ', '3', 'fa-bar-chart-o', '96', '1', '2', '2018-05-01 22:42:44', '0');
INSERT INTO `spd_sys_resource` VALUES ('113', '92', 'ysPickNewTask', '领取任务', '/admin/nnys/proc/pickTaskView.do', '1', 'fa-circle-o', '50', '1', '2', '2018-05-02 08:13:40', '0');
INSERT INTO `spd_sys_resource` VALUES ('114', '121', 'ysTodoTask', '待办任务', '/admin/nnys/qysl/todoTaskView.do', '1', 'fa-circle-o', '1000', '1', '1', '2017-10-18 20:38:51', '0');
INSERT INTO `spd_sys_resource` VALUES ('115', '121', 'ysDoneTask', '已办任务', '/admin/nnys/qysl/doneTaskView.do', '1', 'fa-circle-o', '1000', '1', '1', '2017-10-18 20:39:33', '0');
INSERT INTO `spd_sys_resource` VALUES ('116', '121', 'ysAllTask', '所有任务', '/admin/nnys/qysl/allTaskView.do', '1', 'fa-circle-o', '1000', '1', '1', '2017-10-18 20:39:51', '0');
INSERT INTO `spd_sys_resource` VALUES ('117', '122', 'qyhmAllTask', '所有核名', '/admin/nnys/qyhm/allTaskView.do', '1', 'fa-circle-o', '1001', '1', '1', '2017-10-28 04:12:05', '0');
INSERT INTO `spd_sys_resource` VALUES ('120', '122', 'todoHm', '待办核名', '/admin/nnys/qyhm/todoTaskView.do', '1', 'fa-circle-o', '1000', '1', '1', '2017-10-18 20:43:04', '0');
INSERT INTO `spd_sys_resource` VALUES ('121', '92', 'dYsQysl', '企业设立', ' ', '3', ' ', '100', '1', '2', '2018-05-02 08:13:52', '0');
INSERT INTO `spd_sys_resource` VALUES ('122', '92', 'dYsQyhm', '企业核名', ' ', '3', ' ', '101', '1', '2', '2018-05-02 08:14:37', '0');
INSERT INTO `spd_sys_resource` VALUES ('123', '122', 'mYsQyhmDone', '已办核名', '/admin/nnys/qyhm/doneTaskView.do', '1', 'fa-circle-o', '1000', '1', '1', '2017-10-28 04:12:22', '0');
INSERT INTO `spd_sys_resource` VALUES ('124', '121', 'mYsQyslCailiaoTJ', '材料提交', '/admin/nnys/qysl/cailiaoTaskView.do', '1', 'fa-circle-o', '1000', '1', '1', '2017-10-28 04:23:19', '0');
INSERT INTO `spd_sys_resource` VALUES ('125', '121', 'mYsQyslCailiaoSB', '材料上报', '/admin/nnys/qysl/cailiaoSbTaskView.do', '1', 'fa-circle-o', '1000', '1', '1', '2017-10-28 04:25:02', '0');
INSERT INTO `spd_sys_resource` VALUES ('126', '92', 'dYsQybg', '企业变更', ' ', '3', ' ', '1000', '1', '2', '2018-05-02 08:14:48', '0');
INSERT INTO `spd_sys_resource` VALUES ('127', '126', 'mYsQybgTodo', '待办变更', '/admin/nnys/qybg/todoTaskView.do', '1', 'fa-circle-o', '1000', '1', '1', '2017-11-06 01:40:48', '0');
INSERT INTO `spd_sys_resource` VALUES ('128', '92', 'mYsProcLimitConfig', '任务设置', '/admin/nnys/proc/config/limitView.do', '1', 'fa-circle-o', '49', '1', '2', '2018-05-02 08:13:27', '0');
INSERT INTO `spd_sys_resource` VALUES ('129', '98', 'dQyslStat', '企业设立', ' ', '3', ' ', '1000', '1', '1', '2017-11-06 01:33:32', '0');
INSERT INTO `spd_sys_resource` VALUES ('130', '129', 'mQyslStatAvgDur', '平均办理时间', '/admin/nnys/stat/qysl/procAvgDurationView.do', '1', 'fa-circle-o', '1000', '1', '1', '2017-11-06 01:31:48', '0');
INSERT INTO `spd_sys_resource` VALUES ('131', '129', 'mQyslStatBlr', '办理人统计', '/admin/nnys/stat/qysl/procStepView.do', '1', 'fa-circle-o', '1000', '1', '1', '2017-11-06 01:32:52', '0');
INSERT INTO `spd_sys_resource` VALUES ('132', '126', 'mQybgDone', '已办变更', '/admin/nnys/qybg/doneTaskView.do', '1', 'fa-circle-o', '1000', '1', '1', '2017-11-06 01:42:23', '0');
INSERT INTO `spd_sys_resource` VALUES ('133', '126', 'mQybgAllTask', '全部变更', '/admin/nnys/qybg/allTaskView.do', '1', 'fa-circle-o', '1000', '1', '1', '2017-11-06 01:43:03', '0');
INSERT INTO `spd_sys_resource` VALUES ('134', '98', 'dQyhmStat', '企业核名', '', '3', '', '1000', '1', '1', '2017-11-19 21:36:22', '0');
INSERT INTO `spd_sys_resource` VALUES ('135', '134', 'mQyhmPjblsc', '平均办理时长', '/admin/nnys/stat/qyhm/procAvgDurationView.do', '1', 'fa-circle-o', '1000', '1', '1', '2017-11-19 22:22:23', '0');
INSERT INTO `spd_sys_resource` VALUES ('136', '134', 'statQyhmBlrtj', '办理人统计', '/admin/nnys/stat/qyhm/procStepView.do', '1', 'fa-circle-o', '1000', '1', '1', '2017-11-19 22:54:10', '0');
INSERT INTO `spd_sys_resource` VALUES ('137', '98', 'totalStat', '总量统计', '/admin/nnys/stat/allTaskStatView.do', '1', 'fa-circle-o', '1007', '1', '1', '2017-11-21 09:09:25', '0');
INSERT INTO `spd_sys_resource` VALUES ('141', '0', 'keda', 'Terminal Management', ' ', '3', 'fa-share-alt-square', '90', '1', '1', '2018-05-04 18:04:52', '0');
INSERT INTO `spd_sys_resource` VALUES ('142', '141', '22', 'Terminal Group', '/group/view.do', '1', 'fa-code-fork', '1000', '1', '1', '2018-05-04 18:07:03', '0');
INSERT INTO `spd_sys_resource` VALUES ('143', '141', 'sensor', 'Sensor', '/sensor/view.do', '1', 'fa-circle-o', '1000', '1', '2', '2018-05-04 18:07:43', '0');
INSERT INTO `spd_sys_resource` VALUES ('144', '141', 'terminal', 'Terminal', '/terminal/view.do', '1', 'fa-circle-o', '1000', '1', '1', '2018-05-05 12:25:39', '0');
INSERT INTO `spd_sys_resource` VALUES ('145', '141', 'sensorType', 'Sensor Type', '/sensorType/view.do', '1', 'fa-circle-o', '1000', '1', '1', '2018-05-04 18:08:51', '0');
INSERT INTO `spd_sys_resource` VALUES ('146', '141', 'sensorData', 'Sensor Data', '/sensorData/view.do', '1', 'fa-circle-o', '1000', '1', '1', '2018-05-05 12:26:05', '0');
INSERT INTO `spd_sys_resource` VALUES ('147', '141', 'terminalCmd', '终端命令', '/terminalCmd/view.do', '1', 'fa-cog', '1000', '1', '2', '2018-05-02 22:08:52', '0');

-- ----------------------------
-- Table structure for `spd_sys_role`
-- ----------------------------
DROP TABLE IF EXISTS `spd_sys_role`;
CREATE TABLE `spd_sys_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) NOT NULL COMMENT '角色名称',
  `operate_time` datetime DEFAULT NULL COMMENT '操作时间（创建/更新）',
  `operate_id` bigint(20) DEFAULT NULL COMMENT '操作人id',
  PRIMARY KEY (`id`),
  KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='系统角色';

-- ----------------------------
-- Records of spd_sys_role
-- ----------------------------
INSERT INTO `spd_sys_role` VALUES ('3', '系统管理员', null, null);
INSERT INTO `spd_sys_role` VALUES ('8', '审批工作人员', null, null);
INSERT INTO `spd_sys_role` VALUES ('9', '审核工作人员', null, null);
INSERT INTO `spd_sys_role` VALUES ('10', '叶总测试', null, null);
INSERT INTO `spd_sys_role` VALUES ('11', '现场收件员', null, null);
INSERT INTO `spd_sys_role` VALUES ('12', '预核名工作人员', null, null);
INSERT INTO `spd_sys_role` VALUES ('13', '材料录入工作人员', null, null);
INSERT INTO `spd_sys_role` VALUES ('14', '合作网点', null, null);

-- ----------------------------
-- Table structure for `spd_sys_role_resource`
-- ----------------------------
DROP TABLE IF EXISTS `spd_sys_role_resource`;
CREATE TABLE `spd_sys_role_resource` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sys_role_id` bigint(20) NOT NULL COMMENT '外键spd_sys_role.id',
  `sys_resource_id` bigint(20) NOT NULL COMMENT '外键spd_sys_resource.id',
  PRIMARY KEY (`id`),
  KEY `sys_role_id_sys_resource_id` (`sys_role_id`,`sys_resource_id`),
  KEY `sys_resource_id` (`sys_resource_id`)
) ENGINE=InnoDB AUTO_INCREMENT=867 DEFAULT CHARSET=utf8 COMMENT='角色功能关联';

-- ----------------------------
-- Records of spd_sys_role_resource
-- ----------------------------
INSERT INTO `spd_sys_role_resource` VALUES ('782', '3', '65');
INSERT INTO `spd_sys_role_resource` VALUES ('783', '3', '76');
INSERT INTO `spd_sys_role_resource` VALUES ('784', '3', '77');
INSERT INTO `spd_sys_role_resource` VALUES ('785', '3', '78');
INSERT INTO `spd_sys_role_resource` VALUES ('786', '3', '86');
INSERT INTO `spd_sys_role_resource` VALUES ('787', '3', '87');
INSERT INTO `spd_sys_role_resource` VALUES ('788', '3', '88');
INSERT INTO `spd_sys_role_resource` VALUES ('789', '3', '89');
INSERT INTO `spd_sys_role_resource` VALUES ('790', '3', '90');
INSERT INTO `spd_sys_role_resource` VALUES ('791', '3', '91');
INSERT INTO `spd_sys_role_resource` VALUES ('792', '3', '92');
INSERT INTO `spd_sys_role_resource` VALUES ('809', '3', '97');
INSERT INTO `spd_sys_role_resource` VALUES ('810', '3', '98');
INSERT INTO `spd_sys_role_resource` VALUES ('793', '3', '113');
INSERT INTO `spd_sys_role_resource` VALUES ('795', '3', '114');
INSERT INTO `spd_sys_role_resource` VALUES ('796', '3', '115');
INSERT INTO `spd_sys_role_resource` VALUES ('797', '3', '116');
INSERT INTO `spd_sys_role_resource` VALUES ('801', '3', '117');
INSERT INTO `spd_sys_role_resource` VALUES ('802', '3', '120');
INSERT INTO `spd_sys_role_resource` VALUES ('794', '3', '121');
INSERT INTO `spd_sys_role_resource` VALUES ('800', '3', '122');
INSERT INTO `spd_sys_role_resource` VALUES ('803', '3', '123');
INSERT INTO `spd_sys_role_resource` VALUES ('798', '3', '124');
INSERT INTO `spd_sys_role_resource` VALUES ('799', '3', '125');
INSERT INTO `spd_sys_role_resource` VALUES ('804', '3', '126');
INSERT INTO `spd_sys_role_resource` VALUES ('805', '3', '127');
INSERT INTO `spd_sys_role_resource` VALUES ('808', '3', '128');
INSERT INTO `spd_sys_role_resource` VALUES ('811', '3', '129');
INSERT INTO `spd_sys_role_resource` VALUES ('812', '3', '130');
INSERT INTO `spd_sys_role_resource` VALUES ('813', '3', '131');
INSERT INTO `spd_sys_role_resource` VALUES ('806', '3', '132');
INSERT INTO `spd_sys_role_resource` VALUES ('807', '3', '133');
INSERT INTO `spd_sys_role_resource` VALUES ('814', '3', '134');
INSERT INTO `spd_sys_role_resource` VALUES ('815', '3', '135');
INSERT INTO `spd_sys_role_resource` VALUES ('816', '3', '136');
INSERT INTO `spd_sys_role_resource` VALUES ('817', '3', '137');
INSERT INTO `spd_sys_role_resource` VALUES ('299', '8', '79');
INSERT INTO `spd_sys_role_resource` VALUES ('300', '8', '80');
INSERT INTO `spd_sys_role_resource` VALUES ('301', '8', '81');
INSERT INTO `spd_sys_role_resource` VALUES ('302', '8', '82');
INSERT INTO `spd_sys_role_resource` VALUES ('303', '8', '83');
INSERT INTO `spd_sys_role_resource` VALUES ('304', '8', '84');
INSERT INTO `spd_sys_role_resource` VALUES ('298', '8', '85');
INSERT INTO `spd_sys_role_resource` VALUES ('305', '8', '92');
INSERT INTO `spd_sys_role_resource` VALUES ('306', '8', '113');
INSERT INTO `spd_sys_role_resource` VALUES ('307', '8', '114');
INSERT INTO `spd_sys_role_resource` VALUES ('308', '8', '115');
INSERT INTO `spd_sys_role_resource` VALUES ('309', '8', '116');
INSERT INTO `spd_sys_role_resource` VALUES ('70', '9', '92');
INSERT INTO `spd_sys_role_resource` VALUES ('71', '9', '113');
INSERT INTO `spd_sys_role_resource` VALUES ('72', '9', '114');
INSERT INTO `spd_sys_role_resource` VALUES ('73', '9', '115');
INSERT INTO `spd_sys_role_resource` VALUES ('74', '9', '116');
INSERT INTO `spd_sys_role_resource` VALUES ('844', '10', '65');
INSERT INTO `spd_sys_role_resource` VALUES ('845', '10', '77');
INSERT INTO `spd_sys_role_resource` VALUES ('846', '10', '90');
INSERT INTO `spd_sys_role_resource` VALUES ('847', '10', '91');
INSERT INTO `spd_sys_role_resource` VALUES ('848', '10', '92');
INSERT INTO `spd_sys_role_resource` VALUES ('859', '10', '98');
INSERT INTO `spd_sys_role_resource` VALUES ('849', '10', '113');
INSERT INTO `spd_sys_role_resource` VALUES ('851', '10', '114');
INSERT INTO `spd_sys_role_resource` VALUES ('852', '10', '115');
INSERT INTO `spd_sys_role_resource` VALUES ('853', '10', '116');
INSERT INTO `spd_sys_role_resource` VALUES ('855', '10', '117');
INSERT INTO `spd_sys_role_resource` VALUES ('856', '10', '120');
INSERT INTO `spd_sys_role_resource` VALUES ('850', '10', '121');
INSERT INTO `spd_sys_role_resource` VALUES ('854', '10', '122');
INSERT INTO `spd_sys_role_resource` VALUES ('857', '10', '123');
INSERT INTO `spd_sys_role_resource` VALUES ('858', '10', '128');
INSERT INTO `spd_sys_role_resource` VALUES ('860', '10', '129');
INSERT INTO `spd_sys_role_resource` VALUES ('861', '10', '130');
INSERT INTO `spd_sys_role_resource` VALUES ('862', '10', '131');
INSERT INTO `spd_sys_role_resource` VALUES ('863', '10', '134');
INSERT INTO `spd_sys_role_resource` VALUES ('864', '10', '135');
INSERT INTO `spd_sys_role_resource` VALUES ('865', '10', '136');
INSERT INTO `spd_sys_role_resource` VALUES ('866', '10', '137');
INSERT INTO `spd_sys_role_resource` VALUES ('203', '11', '92');
INSERT INTO `spd_sys_role_resource` VALUES ('204', '11', '113');
INSERT INTO `spd_sys_role_resource` VALUES ('205', '11', '114');
INSERT INTO `spd_sys_role_resource` VALUES ('206', '11', '115');
INSERT INTO `spd_sys_role_resource` VALUES ('207', '11', '116');
INSERT INTO `spd_sys_role_resource` VALUES ('476', '12', '90');
INSERT INTO `spd_sys_role_resource` VALUES ('477', '12', '91');
INSERT INTO `spd_sys_role_resource` VALUES ('478', '12', '92');
INSERT INTO `spd_sys_role_resource` VALUES ('479', '12', '113');
INSERT INTO `spd_sys_role_resource` VALUES ('480', '12', '114');
INSERT INTO `spd_sys_role_resource` VALUES ('481', '12', '115');
INSERT INTO `spd_sys_role_resource` VALUES ('482', '12', '116');
INSERT INTO `spd_sys_role_resource` VALUES ('484', '12', '117');
INSERT INTO `spd_sys_role_resource` VALUES ('485', '12', '120');
INSERT INTO `spd_sys_role_resource` VALUES ('483', '12', '122');
INSERT INTO `spd_sys_role_resource` VALUES ('486', '12', '123');
INSERT INTO `spd_sys_role_resource` VALUES ('265', '13', '92');
INSERT INTO `spd_sys_role_resource` VALUES ('266', '13', '113');
INSERT INTO `spd_sys_role_resource` VALUES ('267', '13', '114');
INSERT INTO `spd_sys_role_resource` VALUES ('268', '13', '115');
INSERT INTO `spd_sys_role_resource` VALUES ('269', '13', '116');
INSERT INTO `spd_sys_role_resource` VALUES ('818', '14', '90');
INSERT INTO `spd_sys_role_resource` VALUES ('819', '14', '91');
INSERT INTO `spd_sys_role_resource` VALUES ('820', '14', '92');
INSERT INTO `spd_sys_role_resource` VALUES ('836', '14', '98');
INSERT INTO `spd_sys_role_resource` VALUES ('821', '14', '113');
INSERT INTO `spd_sys_role_resource` VALUES ('823', '14', '114');
INSERT INTO `spd_sys_role_resource` VALUES ('824', '14', '115');
INSERT INTO `spd_sys_role_resource` VALUES ('825', '14', '116');
INSERT INTO `spd_sys_role_resource` VALUES ('829', '14', '117');
INSERT INTO `spd_sys_role_resource` VALUES ('830', '14', '120');
INSERT INTO `spd_sys_role_resource` VALUES ('822', '14', '121');
INSERT INTO `spd_sys_role_resource` VALUES ('828', '14', '122');
INSERT INTO `spd_sys_role_resource` VALUES ('831', '14', '123');
INSERT INTO `spd_sys_role_resource` VALUES ('826', '14', '124');
INSERT INTO `spd_sys_role_resource` VALUES ('827', '14', '125');
INSERT INTO `spd_sys_role_resource` VALUES ('832', '14', '126');
INSERT INTO `spd_sys_role_resource` VALUES ('833', '14', '127');
INSERT INTO `spd_sys_role_resource` VALUES ('837', '14', '129');
INSERT INTO `spd_sys_role_resource` VALUES ('838', '14', '130');
INSERT INTO `spd_sys_role_resource` VALUES ('839', '14', '131');
INSERT INTO `spd_sys_role_resource` VALUES ('834', '14', '132');
INSERT INTO `spd_sys_role_resource` VALUES ('835', '14', '133');
INSERT INTO `spd_sys_role_resource` VALUES ('840', '14', '134');
INSERT INTO `spd_sys_role_resource` VALUES ('841', '14', '135');
INSERT INTO `spd_sys_role_resource` VALUES ('842', '14', '136');
INSERT INTO `spd_sys_role_resource` VALUES ('843', '14', '137');

-- ----------------------------
-- Table structure for `spd_sys_user`
-- ----------------------------
DROP TABLE IF EXISTS `spd_sys_user`;
CREATE TABLE `spd_sys_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `login_name` varchar(50) NOT NULL COMMENT '用户登录系统的名称',
  `password` varchar(100) NOT NULL COMMENT '密码',
  `phone` varchar(20) DEFAULT NULL COMMENT '手机号',
  `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
  `headimgurl` varchar(500) DEFAULT NULL COMMENT '用户头像',
  `truename` varchar(50) DEFAULT NULL COMMENT '真实姓名',
  `gender` tinyint(4) DEFAULT '0' COMMENT '性别，0表示保密，1表示男性，2表示女性',
  `status` tinyint(4) DEFAULT '1' COMMENT '状态，1表示正常，0表示已禁用',
  `type` tinyint(4) DEFAULT '1' COMMENT '用户类型，1表示普通用户，2表示超级用户（后台看不见）',
  `sys_dept_id` bigint(20) DEFAULT '0' COMMENT '外键spd_sys_dept.id',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后一次登录时间',
  `last_login_ip` varchar(100) DEFAULT NULL COMMENT '最后一次登录ip',
  `openid` varchar(50) DEFAULT NULL COMMENT '微信openid',
  `login_count` bigint(20) DEFAULT '0' COMMENT '登录次数',
  `operate_time` datetime DEFAULT NULL COMMENT '创建/修改时间',
  `operate_id` bigint(20) DEFAULT NULL COMMENT '创建/修改id',
  PRIMARY KEY (`id`),
  KEY `login_name` (`login_name`),
  KEY `sys_dept_id` (`sys_dept_id`),
  KEY `openid` (`openid`)
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8 COMMENT='系统用户';

-- ----------------------------
-- Records of spd_sys_user
-- ----------------------------
INSERT INTO `spd_sys_user` VALUES ('9', 'admin', '8a8a00532ef1b26570b564346018fa4f', null, null, null, 'admin', '0', '1', '2', '1', '2018-05-05 21:29:52', '127.0.0.1', null, '886', null, null);
INSERT INTO `spd_sys_user` VALUES ('17', 'Administrator', '8a8a00532ef1b26570b564346018fa4f', '', '', '', 'Administrator', '0', '1', '1', '7', '2017-09-13 22:33:03', '180.139.210.161', null, '3', null, null);
INSERT INTO `spd_sys_user` VALUES ('18', 'test', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '测试员', '0', '1', '2', '7', '2017-08-17 21:33:02', '0:0:0:0:0:0:0:1', null, '15', null, null);
INSERT INTO `spd_sys_user` VALUES ('19', '桃源测试员', '8a8a00532ef1b26570b564346018fa4f', '', '', '/upload/admin/avatar/7884a49b-47f2-4e42-98a3-c3bcd7fc4a8c.JPG', '桃源测试员', '0', '1', '1', '9', '2017-09-06 08:52:36', '180.139.209.229', null, '18', null, null);
INSERT INTO `spd_sys_user` VALUES ('20', '飞凤测试员', '8a8a00532ef1b26570b564346018fa4f', '', '', '/upload/admin/avatar/7884a49b-47f2-4e42-98a3-c3bcd7fc4a8c.JPG', '飞凤测试员', '0', '1', '1', '10', '2017-08-28 12:11:20', '171.111.45.231', null, '4', null, null);
INSERT INTO `spd_sys_user` VALUES ('23', '桃源领导', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '桃源领导', '0', '1', '1', '9', '2017-09-05 15:32:44', '171.111.44.123', null, '2', null, null);
INSERT INTO `spd_sys_user` VALUES ('26', '周诚敢', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '周诚敢', '0', '1', '1', '8', '2018-01-12 12:02:58', '139.226.87.142', null, '208', null, null);
INSERT INTO `spd_sys_user` VALUES ('27', '青秀区测试员', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '青秀区测试员', '0', '1', '1', '8', '2017-08-25 21:04:42', '180.139.210.40', null, '1', null, null);
INSERT INTO `spd_sys_user` VALUES ('28', '青秀核名测试员', '8a8a00532ef1b26570b564346018fa4f', '', '', '/upload/admin/avatar/bac0b310-f12a-432e-a453-2c5332ea520e.jpg', '青秀核名测试员', '0', '1', '1', '8', '2017-09-05 16:12:07', '171.111.44.123', null, '3', null, null);
INSERT INTO `spd_sys_user` VALUES ('31', 'LGZ', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '股长', '0', '1', '1', '8', '2017-09-13 09:07:16', '113.12.66.42', null, '6', null, null);
INSERT INTO `spd_sys_user` VALUES ('32', '潘彦', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '潘彦', '0', '1', '1', '8', '2017-09-07 17:33:26', '117.141.135.34', null, '9', null, null);
INSERT INTO `spd_sys_user` VALUES ('33', '789', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '789', '0', '1', '1', '8', '2017-09-06 16:15:52', '117.141.135.34', null, '3', null, null);
INSERT INTO `spd_sys_user` VALUES ('34', '菲菲', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '菲姐', '0', '1', '1', '8', '2017-09-08 11:54:32', '113.12.66.42', null, '2', null, null);
INSERT INTO `spd_sys_user` VALUES ('36', '123', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '领导', '0', '1', '1', '8', '2017-09-16 12:19:38', '113.15.140.82', null, '16', null, null);
INSERT INTO `spd_sys_user` VALUES ('37', '456', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '审批员', '0', '1', '1', '8', '2017-09-25 17:00:23', '113.12.66.42', null, '4', null, null);
INSERT INTO `spd_sys_user` VALUES ('39', '梁花春', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '梁花春', '0', '1', '1', '8', '2017-09-19 22:25:58', '113.16.56.212', null, '24', null, null);
INSERT INTO `spd_sys_user` VALUES ('41', '孙声宇', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '孙声宇', '0', '1', '1', '8', '2018-01-19 16:01:36', '113.12.66.42', null, '11', null, null);
INSERT INTO `spd_sys_user` VALUES ('42', '潘邦玲', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '潘邦玲', '0', '1', '1', '8', '2017-11-07 09:54:44', '113.12.66.42', null, '38', null, null);
INSERT INTO `spd_sys_user` VALUES ('43', '李玲芳', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '李玲芳', '0', '1', '1', '8', '2017-09-30 15:35:47', '113.12.66.42', null, '40', null, null);
INSERT INTO `spd_sys_user` VALUES ('44', '卢雯婷', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '卢雯婷', '0', '1', '1', '8', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('45', '凌舒琳', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '凌舒琳', '0', '1', '1', '8', '2017-09-13 14:52:58', '113.12.66.42', null, '1', null, null);
INSERT INTO `spd_sys_user` VALUES ('46', '雷瑶', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '雷瑶', '0', '1', '1', '8', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('47', '梁然星', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '梁然星', '0', '1', '1', '8', '2017-09-14 08:54:53', '113.12.66.42', null, '1', null, null);
INSERT INTO `spd_sys_user` VALUES ('48', '李欢欢', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '李欢欢', '0', '1', '1', '8', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('49', '曲菲菲', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '曲菲菲', '0', '1', '1', '8', '2017-09-14 09:10:33', '113.12.66.42', null, '7', null, null);
INSERT INTO `spd_sys_user` VALUES ('50', '周海萍', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '周海萍', '0', '1', '1', '8', '2017-09-28 12:57:48', '113.12.66.42', null, '5', null, null);
INSERT INTO `spd_sys_user` VALUES ('51', '陈崇', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '陈崇', '0', '1', '1', '8', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('52', '陈永玲', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '陈永玲', '0', '1', '1', '8', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('53', '潘红云', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '潘红云', '0', '1', '1', '8', '2017-09-15 10:40:03', '113.12.66.42', null, '2', null, null);
INSERT INTO `spd_sys_user` VALUES ('54', '保燕飞', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '保燕飞', '0', '1', '1', '8', '2017-09-13 16:57:22', '117.141.135.34', null, '2', null, null);
INSERT INTO `spd_sys_user` VALUES ('55', '罗素菊', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '罗素菊', '0', '1', '1', '8', '2017-09-27 15:48:52', '113.12.66.42', null, '6', null, null);
INSERT INTO `spd_sys_user` VALUES ('57', '蓝玉凤', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '蓝玉凤', '0', '1', '1', '8', '2017-12-27 08:37:02', '113.15.138.20', null, '16', null, null);
INSERT INTO `spd_sys_user` VALUES ('58', '韦珍玲', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '韦珍玲', '0', '1', '1', '8', '2017-09-13 17:36:32', '117.141.135.34', null, '1', null, null);
INSERT INTO `spd_sys_user` VALUES ('59', '覃建高', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '覃建高', '0', '1', '1', '8', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('60', '杨星', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '杨星', '0', '1', '1', '8', '2017-09-12 21:01:30', '180.139.210.161', null, '1', null, null);
INSERT INTO `spd_sys_user` VALUES ('61', '廖建华', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '廖建华', '0', '1', '1', '8', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('62', '钟云翔', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '钟云翔', '0', '1', '1', '11', '2017-09-30 09:19:08', '113.12.66.42', null, '15', null, null);
INSERT INTO `spd_sys_user` VALUES ('63', '陆荣莉', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '陆荣莉', '0', '1', '1', '11', '2017-09-19 10:28:26', '113.12.66.42', null, '3', null, null);
INSERT INTO `spd_sys_user` VALUES ('64', '黄小玲', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '黄小玲', '0', '1', '1', '11', '2017-09-22 16:48:10', '113.12.66.42', null, '6', null, null);
INSERT INTO `spd_sys_user` VALUES ('65', '陈莹', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '陈莹', '0', '1', '1', '11', '2017-09-19 10:17:46', '113.12.66.42', null, '1', null, null);
INSERT INTO `spd_sys_user` VALUES ('66', '赵红燕', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '赵红燕', '0', '1', '1', '11', '2017-09-25 16:15:24', '113.12.66.42', null, '7', null, null);
INSERT INTO `spd_sys_user` VALUES ('67', '谢敏', '33de0696a53eb1d54931c3444667977f', '', '', '', '谢敏', '0', '1', '1', '15', '2017-09-20 09:32:10', '113.12.66.42', null, '1', null, null);
INSERT INTO `spd_sys_user` VALUES ('68', '王洋', 'bad052566291db01e3b4779c1466ac59', '', '', '', '王洋', '0', '1', '1', '15', '2017-09-22 08:14:41', '113.12.66.42', null, '9', null, null);
INSERT INTO `spd_sys_user` VALUES ('69', '孙祖佳', 'f5760d139a103913db1cc889289cfca2', '', '', '', '孙祖佳', '0', '1', '1', '15', '2017-09-28 08:26:46', '113.12.66.42', null, '2', null, null);
INSERT INTO `spd_sys_user` VALUES ('70', '王婷玉', '4357de63164c3fafec69ad706e626965', '', '', '', '王婷玉', '0', '1', '1', '15', '2017-09-30 12:45:02', '113.12.66.42', null, '8', null, null);
INSERT INTO `spd_sys_user` VALUES ('71', '肖芝芝', '12b336e816b89ef9268973e34f63a044', '', '', '', '肖芝芝', '0', '1', '1', '15', '2017-09-14 10:38:14', '113.12.66.42', null, '2', null, null);
INSERT INTO `spd_sys_user` VALUES ('72', '张美月', '35d8a81931785a628be53dcfc5abd5ba', '', '', '', '张美月', '0', '1', '1', '16', '2017-09-30 17:14:38', '116.10.162.97', null, '29', null, null);
INSERT INTO `spd_sys_user` VALUES ('73', '廖柏富', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '廖柏富', '0', '1', '1', '16', '2017-09-30 15:01:17', '116.10.162.97', null, '2', null, null);
INSERT INTO `spd_sys_user` VALUES ('74', '石琦', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '石琦', '0', '1', '1', '16', '2017-09-30 17:05:18', '116.10.162.97', null, '5', null, null);
INSERT INTO `spd_sys_user` VALUES ('75', '莫莉', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '莫莉', '0', '1', '1', '10', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('76', '阮华琼', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '阮华琼', '0', '1', '1', '10', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('77', '陆少梅', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '陆少梅', '0', '1', '1', '10', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('78', '粟宁', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '粟宁', '0', '1', '1', '10', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('79', '蒙萍', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '蒙萍', '0', '1', '1', '10', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('80', '黄珍', '7f13e3f1e6720fa6d5ca485edcc13834', '', '', '', '黄珍', '0', '1', '1', '13', '2017-09-22 10:54:30', '117.136.97.71', null, '8', null, null);
INSERT INTO `spd_sys_user` VALUES ('81', '谢秀群', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '谢秀群', '0', '1', '1', '13', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('82', '杨敏', '0a406af888446fab36f38e80d026303e', '', '', '', '杨敏', '0', '1', '1', '13', '2017-09-28 09:20:14', '223.104.22.179', null, '8', null, null);
INSERT INTO `spd_sys_user` VALUES ('83', '黄露仪', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '黄露仪', '0', '1', '1', '13', '2017-09-14 09:03:48', '113.12.66.42', null, '1', null, null);
INSERT INTO `spd_sys_user` VALUES ('84', '程月华', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '程月华', '0', '1', '1', '13', '2017-10-04 06:39:44', '223.104.90.70', null, '24', null, null);
INSERT INTO `spd_sys_user` VALUES ('85', '农晓梅', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '农晓梅', '0', '1', '1', '13', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('86', '梁冰', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '梁冰', '0', '1', '1', '12', '2017-09-28 15:40:08', '117.141.131.42', null, '2', null, null);
INSERT INTO `spd_sys_user` VALUES ('87', '莫腾', '44f9699f3c8234432569d76d872ac7f3', '', '', '', '莫腾', '0', '1', '1', '12', '2017-09-30 15:38:41', '113.12.66.42', null, '26', null, null);
INSERT INTO `spd_sys_user` VALUES ('88', '刘小乔', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '刘小乔', '0', '1', '1', '17', '2017-09-28 15:55:08', '222.216.163.24', null, '1', null, null);
INSERT INTO `spd_sys_user` VALUES ('89', '孔庆有', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '孔庆有', '0', '1', '1', '17', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('90', '刘纯', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '刘纯', '0', '1', '1', '17', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('91', '何红', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '何红', '0', '1', '1', '14', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('92', '高秋丽', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '高秋丽', '0', '1', '1', '14', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('93', '林丽', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '林丽', '0', '1', '1', '14', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('94', '谢雨雷', '9d389e12fe250a2dca9e6e30380f6e92', '', '', '', '谢雨雷', '0', '1', '1', '14', '2017-09-14 11:11:14', '113.12.66.42', null, '2', null, null);
INSERT INTO `spd_sys_user` VALUES ('95', '黄海燕', '367082832b9456440183ce3662b7350d', '', '', '', '黄海燕', '0', '1', '1', '18', '2017-10-03 01:54:14', '113.12.26.178', null, '13', null, null);
INSERT INTO `spd_sys_user` VALUES ('96', '马克', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '马克', '0', '1', '1', '18', '2017-09-15 09:00:30', '180.136.144.134', null, '1', null, null);
INSERT INTO `spd_sys_user` VALUES ('97', '陆晓红', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '陆晓红', '0', '1', '1', '18', '2017-09-15 08:33:44', '180.136.145.152', null, '2', null, null);
INSERT INTO `spd_sys_user` VALUES ('98', '黎玉冰', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '黎玉冰', '0', '1', '1', '18', '2017-09-15 08:32:55', '180.136.145.152', null, '3', null, null);
INSERT INTO `spd_sys_user` VALUES ('99', '黄秋原', 'f662b1b1728e402850e3e92bcedeafff', '', '', '', '黄秋原', '0', '1', '1', '9', '2017-09-19 08:38:32', '113.12.66.42', null, '2', null, null);
INSERT INTO `spd_sys_user` VALUES ('100', '韦婷', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '韦婷', '0', '1', '1', '9', '2017-09-29 11:11:24', '113.12.66.42', null, '19', null, null);
INSERT INTO `spd_sys_user` VALUES ('101', '李海浪', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '李海浪', '0', '1', '1', '9', '2017-09-26 17:18:49', '113.12.66.42', null, '7', null, null);
INSERT INTO `spd_sys_user` VALUES ('102', '赵伟', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '赵伟', '0', '1', '1', '19', '2017-09-26 09:53:02', '180.141.57.125', null, '4', null, null);
INSERT INTO `spd_sys_user` VALUES ('103', '罗色凤', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '罗色凤', '0', '1', '1', '19', '2017-09-25 10:08:17', '180.141.58.242', null, '4', null, null);
INSERT INTO `spd_sys_user` VALUES ('104', '陆德斌', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '陆德斌', '0', '1', '1', '19', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('105', '龙明剑', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '龙明剑', '0', '1', '1', '20', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('106', '韦芳泉', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '韦芳泉', '0', '1', '1', '20', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('107', '黄健', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '黄健', '0', '1', '1', '22', null, null, null, '0', null, null);
INSERT INTO `spd_sys_user` VALUES ('108', '冯志方', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '冯志方', '0', '1', '1', '21', '2017-09-28 01:20:22', '0:0:0:0:0:0:0:1', null, '2', null, null);
INSERT INTO `spd_sys_user` VALUES ('109', '周伟', '226d10066c9d5ecc44f51616aac51a08', '', '', '', '周伟', '0', '1', '1', '21', '2017-09-28 16:23:52', '219.159.141.247', null, '4', null, null);
INSERT INTO `spd_sys_user` VALUES ('110', '郑小兰', '8a8a00532ef1b26570b564346018fa4f', '', '', '', '郑小兰', '0', '1', '1', '23', '2017-12-27 08:30:37', '113.15.138.20', null, '2', null, null);

-- ----------------------------
-- Table structure for `spd_sys_user_role`
-- ----------------------------
DROP TABLE IF EXISTS `spd_sys_user_role`;
CREATE TABLE `spd_sys_user_role` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `sys_user_id` bigint(20) NOT NULL COMMENT '外键spd_sys_user.id',
  `sys_role_id` bigint(20) NOT NULL COMMENT '外键spd_sys_role.id',
  PRIMARY KEY (`id`),
  KEY `sys_user_id_sys_role_id` (`sys_user_id`,`sys_role_id`),
  KEY `sys_role_id` (`sys_role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=257 DEFAULT CHARSET=utf8 COMMENT='用户角色关联';

-- ----------------------------
-- Records of spd_sys_user_role
-- ----------------------------
INSERT INTO `spd_sys_user_role` VALUES ('128', '17', '3');
INSERT INTO `spd_sys_user_role` VALUES ('77', '18', '9');
INSERT INTO `spd_sys_user_role` VALUES ('106', '19', '9');
INSERT INTO `spd_sys_user_role` VALUES ('92', '20', '9');
INSERT INTO `spd_sys_user_role` VALUES ('107', '23', '8');
INSERT INTO `spd_sys_user_role` VALUES ('243', '26', '3');
INSERT INTO `spd_sys_user_role` VALUES ('99', '27', '9');
INSERT INTO `spd_sys_user_role` VALUES ('108', '28', '12');
INSERT INTO `spd_sys_user_role` VALUES ('136', '31', '8');
INSERT INTO `spd_sys_user_role` VALUES ('137', '31', '9');
INSERT INTO `spd_sys_user_role` VALUES ('138', '31', '10');
INSERT INTO `spd_sys_user_role` VALUES ('139', '31', '11');
INSERT INTO `spd_sys_user_role` VALUES ('140', '31', '12');
INSERT INTO `spd_sys_user_role` VALUES ('141', '31', '13');
INSERT INTO `spd_sys_user_role` VALUES ('115', '32', '9');
INSERT INTO `spd_sys_user_role` VALUES ('116', '32', '11');
INSERT INTO `spd_sys_user_role` VALUES ('117', '32', '12');
INSERT INTO `spd_sys_user_role` VALUES ('118', '32', '13');
INSERT INTO `spd_sys_user_role` VALUES ('119', '33', '12');
INSERT INTO `spd_sys_user_role` VALUES ('120', '34', '9');
INSERT INTO `spd_sys_user_role` VALUES ('121', '34', '12');
INSERT INTO `spd_sys_user_role` VALUES ('162', '36', '8');
INSERT INTO `spd_sys_user_role` VALUES ('163', '36', '9');
INSERT INTO `spd_sys_user_role` VALUES ('164', '36', '11');
INSERT INTO `spd_sys_user_role` VALUES ('165', '36', '12');
INSERT INTO `spd_sys_user_role` VALUES ('166', '36', '13');
INSERT INTO `spd_sys_user_role` VALUES ('125', '37', '9');
INSERT INTO `spd_sys_user_role` VALUES ('142', '39', '9');
INSERT INTO `spd_sys_user_role` VALUES ('143', '39', '12');
INSERT INTO `spd_sys_user_role` VALUES ('153', '41', '12');
INSERT INTO `spd_sys_user_role` VALUES ('146', '42', '12');
INSERT INTO `spd_sys_user_role` VALUES ('147', '43', '9');
INSERT INTO `spd_sys_user_role` VALUES ('148', '44', '9');
INSERT INTO `spd_sys_user_role` VALUES ('149', '45', '9');
INSERT INTO `spd_sys_user_role` VALUES ('150', '46', '9');
INSERT INTO `spd_sys_user_role` VALUES ('151', '47', '9');
INSERT INTO `spd_sys_user_role` VALUES ('152', '48', '9');
INSERT INTO `spd_sys_user_role` VALUES ('154', '49', '8');
INSERT INTO `spd_sys_user_role` VALUES ('155', '50', '8');
INSERT INTO `spd_sys_user_role` VALUES ('156', '51', '8');
INSERT INTO `spd_sys_user_role` VALUES ('157', '52', '8');
INSERT INTO `spd_sys_user_role` VALUES ('158', '53', '8');
INSERT INTO `spd_sys_user_role` VALUES ('159', '54', '8');
INSERT INTO `spd_sys_user_role` VALUES ('160', '55', '8');
INSERT INTO `spd_sys_user_role` VALUES ('255', '57', '8');
INSERT INTO `spd_sys_user_role` VALUES ('256', '57', '10');
INSERT INTO `spd_sys_user_role` VALUES ('169', '58', '11');
INSERT INTO `spd_sys_user_role` VALUES ('170', '58', '13');
INSERT INTO `spd_sys_user_role` VALUES ('173', '59', '11');
INSERT INTO `spd_sys_user_role` VALUES ('174', '59', '13');
INSERT INTO `spd_sys_user_role` VALUES ('171', '60', '11');
INSERT INTO `spd_sys_user_role` VALUES ('172', '60', '13');
INSERT INTO `spd_sys_user_role` VALUES ('167', '61', '11');
INSERT INTO `spd_sys_user_role` VALUES ('168', '61', '13');
INSERT INTO `spd_sys_user_role` VALUES ('177', '62', '8');
INSERT INTO `spd_sys_user_role` VALUES ('178', '62', '9');
INSERT INTO `spd_sys_user_role` VALUES ('176', '63', '8');
INSERT INTO `spd_sys_user_role` VALUES ('179', '64', '9');
INSERT INTO `spd_sys_user_role` VALUES ('180', '65', '9');
INSERT INTO `spd_sys_user_role` VALUES ('181', '66', '9');
INSERT INTO `spd_sys_user_role` VALUES ('185', '67', '8');
INSERT INTO `spd_sys_user_role` VALUES ('186', '67', '9');
INSERT INTO `spd_sys_user_role` VALUES ('183', '68', '8');
INSERT INTO `spd_sys_user_role` VALUES ('184', '68', '9');
INSERT INTO `spd_sys_user_role` VALUES ('187', '69', '9');
INSERT INTO `spd_sys_user_role` VALUES ('188', '70', '9');
INSERT INTO `spd_sys_user_role` VALUES ('190', '71', '9');
INSERT INTO `spd_sys_user_role` VALUES ('191', '72', '8');
INSERT INTO `spd_sys_user_role` VALUES ('192', '72', '9');
INSERT INTO `spd_sys_user_role` VALUES ('193', '73', '9');
INSERT INTO `spd_sys_user_role` VALUES ('194', '74', '9');
INSERT INTO `spd_sys_user_role` VALUES ('195', '75', '8');
INSERT INTO `spd_sys_user_role` VALUES ('196', '75', '9');
INSERT INTO `spd_sys_user_role` VALUES ('198', '76', '8');
INSERT INTO `spd_sys_user_role` VALUES ('199', '77', '9');
INSERT INTO `spd_sys_user_role` VALUES ('200', '78', '9');
INSERT INTO `spd_sys_user_role` VALUES ('201', '79', '9');
INSERT INTO `spd_sys_user_role` VALUES ('202', '80', '8');
INSERT INTO `spd_sys_user_role` VALUES ('203', '80', '9');
INSERT INTO `spd_sys_user_role` VALUES ('204', '81', '8');
INSERT INTO `spd_sys_user_role` VALUES ('205', '82', '8');
INSERT INTO `spd_sys_user_role` VALUES ('206', '83', '9');
INSERT INTO `spd_sys_user_role` VALUES ('207', '84', '9');
INSERT INTO `spd_sys_user_role` VALUES ('208', '85', '9');
INSERT INTO `spd_sys_user_role` VALUES ('209', '86', '8');
INSERT INTO `spd_sys_user_role` VALUES ('210', '86', '9');
INSERT INTO `spd_sys_user_role` VALUES ('211', '87', '9');
INSERT INTO `spd_sys_user_role` VALUES ('212', '88', '8');
INSERT INTO `spd_sys_user_role` VALUES ('213', '88', '9');
INSERT INTO `spd_sys_user_role` VALUES ('214', '89', '9');
INSERT INTO `spd_sys_user_role` VALUES ('215', '90', '9');
INSERT INTO `spd_sys_user_role` VALUES ('216', '91', '8');
INSERT INTO `spd_sys_user_role` VALUES ('217', '91', '9');
INSERT INTO `spd_sys_user_role` VALUES ('218', '92', '8');
INSERT INTO `spd_sys_user_role` VALUES ('219', '93', '9');
INSERT INTO `spd_sys_user_role` VALUES ('220', '94', '9');
INSERT INTO `spd_sys_user_role` VALUES ('221', '95', '8');
INSERT INTO `spd_sys_user_role` VALUES ('222', '95', '9');
INSERT INTO `spd_sys_user_role` VALUES ('223', '96', '8');
INSERT INTO `spd_sys_user_role` VALUES ('224', '97', '9');
INSERT INTO `spd_sys_user_role` VALUES ('225', '98', '9');
INSERT INTO `spd_sys_user_role` VALUES ('226', '99', '8');
INSERT INTO `spd_sys_user_role` VALUES ('227', '99', '9');
INSERT INTO `spd_sys_user_role` VALUES ('228', '100', '9');
INSERT INTO `spd_sys_user_role` VALUES ('229', '101', '9');
INSERT INTO `spd_sys_user_role` VALUES ('230', '102', '8');
INSERT INTO `spd_sys_user_role` VALUES ('231', '102', '9');
INSERT INTO `spd_sys_user_role` VALUES ('232', '103', '9');
INSERT INTO `spd_sys_user_role` VALUES ('233', '104', '9');
INSERT INTO `spd_sys_user_role` VALUES ('234', '105', '8');
INSERT INTO `spd_sys_user_role` VALUES ('235', '105', '9');
INSERT INTO `spd_sys_user_role` VALUES ('236', '106', '9');
INSERT INTO `spd_sys_user_role` VALUES ('237', '107', '8');
INSERT INTO `spd_sys_user_role` VALUES ('238', '107', '9');
INSERT INTO `spd_sys_user_role` VALUES ('239', '108', '8');
INSERT INTO `spd_sys_user_role` VALUES ('240', '108', '9');
INSERT INTO `spd_sys_user_role` VALUES ('241', '109', '8');
INSERT INTO `spd_sys_user_role` VALUES ('242', '109', '9');
INSERT INTO `spd_sys_user_role` VALUES ('249', '110', '8');
INSERT INTO `spd_sys_user_role` VALUES ('250', '110', '9');
INSERT INTO `spd_sys_user_role` VALUES ('251', '110', '10');
INSERT INTO `spd_sys_user_role` VALUES ('252', '110', '11');
INSERT INTO `spd_sys_user_role` VALUES ('253', '110', '12');
INSERT INTO `spd_sys_user_role` VALUES ('254', '110', '13');
