# __CHALLENGE_NAME__

## 题目类型
Web

## 难度
__DIFFICULTY__

## 核心考点
- __POINT_1__
- __POINT_2__
- __POINT_3__

## 单容器服务说明
- 容器内同时运行：MySQL(MariaDB) + PHP-FPM + Nginx。
- 不依赖 docker-compose，多服务由 `build/service/start.sh` 编排。

## 构建命令
```bash
docker build -t __IMAGE_NAME__ -f build/dockerfile .
```

## 运行命令
```bash
docker run -d --name __CONTAINER_NAME__ -p __HOST_PORT__:80 -e FLAG='flag{change_me}' __IMAGE_NAME__
```

## 说明
- 若未注入 `FLAG/A1CTF_FLAG/GZCTF_FLAG`，启动脚本会输出 `error! please_call_admin` 并退出。
