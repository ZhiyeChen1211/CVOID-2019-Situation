CREATE DATABASE IF NOT EXISTS CVOID2019;

USE CVOID2019;

CREATE TABLE IF NOT EXISTS `detailCount` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `province_name` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `current_confirmed_count` int(11) NOT NULL,
  `confirmed_count` int(11) NOT NULL,
  `dead_count` int(11) NOT NULL,
  `cured_count` int(11) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE `unique_idx`(`province_name`, `date`)
) ENGINE = InnoDB AUTO_INCREMENT = 0 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

DROP PROCEDURE IF EXISTS totalSum;

DELIMITER @@

CREATE PROCEDURE totalSum()
BEGIN
  SET @totalDeadCount=(SELECT SUM(dead_count) FROM (SELECT dead_count FROM `detailCount` ORDER BY `date` DESC LIMIT 34) AS temp);
  SET @totalCuredCount=(SELECT SUM(cured_count) FROM (SELECT cured_count FROM `detailCount` ORDER BY `date` DESC LIMIT 34) AS temp);
  SET @totalConfirmedCount=(SELECT SUM(confirmed_count) FROM (SELECT confirmed_count FROM `detailCount` ORDER BY `date` DESC LIMIT 34) AS temp);
  SET @totalCurrentConfirmedCount=(SELECT SUM(current_confirmed_count) FROM (SELECT current_confirmed_count FROM `detailCount` ORDER BY `date` DESC LIMIT 34) AS temp);

  UPDATE 
    `detailCount` 
  SET 
    `dead_count` = @totalDeadCount, 
    `cured_count` = @totalCuredCount, 
    `confirmed_count` = @totalConfirmedCount, 
    `current_confirmed_count` = @totalCurrentConfirmedCount 
  WHERE  `province_name` = '全国';
    
  -- 全国疫情
  SELECT `province_name`          AS '省份', 
         `current_confirmed_count` AS '近期确诊', 
         `confirmed_count`        AS '总计确诊', 
         `dead_count`             AS '总计死亡', 
         `cured_count`            AS '总计治愈' 
  FROM   `detailcount` 
  WHERE  `province_name` = '全国'; 

  -- 确诊最多 
  SELECT `province_name`          AS '确诊最多', 
         `current_confirmed_count` AS '近期确诊', 
         `confirmed_count`        AS '总计确诊', 
         `dead_count`             AS '总计死亡', 
         `cured_count`            AS '总计治愈' 
  FROM   `detailcount` 
  WHERE  `confirmed_count` = (SELECT MAX(`confirmed_count`) 
                           FROM   (SELECT `confirmed_count`
                                   FROM   `detailcount` 
                                   ORDER  BY `date` DESC 
                                   LIMIT  34) AS temp) 
  LIMIT  1; 

  -- 确诊最少 
  SELECT `province_name`          AS '确诊最少', 
         `current_confirmed_count` AS '近期确诊', 
         `confirmed_count`        AS '总计确诊', 
         `dead_count`             AS '总计死亡', 
         `cured_count`            AS '总计治愈' 
  FROM   `detailcount` 
  WHERE  `confirmed_count` = (SELECT MIN(`confirmed_count`) 
                           FROM   (SELECT `confirmed_count`
                                   FROM   `detailcount` 
                                   ORDER  BY `date` DESC 
                                   LIMIT  34) AS temp) 
  LIMIT  1;

  -- 福建省近10天疫情情况
  SELECT `date`                  AS '日期', 
         `province_name`          AS '省份', 
         `current_confirmed_count` AS '近期确诊', 
         `confirmed_count`        AS '总计确诊', 
         `dead_count`             AS '总计死亡', 
         `cured_count`            AS '总计治愈' 
  FROM   `detailcount` 
  WHERE  `province_name` = '福建省' 
  ORDER BY `date` DESC
  LIMIT  10;
END@@

DELIMITER ;

INSERT IGNORE INTO detailCount (`id`, `date`, `province_name`, `current_confirmed_count`, `confirmed_count`, `dead_count`, `cured_count`) 
VALUES 
(0, '1970-01-01', '全国', '', '', '', '');

INSERT IGNORE INTO detailCount (date, province_name, current_confirmed_count, confirmed_count, dead_count, cured_count) VALUES
('2022-05-01', '香港', 261858, 330670, 9308, 59504),
('2022-05-01', '台湾', 118388, 132995, 865, 13742),
('2022-05-01', '上海市', 20265, 58341, 429, 37647),
('2022-05-01', '吉林省', 1420, 40211, 5, 38786),
('2022-05-01', '浙江省', 804, 3109, 1, 2304),
('2022-05-01', '北京市', 319, 2155, 9, 1827),
('2022-05-01', '黑龙江省', 283, 2943, 13, 2647),
('2022-05-01', '江西省', 256, 1369, 1, 1112),
('2022-05-01', '广东省', 184, 7054, 8, 6862),
('2022-05-01', '山东省', 67, 2717, 7, 2643),
('2022-05-01', '四川省', 67, 2049, 3, 1979),
('2022-05-01', '内蒙古自治区', 59, 1750, 1, 1690),
('2022-05-01', '福建省', 51, 3019, 1, 2967),
('2022-05-01', '江苏省', 45, 2203, 0, 2158),
('2022-05-01', '河南省', 40, 2906, 22, 2844),
('2022-05-01', '辽宁省', 35, 1645, 2, 1608),
('2022-05-01', '湖南省', 35, 1385, 4, 1346),
('2022-05-01', '山西省', 34, 418, 0, 384),
('2022-05-01', '云南省', 30, 2119, 2, 2087),
('2022-05-01', '青海省', 29, 95, 0, 66),
('2022-05-01', '海南省', 26, 288, 6, 256),
('2022-05-01', '广西壮族自治区', 20, 1584, 2, 1562),
('2022-05-01', '河北省', 18, 1998, 7, 1973),
('2022-05-01', '安徽省', 8, 1065, 6, 1051),
('2022-05-01', '新疆维吾尔自治区', 6, 1005, 3, 996),
('2022-05-01', '湖北省', 4, 68398, 4512, 63882),
('2022-05-01', '陕西省', 4, 3277, 3, 3270),
('2022-05-01', '重庆市', 4, 698, 6, 688),
('2022-05-01', '天津市', 1, 1803, 3, 1799),
('2022-05-01', '甘肃省', 0, 681, 2, 679),
('2022-05-01', '贵州省', 0, 179, 2, 177),
('2022-05-01', '宁夏回族自治区', 0, 122, 0, 122),
('2022-05-01', '澳门', 0, 82, 0, 82),
('2022-05-01', '西藏自治区', 0, 1, 0, 1);

INSERT IGNORE INTO detailCount (date, province_name, current_confirmed_count, confirmed_count, dead_count, cured_count) VALUES
('2022-05-02', '香港', 261751, 330725, 9313, 59661),
('2022-05-02', '台湾', 136198, 150808, 868, 13742),
('2022-05-02', '上海市', 16716, 59070, 461, 41893),
('2022-05-02', '吉林省', 1209, 40242, 5, 39028),
('2022-05-02', '浙江省', 793, 3111, 1, 2317),
('2022-05-02', '北京市', 345, 2191, 9, 1837),
('2022-05-02', '黑龙江省', 247, 2952, 13, 2692),
('2022-05-02', '江西省', 233, 1371, 1, 1137),
('2022-05-02', '广东省', 180, 7082, 8, 6894),
('2022-05-02', '四川省', 70, 2057, 3, 1984),
('2022-05-02', '山东省', 68, 2722, 7, 2647),
('2022-05-02', '内蒙古自治区', 59, 1751, 1, 1691),
('2022-05-02', '福建省', 47, 3022, 1, 2974),
('2022-05-02', '江苏省', 43, 2206, 0, 2163),
('2022-05-02', '河南省', 39, 2907, 22, 2846),
('2022-05-02', '辽宁省', 36, 1646, 2, 1608),
('2022-05-02', '山西省', 29, 418, 0, 389),
('2022-05-02', '云南省', 28, 2119, 2, 2089),
('2022-05-02', '湖南省', 28, 1385, 4, 1353),
('2022-05-02', '海南省', 26, 288, 6, 256),
('2022-05-02', '青海省', 25, 95, 0, 70),
('2022-05-02', '广西壮族自治区', 21, 1587, 2, 1564),
('2022-05-02', '河北省', 14, 1998, 7, 1977),
('2022-05-02', '新疆维吾尔自治区', 8, 1007, 3, 996),
('2022-05-02', '安徽省', 7, 1065, 6, 1052),
('2022-05-02', '湖北省', 4, 68398, 4512, 63882),
('2022-05-02', '重庆市', 4, 698, 6, 688),
('2022-05-02', '天津市', 2, 1804, 3, 1799),
('2022-05-02', '陕西省', 1, 3277, 3, 3273),
('2022-05-02', '甘肃省', 0, 681, 2, 679),
('2022-05-02', '贵州省', 0, 179, 2, 177),
('2022-05-02', '宁夏回族自治区', 0, 122, 0, 122),
('2022-05-02', '澳门', 0, 82, 0, 82),
('2022-05-02', '西藏自治区', 0, 1, 0, 1);

INSERT IGNORE INTO detailCount (date, province_name, current_confirmed_count, confirmed_count, dead_count, cured_count) VALUES
('2022-05-03', '香港', 261716, 330773, 9318, 59739),
('2022-05-03', '台湾', 159324, 173942, 876, 13742),
('2022-05-03', '上海市', 12988, 59344, 481, 45875),
('2022-05-03', '吉林省', 1058, 40242, 5, 39179),
('2022-05-03', '浙江省', 770, 3111, 1, 2340),
('2022-05-03', '北京市', 391, 2242, 9, 1842),
('2022-05-03', '黑龙江省', 230, 2965, 13, 2722),
('2022-05-03', '江西省', 220, 1376, 1, 1155),
('2022-05-03', '广东省', 169, 7091, 8, 6914),
('2022-05-03', '四川省', 74, 2063, 3, 1986),
('2022-05-03', '山东省', 70, 2725, 7, 2648),
('2022-05-03', '内蒙古自治区', 60, 1752, 1, 1691),
('2022-05-03', '福建省', 50, 3031, 1, 2980),
('2022-05-03', '辽宁省', 40, 1651, 2, 1609),
('2022-05-03', '河南省', 36, 2909, 22, 2851),
('2022-05-03', '江苏省', 30, 2206, 0, 2176),
('2022-05-03', '云南省', 27, 2119, 2, 2090),
('2022-05-03', '山西省', 27, 420, 0, 393),
('2022-05-03', '湖南省', 26, 1385, 4, 1355),
('2022-05-03', '海南省', 25, 288, 6, 257),
('2022-05-03', '广西壮族自治区', 23, 1590, 2, 1565),
('2022-05-03', '青海省', 20, 95, 0, 75),
('2022-05-03', '河北省', 13, 1998, 7, 1978),
('2022-05-03', '新疆维吾尔自治区', 8, 1007, 3, 996),
('2022-05-03', '安徽省', 7, 1065, 6, 1052),
('2022-05-03', '重庆市', 5, 699, 6, 688),
('2022-05-03', '湖北省', 4, 68398, 4512, 63882),
('2022-05-03', '天津市', 2, 1804, 3, 1799),
('2022-05-03', '陕西省', 1, 3277, 3, 3273),
('2022-05-03', '甘肃省', 0, 681, 2, 679),
('2022-05-03', '贵州省', 0, 179, 2, 177),
('2022-05-03', '宁夏回族自治区', 0, 122, 0, 122),
('2022-05-03', '澳门', 0, 82, 0, 82),
('2022-05-03', '西藏自治区', 0, 1, 0, 1);

INSERT IGNORE INTO detailCount (date, province_name, current_confirmed_count, confirmed_count, dead_count, cured_count) VALUES
('2022-05-04', '香港', 261741, 330880, 9325, 59814),
('2022-05-04', '台湾', 187795, 202418, 881, 13742),
('2022-05-04', '上海市', 11366, 59607, 497, 47744),
('2022-05-04', '吉林省', 987, 40245, 5, 39253),
('2022-05-04', '浙江省', 747, 3114, 1, 2366),
('2022-05-04', '北京市', 430, 2289, 9, 1850),
('2022-05-04', '江西省', 204, 1378, 1, 1173),
('2022-05-04', '黑龙江省', 195, 2972, 13, 2764),
('2022-05-04', '广东省', 168, 7103, 8, 6927),
('2022-05-04', '四川省', 72, 2064, 3, 1989),
('2022-05-04', '山东省', 70, 2729, 7, 2652),
('2022-05-04', '内蒙古自治区', 59, 1752, 1, 1692),
('2022-05-04', '福建省', 50, 3035, 1, 2984),
('2022-05-04', '河南省', 47, 2921, 22, 2852),
('2022-05-04', '辽宁省', 38, 1651, 2, 1611),
('2022-05-04', '江苏省', 28, 2209, 0, 2181),
('2022-05-04', '湖南省', 24, 1385, 4, 1357),
('2022-05-04', '山西省', 24, 420, 0, 396),
('2022-05-04', '广西壮族自治区', 23, 1590, 2, 1565),
('2022-05-04', '海南省', 23, 288, 6, 259),
('2022-05-04', '云南省', 20, 2119, 2, 2097),
('2022-05-04', '青海省', 17, 95, 0, 78),
('2022-05-04', '河北省', 11, 1998, 7, 1980),
('2022-05-04', '安徽省', 7, 1065, 6, 1052),
('2022-05-04', '新疆维吾尔自治区', 7, 1008, 3, 998),
('2022-05-04', '重庆市', 5, 699, 6, 688),
('2022-05-04', '湖北省', 3, 68398, 4512, 63883),
('2022-05-04', '天津市', 2, 1804, 3, 1799),
('2022-05-04', '陕西省', 1, 3277, 3, 3273),
('2022-05-04', '甘肃省', 0, 681, 2, 679),
('2022-05-04', '贵州省', 0, 179, 2, 177),
('2022-05-04', '宁夏回族自治区', 0, 122, 0, 122),
('2022-05-04', '澳门', 0, 82, 0, 82),
('2022-05-04', '西藏自治区', 0, 1, 0, 1);

INSERT IGNORE INTO detailCount (date, province_name, current_confirmed_count, confirmed_count, dead_count, cured_count) VALUES
('2022-05-05', '香港', 261678, 330982, 9328, 59976),
('2022-05-05', '台湾', 217774, 232402, 886, 13742),
('2022-05-05', '上海市', 9877, 59870, 510, 49483),
('2022-05-05', '浙江省', 753, 3124, 1, 2370),
('2022-05-05', '吉林省', 728, 40249, 5, 39516),
('2022-05-05', '北京市', 453, 2332, 9, 1870),
('2022-05-05', '黑龙江省', 182, 2977, 13, 2782),
('2022-05-05', '江西省', 176, 1381, 1, 1204),
('2022-05-05', '广东省', 173, 7119, 8, 6938),
('2022-05-05', '四川省', 71, 2065, 3, 1991),
('2022-05-05', '山东省', 70, 2731, 7, 2654),
('2022-05-05', '河南省', 55, 2935, 22, 2858),
('2022-05-05', '内蒙古自治区', 55, 1752, 1, 1696),
('2022-05-05', '福建省', 51, 3037, 1, 2985),
('2022-05-05', '辽宁省', 36, 1653, 2, 1615),
('2022-05-05', '江苏省', 26, 2212, 0, 2186),
('2022-05-05', '湖南省', 26, 1387, 4, 1357),
('2022-05-05', '广西壮族自治区', 22, 1592, 2, 1568),
('2022-05-05', '山西省', 22, 420, 0, 398),
('2022-05-05', '海南省', 22, 288, 6, 260),
('2022-05-05', '云南省', 20, 2120, 2, 2098),
('2022-05-05', '青海省', 13, 95, 0, 82),
('2022-05-05', '河北省', 11, 1998, 7, 1980),
('2022-05-05', '安徽省', 7, 1065, 6, 1052),
('2022-05-05', '重庆市', 5, 699, 6, 688),
('2022-05-05', '新疆维吾尔自治区', 4, 1008, 3, 1001),
('2022-05-05', '湖北省', 2, 68398, 4512, 63884),
('2022-05-05', '天津市', 2, 1804, 3, 1799),
('2022-05-05', '陕西省', 1, 3277, 3, 3273),
('2022-05-05', '甘肃省', 0, 681, 2, 679),
('2022-05-05', '贵州省', 0, 179, 2, 177),
('2022-05-05', '宁夏回族自治区', 0, 122, 0, 122),
('2022-05-05', '澳门', 0, 82, 0, 82),
('2022-05-05', '西藏自治区', 0, 1, 0, 1);

INSERT IGNORE INTO detailCount (date, province_name, current_confirmed_count, confirmed_count, dead_count, cured_count) VALUES
('2022-05-06', '香港', 261645, 331097, 9333, 60119),
('2022-05-06', '台湾', 253931, 268569, 896, 13742),
('2022-05-06', '上海市', 8720, 60115, 522, 50873),
('2022-05-06', '浙江省', 738, 3124, 1, 2385),
('2022-05-06', '吉林省', 679, 40251, 5, 39567),
('2022-05-06', '北京市', 502, 2387, 9, 1876),
('2022-05-06', '广东省', 176, 7134, 8, 6950),
('2022-05-06', '江西省', 146, 1383, 1, 1236),
('2022-05-06', '黑龙江省', 144, 2982, 13, 2825),
('2022-05-06', '河南省', 77, 2959, 22, 2860),
('2022-05-06', '四川省', 69, 2066, 3, 1994),
('2022-05-06', '山东省', 65, 2731, 7, 2659),
('2022-05-06', '福建省', 55, 3051, 1, 2995),
('2022-05-06', '内蒙古自治区', 51, 1752, 1, 1700),
('2022-05-06', '辽宁省', 38, 1655, 2, 1615),
('2022-05-06', '湖南省', 28, 1389, 4, 1357),
('2022-05-06', '江苏省', 23, 2213, 0, 2190),
('2022-05-06', '海南省', 21, 288, 6, 261),
('2022-05-06', '山西省', 19, 420, 0, 401),
('2022-05-06', '广西壮族自治区', 17, 1592, 2, 1573),
('2022-05-06', '云南省', 14, 2120, 2, 2104),
('2022-05-06', '河北省', 13, 2002, 7, 1982),
('2022-05-06', '青海省', 13, 95, 0, 82),
('2022-05-06', '安徽省', 6, 1065, 6, 1053),
('2022-05-06', '重庆市', 6, 700, 6, 688),
('2022-05-06', '湖北省', 2, 68398, 4512, 63884),
('2022-05-06', '天津市', 1, 1804, 3, 1800),
('2022-05-06', '新疆维吾尔自治区', 1, 1008, 3, 1004),
('2022-05-06', '贵州省', 1, 180, 2, 177),
('2022-05-06', '陕西省', 0, 3277, 3, 3274),
('2022-05-06', '甘肃省', 0, 681, 2, 679),
('2022-05-06', '宁夏回族自治区', 0, 122, 0, 122),
('2022-05-06', '澳门', 0, 82, 0, 82),
('2022-05-06', '西藏自治区', 0, 1, 0, 1);

INSERT IGNORE INTO detailCount (date, province_name, current_confirmed_count, confirmed_count, dead_count, cured_count) VALUES
('2022-05-07', '台湾', 300334, 314983, 907, 13742),
('2022-05-07', '香港', 261514, 331181, 9344, 60323),
('2022-05-07', '上海市', 7296, 60368, 535, 52537),
('2022-05-07', '浙江省', 737, 3126, 1, 2388),
('2022-05-07', '吉林省', 607, 40254, 5, 39642),
('2022-05-07', '北京市', 532, 2433, 9, 1892),
('2022-05-07', '广东省', 176, 7144, 8, 6960),
('2022-05-07', '江西省', 111, 1383, 1, 1271),
('2022-05-07', '河南省', 102, 2988, 22, 2864),
('2022-05-07', '黑龙江省', 97, 2982, 13, 2872),
('2022-05-07', '四川省', 68, 2067, 3, 1996),
('2022-05-07', '山东省', 64, 2732, 7, 2661),
('2022-05-07', '福建省', 56, 3053, 1, 2996),
('2022-05-07', '内蒙古自治区', 48, 1752, 1, 1703),
('2022-05-07', '辽宁省', 38, 1656, 2, 1616),
('2022-05-07', '湖南省', 30, 1391, 4, 1357),
('2022-05-07', '江苏省', 19, 2213, 0, 2194),
('2022-05-07', '海南省', 19, 288, 6, 263),
('2022-05-07', '山西省', 16, 420, 0, 404),
('2022-05-07', '广西壮族自治区', 15, 1592, 2, 1575),
('2022-05-07', '云南省', 13, 2120, 2, 2105),
('2022-05-07', '河北省', 13, 2002, 7, 1982),
('2022-05-07', '青海省', 12, 95, 0, 83),
('2022-05-07', '重庆市', 7, 701, 6, 688),
('2022-05-07', '安徽省', 6, 1065, 6, 1053),
('2022-05-07', '湖北省', 2, 68398, 4512, 63884),
('2022-05-07', '天津市', 1, 1804, 3, 1800),
('2022-05-07', '新疆维吾尔自治区', 1, 1008, 3, 1004),
('2022-05-07', '贵州省', 1, 180, 2, 177),
('2022-05-07', '陕西省', 0, 3277, 3, 3274),
('2022-05-07', '甘肃省', 0, 681, 2, 679),
('2022-05-07', '宁夏回族自治区', 0, 122, 0, 122),
('2022-05-07', '澳门', 0, 82, 0, 82),
('2022-05-07', '西藏自治区', 0, 1, 0, 1);

INSERT IGNORE INTO detailCount (date, province_name, current_confirmed_count, confirmed_count, dead_count, cured_count) VALUES
('2022-05-08', '台湾', 342622, 357271, 907, 13742),
('2022-05-08', '香港', 261404, 331231, 9344, 60483),
('2022-05-08', '上海市', 6564, 60585, 543, 53478),
('2022-05-08', '浙江省', 720, 3127, 1, 2406),
('2022-05-08', '北京市', 566, 2477, 9, 1902),
('2022-05-08', '吉林省', 551, 40257, 5, 39701),
('2022-05-08', '广东省', 184, 7166, 8, 6974),
('2022-05-08', '河南省', 125, 3013, 22, 2866),
('2022-05-08', '黑龙江省', 91, 2983, 13, 2879),
('2022-05-08', '江西省', 88, 1383, 1, 1294),
('2022-05-08', '四川省', 62, 2067, 3, 2002),
('2022-05-08', '山东省', 59, 2733, 7, 2667),
('2022-05-08', '福建省', 58, 3058, 1, 2999),
('2022-05-08', '辽宁省', 38, 1656, 2, 1616),
('2022-05-08', '内蒙古自治区', 37, 1753, 1, 1715),
('2022-05-08', '湖南省', 25, 1391, 4, 1362),
('2022-05-08', '江苏省', 19, 2214, 0, 2195),
('2022-05-08', '海南省', 19, 288, 6, 263),
('2022-05-08', '广西壮族自治区', 15, 1593, 2, 1576),
('2022-05-08', '青海省', 14, 99, 0, 85),
('2022-05-08', '山西省', 13, 420, 0, 407),
('2022-05-08', '云南省', 11, 2120, 2, 2107),
('2022-05-08', '河北省', 10, 2003, 7, 1986),
('2022-05-08', '重庆市', 8, 703, 6, 689),
('2022-05-08', '安徽省', 6, 1065, 6, 1053),
('2022-05-08', '湖北省', 2, 68398, 4512, 63884),
('2022-05-08', '天津市', 1, 1804, 3, 1800),
('2022-05-08', '贵州省', 1, 180, 2, 177),
('2022-05-08', '陕西省', 0, 3277, 3, 3274),
('2022-05-08', '新疆维吾尔自治区', 0, 1008, 3, 1005),
('2022-05-08', '甘肃省', 0, 681, 2, 679),
('2022-05-08', '宁夏回族自治区', 0, 122, 0, 122),
('2022-05-08', '澳门', 0, 82, 0, 82),
('2022-05-08', '西藏自治区', 0, 1, 0, 1);

INSERT IGNORE INTO detailCount (date, province_name, current_confirmed_count, confirmed_count, dead_count, cured_count) VALUES
('2022-05-09', '台湾', 382843, 397504, 919, 13742),
('2022-05-09', '香港', 261328, 331274, 9346, 60600),
('2022-05-09', '上海市', 6232, 60909, 554, 54123),
('2022-05-09', '浙江省', 705, 3128, 1, 2422),
('2022-05-09', '北京市', 586, 2510, 9, 1915),
('2022-05-09', '吉林省', 494, 40257, 5, 39758),
('2022-05-09', '广东省', 210, 7201, 8, 6983),
('2022-05-09', '河南省', 133, 3027, 22, 2872),
('2022-05-09', '黑龙江省', 65, 2983, 13, 2905),
('2022-05-09', '江西省', 65, 1383, 1, 1317),
('2022-05-09', '福建省', 54, 3062, 1, 3007),
('2022-05-09', '山东省', 53, 2733, 7, 2673),
('2022-05-09', '四川省', 51, 2067, 3, 2013),
('2022-05-09', '内蒙古自治区', 29, 1753, 1, 1723),
('2022-05-09', '辽宁省', 28, 1656, 2, 1626),
('2022-05-09', '湖南省', 26, 1392, 4, 1362),
('2022-05-09', '海南省', 19, 288, 6, 263),
('2022-05-09', '江苏省', 16, 2214, 0, 2198),
('2022-05-09', '青海省', 14, 101, 0, 87),
('2022-05-09', '山西省', 13, 420, 0, 407),
('2022-05-09', '广西壮族自治区', 12, 1594, 2, 1580),
('2022-05-09', '云南省', 10, 2120, 2, 2108),
('2022-05-09', '河北省', 10, 2003, 7, 1986),
('2022-05-09', '重庆市', 6, 703, 6, 691),
('2022-05-09', '安徽省', 5, 1065, 6, 1054),
('2022-05-09', '湖北省', 2, 68398, 4512, 63884),
('2022-05-09', '天津市', 1, 1804, 3, 1800),
('2022-05-09', '贵州省', 1, 180, 2, 177),
('2022-05-09', '陕西省', 0, 3277, 3, 3274),
('2022-05-09', '新疆维吾尔自治区', 0, 1008, 3, 1005),
('2022-05-09', '甘肃省', 0, 681, 2, 679),
('2022-05-09', '宁夏回族自治区', 0, 122, 0, 122),
('2022-05-09', '澳门', 0, 82, 0, 82),
('2022-05-09', '西藏自治区', 0, 1, 0, 1);

INSERT IGNORE INTO detailCount (date, province_name, current_confirmed_count, confirmed_count, dead_count, cured_count) VALUES
('2022-05-10', '台湾', 433638, 448323, 943, 13742),
('2022-05-10', '香港', 261323, 331306, 9347, 60636),
('2022-05-10', '上海市', 5613, 61143, 560, 54970),
('2022-05-10', '浙江省', 694, 3128, 1, 2433),
('2022-05-10', '北京市', 622, 2572, 9, 1941),
('2022-05-10', '吉林省', 440, 40257, 5, 39812),
('2022-05-10', '广东省', 219, 7218, 8, 6991),
('2022-05-10', '河南省', 157, 3052, 22, 2873),
('2022-05-10', '山东省', 55, 2733, 7, 2671),
('2022-05-10', '福建省', 52, 3064, 1, 3011),
('2022-05-10', '黑龙江省', 52, 2983, 13, 2918),
('2022-05-10', '江西省', 50, 1383, 1, 1332),
('2022-05-10', '四川省', 46, 2068, 3, 2019),
('2022-05-10', '湖南省', 26, 1392, 4, 1362),
('2022-05-10', '内蒙古自治区', 23, 1753, 1, 1729),
('2022-05-10', '青海省', 23, 111, 0, 88),
('2022-05-10', '辽宁省', 20, 1658, 2, 1636),
('2022-05-10', '海南省', 18, 288, 6, 264),
('2022-05-10', '江苏省', 15, 2214, 0, 2199),
('2022-05-10', '广西壮族自治区', 12, 1597, 2, 1583),
('2022-05-10', '山西省', 12, 420, 0, 408),
('2022-05-10', '云南省', 10, 2120, 2, 2108),
('2022-05-10', '河北省', 9, 2003, 7, 1987),
('2022-05-10', '重庆市', 6, 703, 6, 691),
('2022-05-10', '安徽省', 4, 1065, 6, 1055),
('2022-05-10', '贵州省', 2, 181, 2, 177),
('2022-05-10', '湖北省', 1, 68398, 4512, 63885),
('2022-05-10', '天津市', 1, 1804, 3, 1800),
('2022-05-10', '陕西省', 0, 3277, 3, 3274),
('2022-05-10', '新疆维吾尔自治区', 0, 1008, 3, 1005),
('2022-05-10', '甘肃省', 0, 681, 2, 679),
('2022-05-10', '宁夏回族自治区', 0, 122, 0, 122),
('2022-05-10', '澳门', 0, 82, 0, 82),
('2022-05-10', '西藏自治区', 0, 1, 0, 1);

INSERT IGNORE INTO detailCount (date, province_name, current_confirmed_count, confirmed_count, dead_count, cured_count) VALUES
('2022-05-11', '台湾', 490762, 505455, 951, 13742),
('2022-05-11', '香港', 261291, 331361, 9352, 60718),
('2022-05-11', '上海市', 5081, 61372, 567, 55724),
('2022-05-11', '浙江省', 691, 3130, 1, 2438),
('2022-05-11', '北京市', 605, 2597, 9, 1983),
('2022-05-11', '吉林省', 342, 40257, 5, 39910),
('2022-05-11', '广东省', 225, 7230, 8, 6997),
('2022-05-11', '河南省', 175, 3074, 22, 2877),
('2022-05-11', '福建省', 64, 3077, 1, 3012),
('2022-05-11', '山东省', 51, 2733, 7, 2675),
('2022-05-11', '黑龙江省', 45, 2983, 13, 2925),
('2022-05-11', '江西省', 34, 1383, 1, 1348),
('2022-05-11', '四川省', 33, 2069, 3, 2033),
('2022-05-11', '青海省', 32, 121, 0, 89),
('2022-05-11', '湖南省', 26, 1392, 4, 1362),
('2022-05-11', '辽宁省', 22, 1663, 2, 1639),
('2022-05-11', '内蒙古自治区', 21, 1753, 1, 1731),
('2022-05-11', '海南省', 18, 288, 6, 264),
('2022-05-11', '广西壮族自治区', 15, 1600, 2, 1583),
('2022-05-11', '江苏省', 13, 2215, 0, 2202),
('2022-05-11', '云南省', 10, 2121, 2, 2109),
('2022-05-11', '河北省', 9, 2003, 7, 1987),
('2022-05-11', '山西省', 9, 420, 0, 411),
('2022-05-11', '重庆市', 6, 703, 6, 691),
('2022-05-11', '安徽省', 4, 1065, 6, 1055),
('2022-05-11', '贵州省', 2, 181, 2, 177),
('2022-05-11', '湖北省', 1, 68398, 4512, 63885),
('2022-05-11', '天津市', 1, 1804, 3, 1800),
('2022-05-11', '陕西省', 0, 3277, 3, 3274),
('2022-05-11', '新疆维吾尔自治区', 0, 1008, 3, 1005),
('2022-05-11', '甘肃省', 0, 681, 2, 679),
('2022-05-11', '宁夏回族自治区', 0, 122, 0, 122),
('2022-05-11', '澳门', 0, 82, 0, 82),
('2022-05-11', '西藏自治区', 0, 1, 0, 1);

INSERT IGNORE INTO detailCount (date, province_name, current_confirmed_count, confirmed_count, dead_count, cured_count) VALUES
('2022-05-12', '台湾', 556160, 570870, 968, 13742),
('2022-05-12', '香港', 261224, 331420, 9355, 60841),
('2022-05-12', '上海市', 4782, 61516, 572, 56162),
('2022-05-12', '浙江省', 684, 3130, 1, 2445),
('2022-05-12', '北京市', 595, 2632, 9, 2028),
('2022-05-12', '吉林省', 319, 40260, 5, 39936),
('2022-05-12', '广东省', 213, 7235, 8, 7014),
('2022-05-12', '河南省', 196, 3095, 22, 2877),
('2022-05-12', '福建省', 62, 3081, 1, 3018),
('2022-05-12', '山东省', 49, 2733, 7, 2677),
('2022-05-12', '青海省', 43, 134, 0, 91),
('2022-05-12', '黑龙江省', 42, 2983, 13, 2928),
('2022-05-12', '四川省', 28, 2069, 3, 2038),
('2022-05-12', '江西省', 28, 1383, 1, 1354),
('2022-05-12', '湖南省', 26, 1392, 4, 1362),
('2022-05-12', '辽宁省', 22, 1665, 2, 1641),
('2022-05-12', '广西壮族自治区', 20, 1605, 2, 1583),
('2022-05-12', '海南省', 18, 288, 6, 264),
('2022-05-12', '云南省', 14, 2125, 2, 2109),
('2022-05-12', '内蒙古自治区', 14, 1753, 1, 1738),
('2022-05-12', '江苏省', 13, 2215, 0, 2202),
('2022-05-12', '河北省', 8, 2003, 7, 1988),
('2022-05-12', '重庆市', 6, 703, 6, 691),
('2022-05-12', '山西省', 6, 420, 0, 414),
('2022-05-12', '安徽省', 4, 1065, 6, 1055),
('2022-05-12', '贵州省', 3, 182, 2, 177),
('2022-05-12', '湖北省', 1, 68398, 4512, 63885),
('2022-05-12', '陕西省', 0, 3277, 3, 3274),
('2022-05-12', '天津市', 0, 1804, 3, 1801),
('2022-05-12', '新疆维吾尔自治区', 0, 1008, 3, 1005),
('2022-05-12', '甘肃省', 0, 681, 2, 679),
('2022-05-12', '宁夏回族自治区', 0, 122, 0, 122),
('2022-05-12', '澳门', 0, 82, 0, 82),
('2022-05-12', '西藏自治区', 0, 1, 0, 1);

INSERT IGNORE INTO detailCount (date, province_name, current_confirmed_count, confirmed_count, dead_count, cured_count) VALUES
('2022-05-13', '台湾', 621160, 635870, 968, 13742),
('2022-05-13', '香港', 261140, 331468, 9356, 60972),
('2022-05-13', '上海市', 4589, 61743, 574, 56580),
('2022-05-13', '浙江省', 678, 3130, 1, 2451),
('2022-05-13', '北京市', 545, 2675, 9, 2121),
('2022-05-13', '吉林省', 283, 40260, 5, 39972),
('2022-05-13', '广东省', 214, 7247, 8, 7025),
('2022-05-13', '河南省', 202, 3110, 22, 2886),
('2022-05-13', '福建省', 70, 3096, 1, 3025),
('2022-05-13', '青海省', 48, 142, 0, 94),
('2022-05-13', '山东省', 47, 2733, 7, 2679),
('2022-05-13', '黑龙江省', 36, 2983, 13, 2934),
('2022-05-13', '四川省', 28, 2075, 3, 2044),
('2022-05-13', '广西壮族自治区', 22, 1607, 2, 1583),
('2022-05-13', '江西省', 21, 1383, 1, 1361),
('2022-05-13', '辽宁省', 19, 1665, 2, 1644),
('2022-05-13', '湖南省', 19, 1392, 4, 1369),
('2022-05-13', '海南省', 16, 288, 6, 266),
('2022-05-13', '云南省', 13, 2125, 2, 2110),
('2022-05-13', '江苏省', 11, 2215, 0, 2204),
('2022-05-13', '内蒙古自治区', 10, 1753, 1, 1742),
('2022-05-13', '重庆市', 8, 705, 6, 691),
('2022-05-13', '河北省', 7, 2003, 7, 1989),
('2022-05-13', '山西省', 6, 420, 0, 414),
('2022-05-13', '安徽省', 3, 1065, 6, 1056),
('2022-05-13', '贵州省', 2, 182, 2, 178),
('2022-05-13', '湖北省', 1, 68398, 4512, 63885),
('2022-05-13', '陕西省', 1, 3278, 3, 3274),
('2022-05-13', '天津市', 0, 1804, 3, 1801),
('2022-05-13', '新疆维吾尔自治区', 0, 1008, 3, 1005),
('2022-05-13', '甘肃省', 0, 681, 2, 679),
('2022-05-13', '宁夏回族自治区', 0, 122, 0, 122),
('2022-05-13', '澳门', 0, 82, 0, 82),
('2022-05-13', '西藏自治区', 0, 1, 0, 1);

INSERT IGNORE INTO detailCount (date, province_name, current_confirmed_count, confirmed_count, dead_count, cured_count) VALUES
('2022-05-14', '台湾', 685073, 699824, 1009, 13742),
('2022-05-14', '香港', 261083, 331509, 9359, 61067),
('2022-05-14', '上海市', 4061, 61938, 575, 57302),
('2022-05-14', '浙江省', 671, 3130, 1, 2458),
('2022-05-14', '北京市', 538, 2707, 9, 2160),
('2022-05-14', '吉林省', 246, 40261, 5, 40010),
('2022-05-14', '广东省', 209, 7255, 8, 7038),
('2022-05-14', '河南省', 200, 3117, 22, 2895),
('2022-05-14', '福建省', 80, 3114, 1, 3033),
('2022-05-14', '青海省', 51, 146, 0, 95),
('2022-05-14', '山东省', 46, 2734, 7, 2681),
('2022-05-14', '黑龙江省', 33, 2983, 13, 2937),
('2022-05-14', '四川省', 28, 2078, 3, 2047),
('2022-05-14', '广西壮族自治区', 23, 1609, 2, 1584),
('2022-05-14', '江西省', 18, 1383, 1, 1364),
('2022-05-14', '辽宁省', 17, 1667, 2, 1648),
('2022-05-14', '海南省', 16, 288, 6, 266),
('2022-05-14', '云南省', 11, 2125, 2, 2112),
('2022-05-14', '江苏省', 10, 2215, 0, 2205),
('2022-05-14', '重庆市', 10, 707, 6, 691),
('2022-05-14', '湖南省', 8, 1393, 4, 1381),
('2022-05-14', '河北省', 7, 2003, 7, 1989),
('2022-05-14', '内蒙古自治区', 7, 1753, 1, 1745),
('2022-05-14', '山西省', 5, 420, 0, 415),
('2022-05-14', '安徽省', 2, 1065, 6, 1057),
('2022-05-14', '贵州省', 2, 182, 2, 178),
('2022-05-14', '陕西省', 1, 3278, 3, 3274),
('2022-05-14', '湖北省', 0, 68398, 4512, 63886),
('2022-05-14', '天津市', 0, 1804, 3, 1801),
('2022-05-14', '新疆维吾尔自治区', 0, 1008, 3, 1005),
('2022-05-14', '甘肃省', 0, 681, 2, 679),
('2022-05-14', '宁夏回族自治区', 0, 122, 0, 122),
('2022-05-14', '澳门', 0, 82, 0, 82),
('2022-05-14', '西藏自治区', 0, 1, 0, 1);

CALL totalSum();