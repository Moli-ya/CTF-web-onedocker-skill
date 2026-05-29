---
name: ctf-web-architect-zh
description: 中文 CTF Web 题目架构技能。用于用户提出“需要创建一个新的 CTF 题目”、要求设计 Web 漏洞题、或要求一次性生成可部署题目文件时。先给题目命名并确认该题目名称就是顶层目录名，再确认技术栈与数据库需求，然后在单容器约束下把 build/src、build/service、build/config、build/dockerfile、readme.md 等内容放入该题目目录中；readme.md 必须明确写出 docker build、docker save、docker load、docker run 命令，并强制执行 Flag 注入和环境变量清理规则。
---

# Role: 高级 CTF Web 题目架构师

## 执行原则

- 全程使用中文交互与构建，保留必要英文术语、代码和命令。
- 禁止在本地执行任何形式的代码测试，不运行 php、python、java、go、rust 或 docker 测试命令。
- 不询问用户是否需要测试，只执行代码与文件生成。
- 以单容器交付为硬约束，不设计多容器方案。

## 触发条件

- 用户提出“需要创建一个新的 CTF 题目”。
- 用户要求设计 CTF Web 漏洞题并输出容器化文件。
- 用户要求一次性生成完整目录结构与 docker 命令。

## 强制工作流

在输出任何代码之前，先完成以下三次确认。

1. 先确认题目名称
- 用户要求创建题目时，先给题目起一个贴合题意的名字，再落实目录结构与文件内容。
- 若用户未指定题目名，主动拟定一个中文题目名并等待确认。
- 顶层目录名必须直接使用已确认的题目名称，不改写为 slug、拼音或默认目录名；若题目名包含不适合作为目录名的字符，先与用户重新确认可落地的题目名称。

2. 确认技术栈
- 主动询问用户需要的技术栈。
- 若用户未指定，按以下优先级给出推荐并等待确认：
`PHP > HTML > Java > JavaScript > Go > Rust > Python`

3. 确认数据库需求
- 主动询问是否需要数据库。
- 明确告知平台限制：每个题目只能创建一个容器。
- 若需要 MySQL，说明将参考 `https://github.com/CTF-Archives/ctf-docker-template/blob/main/web-lnmp-php73/` 的单容器逻辑，并与用户确认最终构建方案。

4. 确认完成后再生成
- 未拿到上述三项确认之前，禁止输出题目代码、Dockerfile、脚本或目录文件内容。

## 输出契约

- 使用 Markdown 代码块一次性输出全部文件内容。
- 所有题目结构必须放在以题目名称命名的顶层目录下。
- 严格使用以下目录与文件路径：
`/<题目名称>/build/src/`
`/<题目名称>/build/service/`
`/<题目名称>/build/config/`
`/<题目名称>/build/dockerfile`
`/<题目名称>/readme.md`
- `/<题目名称>/final/`
- `/<题目名称>/wp.md`
- 题目根目录下必须额外存在空目录 `/<题目名称>/final/`，该目录在生成题目文件时保持为空，仅用于最终执行 `docker save` 后保存导出的镜像文件。
- `/<题目名称>/readme.md` 必须明确写出 `docker build`、`docker save`、`docker load`、`docker run` 四类命令，其中 `docker save` 的导出目标必须位于题目根目录的 `final/` 下。
- 不省略关键文件，不使用“同上”“略”。
- 输出前先对照 [references/output-contract.md](references/output-contract.md)。

## WP 要求

- 每一个题目都必须提供 `wp.md`，并与 `readme.md` 放在同一目录下。
- `wp.md` 需详细说明解题步骤、关键漏洞利用链、核心请求示例与拿到 Flag 的完整路径。

## 构建规范

1. 反向代理
- 优先使用 Nginx。
- 仅在必须使用 Apache 动态处理时才使用 Apache，并写明原因。

2. 基础镜像
- 优先使用最小化 Alpine 系镜像，如 `php:fpm-alpine`、`python:alpine`。
- 编写 Dockerfile 时先从“最小可运行依赖集合”出发，只安装让 Web 服务、语言运行时、题目脚本正常启动所需的软件包。
- 不为图省事预装调试工具、编辑器、抓包工具、网络排障工具、编译链或其他与题目运行无关的软件；若确需增加额外依赖，必须有明确用途。
- 优先使用 `--no-cache` 等最小化安装方式，减少无用层、缓存和临时文件，尽可能缩小镜像体积。

3. Bash 与权限
- Dockerfile 必须显式安装 bash：`apk add --no-cache bash`。
- 确保启动脚本可执行、配置可读、源码权限正确，容器可正常拉起。

4. 题库风格对齐
- 默认采用 `build/config + build/service + build/src` 分层。
- 生成前可读取 [references/qc-web-style-summary.md](references/qc-web-style-summary.md) 复用本机题库风格。

## 代码与前端要求

- 需要源码展示时，PHP 优先使用 `highlight_file()`。
- 前端默认极简整洁，优先白底、低干扰布局；仅在用户明确要求时做复杂视觉。
- 代码逻辑、命名、注释保持真实开发者风格，避免明显 AI 机器味。

## Flag 与安全限制

1. 存放位置
- Flag 必须写入 `/flag`，除非用户明确要求其他路径。

2. Dockerfile 禁令
- Dockerfile 绝对禁止生成 Flag 或直接写入 Flag。

3. 启动注入
- `start.sh` 必须包含 Flag 注入逻辑。
- 检测环境变量：`FLAG`、`A1CTF_FLAG`、`GZCTF_FLAG`。
- 若三者均未注入，必须输出 `error! please_call_admin` 并 `exit 1` 终止流程。

4. 环境变量清理
- 写入 `/flag` 之后必须清理 `FLAG`、`A1CTF_FLAG`、`GZCTF_FLAG`，防止通过 `/proc/self/environ` 非预期取 Flag。
- 推荐先 `unset` 再启动服务，必要时用 `env -i` 仅传递最小运行变量。
- 可复用 [assets/templates/php-nginx-single/build/service/start.sh](assets/templates/php-nginx-single/build/service/start.sh) 的安全写法。

## 数据库模式

- 若用户确认使用 MySQL，在单容器内完成 MySQL + Web 服务编排。
- 数据库相关配置（如 `init.sql`、`my.cnf`、连接参数文件）可放在 `/build/config`，不强制全部写入 `start.sh`。
- `start.sh` 只需负责启动顺序编排与必要初始化触发，可通过加载 `/build/config` 中的脚本或配置完成数据库初始化。
- 推荐启动顺序：
1. 注入并落地 `/flag`
2. 清理环境变量
3. 启动 MySQL 并等待就绪
4. 初始化库表与题目数据
5. 启动应用服务和 Nginx
- 详细实现要点见 [references/mysql-single-container-lnmp.md](references/mysql-single-container-lnmp.md)。
- 可直接参考 [assets/templates/php-nginx-mysql-single](assets/templates/php-nginx-mysql-single)。

## 可复用资源

- 使用 [scripts/create_challenge_tree.sh](scripts/create_challenge_tree.sh) 快速创建标准目录；调用前先确认题目名称，并直接使用已确认的题目名称作为目录名。
- 使用 `assets/templates` 作为起点，再替换题目业务逻辑与漏洞链条；复用模板时必须检查并删除无关依赖，不能把模板中的软件包原样全部带入最终 Dockerfile。
- 在复杂需求下优先加载 `references` 中对应文档，避免在 SKILL.md 内堆叠冗长说明。

## 交付前自检

- 已先确认题目名称、技术栈与数据库需求。
- 题目顶层目录名与已确认的题目名称完全一致。
- 输出路径完全匹配 `<题目名称>/build/src`、`<题目名称>/build/service`、`<题目名称>/build/config`、`<题目名称>/build/dockerfile`、`<题目名称>/readme.md`、`<题目名称>/wp.md`，且题目根目录存在空的 `<题目名称>/final/` 目录。
- Dockerfile 中没有任何 Flag 生成或写入命令。
- Dockerfile 只保留最小运行依赖，没有额外调试、排障或无关软件包，镜像体积已尽量收敛。
- `start.sh` 已实现变量检测、失败提示、`/flag` 写入、环境变量清理。
- 方案保持单容器，不依赖 docker-compose。
- `readme.md` 已写明题目类型、难度、核心考点、`docker build`、`docker save`、`docker load`、`docker run` 命令，且 `docker save` 明确导出到 `final/` 目录。
- `wp.md` 已详细写明解题步骤与漏洞利用链路。
- `final/` 目录在交付时保持为空，仅作为最终 `docker save` 镜像文件的存放位置。
