# 单容器 MySQL 构建参考

## 适用场景
- 用户确认“需要数据库”且目标为 MySQL。
- 平台要求单容器部署，不允许拆分 mysql 容器。
- 题目技术栈为 PHP/其他 Web 后端，需要关系型数据持久层。

## 方案目标
- 在一个容器内同时运行：
1. MySQL 或 MariaDB 进程
2. 应用进程（如 php-fpm / python）
3. 反向代理（优先 Nginx）
- 保持启动脚本可读、可维护、可复用。

## 推荐基线
- 基础镜像：Alpine 系（如 `php:fpm-alpine`）。
- Dockerfile 仅做依赖安装与文件复制，不处理 Flag。
- Flag 注入、DB 初始化、服务拉起全部放在 `start.sh`。

## 启动脚本建议顺序
1. 检测 `FLAG`、`A1CTF_FLAG`、`GZCTF_FLAG`。
2. 未检测到注入时输出 `error! please_call_admin` 并 `exit 1`。
3. 将 Flag 写入 `/flag`，设置权限。
4. 清理环境变量（`unset`）。
5. 初始化并启动 MySQL/MariaDB。
6. 等待数据库就绪。
7. 初始化数据库、表、初始数据。
8. 启动 Web 服务与 Nginx 前台进程。

## MySQL 初始化要点
- 首次运行时初始化数据目录（如 `mariadb-install-db`）。
- 使用循环等待连接可用，不要盲目 `sleep` 固定秒数。
- 初始化 SQL 使用幂等语句：
`CREATE DATABASE IF NOT EXISTS`
`CREATE TABLE IF NOT EXISTS`
`INSERT ... ON DUPLICATE KEY UPDATE`

## 单容器风险控制
- 不要把 root 凭据硬编码到前端或源码可读路径。
- 对数据库用户最小授权，按题目需求授予权限。
- 题目若不需要持久化，可接受容器内临时数据目录。
- 统一通过一个 `start.sh` 承担编排，避免多入口脚本冲突。

## 推荐输出说明
- 在 `readme.md` 明确写出：
1. 单容器限制下的服务组成
2. 默认映射端口
3. 构建命令与运行命令
4. 启动依赖的环境变量（如 `FLAG`）

## 与题库参考的关系
- 可参考 `web-lnmp-php73` 的总体逻辑：同容器启动 DB + Nginx + PHP。
- 必须按当前技能规则强化：
1. Dockerfile 禁止 Flag 操作
2. start.sh 缺失注入时必须报错退出
3. 写入 `/flag` 后必须清理环境变量

