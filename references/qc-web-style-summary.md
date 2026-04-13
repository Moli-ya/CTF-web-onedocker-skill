# QC WEB 题库风格归纳

## 统计范围
- 本文归纳来源：`G:\CTF题目\QC\WEB\Week1` 到 `Week4`。
- 已读取并分析：README、Dockerfile、nginx.conf、php.ini、启动脚本、主要入口源码。
- 题目总量：26。
- Dockerfile 总量：26。

## 目录与交付风格
- 大多数题目采用 `build/` 目录承载可部署文件。
- 高频结构：
`build/src`（题目源码）
`build/service`（`init.sh` / `start.sh`）
`build/config`（`nginx.conf` / `php.ini`）
`build/Dockerfile`
- 题目根目录一般包含 `README.md` 和附件压缩包。

## 基础镜像与技术栈分布
- `php:5.6-fpm-alpine`：9
- `php:7.4.0-fpm-alpine`：4
- `ghcr.io/gzctf/challenge-base/python:alpine`：5
- 其他：`python:3.12-alpine`、`php:7.4-apache`、`openjdk`、`golang`、`ubuntu` 等少量特例

结论：
- 题库明显偏向轻量镜像和 Web 单服务容器。
- PHP + Nginx + FPM 是主流构建方式。

## 反向代理与服务启动习惯
- PHP 题目普遍使用 Nginx 反向代理到 `127.0.0.1:9000`。
- 常见启动方式：
1. 启动脚本写入 Flag
2. 启动 `php-fpm -D`
3. `nginx -g 'daemon off;'`
- Python 题目常直接 `python3 app.py`（部分没有 Nginx 反代）。
- 少量题目使用 Apache（如 XXE）或内置开发服务器（`php -S`）。

## 启动脚本中的 Flag 处理习惯
- 常见检测变量：`A1CTF_FLAG`、`QUESTION_CTF_FLAG`、`GZCTF_FLAG`、`FLAG`。
- 常见行为：写入 `/flag` 或题目自定义位置后 `chmod`。
- 常见缺陷：部分题目保留默认 Flag 回退值，或未彻底清理环境变量。

本技能中的强化要求：
- 仅接受 `FLAG`、`A1CTF_FLAG`、`GZCTF_FLAG`。
- 未检测到注入时必须输出 `error! please_call_admin` 并退出。
- 写入 `/flag` 后必须 `unset` 清理环境变量。

## 配置文件风格
- `nginx.conf` 以简洁 server 配置为主。
- `php.ini` 通常仅包含三项：
`memory_limit`
`post_max_size`
`upload_max_filesize`
- 题目构建更重可运行性与体积，而非生产级监控和复杂运维。

## 前端页面风格
- 默认风格偏“快速可用”：
1. 结构简单、单页入口明显
2. CSS 内联较多，白底或浅色背景常见
3. 少量题目使用高视觉样式（游戏化、渐变、图片背景）
- 命名风格偏实战，不追求框架化组件拆分。

建议对齐策略：
- 默认输出简洁白底页面。
- 仅在用户明确要求“炫酷”时再提高视觉复杂度。

## README 风格
- 常包含以下字段：
1. 题目名
2. 部署端口
3. CPU / Memory / Disk 建议
- 也会记录“镜像瘦身”信息或迁移备注。

本技能的 README 输出最少应包含：
1. 题目类型
2. 难度
3. 核心考点
4. `docker build` 命令
5. `docker run` 命令

## 与本技能规范冲突时的优先级
- 以本技能强制规则为最高优先级。
- 即使题库中存在以下做法，也不要复用：
1. 在 Dockerfile 里拷贝或写死 Flag
2. 启动脚本缺少环境变量清理
3. 未做注入失败终止

