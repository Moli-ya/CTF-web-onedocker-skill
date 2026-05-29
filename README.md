# CTF Web One-Docker Skill

面向 Codex 的中文 CTF Web 出题技能仓库。它把“单容器交付、固定目录结构、Flag 安全注入、题目 README 与 WP 完整输出”这些容易遗漏的规则沉淀成一套可复用工作流，适合用来快速生成可部署、可归档、可复查的 Web 题目骨架。

## 这个仓库解决什么

做 CTF Web 题目时，题目代码本身通常不是唯一风险点。更常见的问题是交付结构不统一、Docker 命令缺失、Flag 写死在镜像里、环境变量没有清理、WP 后补不完整，或者临时模板带入过多无关依赖。

这个技能重点约束这些工程化细节：

- 先确认题目名称、技术栈与数据库需求，再生成题目文件。
- 所有题目按 `<题目名称>/build/src`、`<题目名称>/build/service`、`<题目名称>/build/config`、`<题目名称>/build/dockerfile`、`<题目名称>/readme.md`、`<题目名称>/wp.md`、`<题目名称>/final/` 交付。
- Flag 在容器启动阶段从环境变量注入到 `/flag`，并清理 `FLAG`、`A1CTF_FLAG`、`GZCTF_FLAG`。
- 默认单容器架构，不依赖 `docker-compose`。
- 模板、参考文档和初始化脚本都放在仓库内，便于本地维护和版本发布。

## 目录结构

```text
.
├── SKILL.md
├── README.md
├── agents/
│   └── openai.yaml
├── assets/
│   └── templates/
│       ├── php-nginx-single/
│       └── php-nginx-mysql-single/
├── references/
│   ├── mysql-single-container-lnmp.md
│   ├── output-contract.md
│   └── qc-web-style-summary.md
└── scripts/
    └── create_challenge_tree.sh
```

## 核心文件

| 路径 | 用途 |
| --- | --- |
| `SKILL.md` | Codex 技能主规则，定义触发条件、强制确认流程、输出契约和安全限制。 |
| `agents/openai.yaml` | 技能在 Codex 中展示的入口描述与默认提示词。 |
| `assets/templates/php-nginx-single/` | PHP + Nginx 单容器基础模板，不包含数据库。 |
| `assets/templates/php-nginx-mysql-single/` | PHP + Nginx + MySQL 单容器模板，用于需要数据库的题目。 |
| `references/output-contract.md` | 输出格式检查清单，生成题目前必须对照。 |
| `references/mysql-single-container-lnmp.md` | 单容器 MySQL 编排注意事项。 |
| `references/qc-web-style-summary.md` | 本地题库风格参考。 |
| `scripts/create_challenge_tree.sh` | 快速创建标准题目目录骨架。 |

## 在 Codex 中使用

直接在 Codex 对话中调用技能：

```text
使用 $ctf-web-architect-zh 设计一个新的 CTF Web 题目并输出完整文件。
```

技能会先要求确认：

1. 题目名称，并把它作为顶层目录名。
2. 技术栈，例如 PHP、HTML、Java、JavaScript、Go、Rust、Python。
3. 是否需要数据库，并提醒单容器限制。

确认完成后，再一次性输出题目所需的 Dockerfile、启动脚本、配置、源码、题目 README 与 WP。

## 本地创建题目骨架

只想先创建空目录时，可以使用脚本：

```bash
sh scripts/create_challenge_tree.sh demo-challenge
```

生成结果：

```text
demo-challenge/
├── build/
│   ├── config/
│   ├── service/
│   ├── src/
│   └── dockerfile
├── final/
├── readme.md
└── wp.md
```

`final/` 目录默认保持为空，只用于后续保存 `docker save` 导出的镜像文件。

## 标准题目交付命令

每道题目的 `readme.md` 都应明确写出以下四类命令，并把镜像导出到题目根目录的 `final/` 下：

```bash
docker build -t demo-challenge:latest -f build/dockerfile build
docker save demo-challenge:latest -o final/demo-challenge.tar
docker load -i final/demo-challenge.tar
docker run --rm -p 8080:80 -e FLAG='flag{test_flag}' demo-challenge:latest
```

实际题目中应把镜像名、端口、Flag 示例和路径替换为对应内容。

## 本地编辑流程

推荐用独立分支维护技能改动：

```bash
git clone https://github.com/Moli-ya/CTF-web-onedocker-skill.git
cd CTF-web-onedocker-skill
git switch -c codex/update-skill-docs
```

修改完成后检查差异：

```bash
git status --short
git diff
```

确认无误后再提交：

```bash
git add README.md SKILL.md references scripts assets agents
git commit -m "docs: improve skill readme"
git push -u origin codex/update-skill-docs
```

## 维护检查清单

更新这个技能时，建议重点检查这些地方：

- `SKILL.md` 与 `references/output-contract.md` 的输出路径是否一致。
- `scripts/create_challenge_tree.sh` 是否生成了技能要求的所有文件和目录。
- 模板中的 `start.sh` 是否仍然包含 Flag 注入、缺失报错和环境变量清理逻辑。
- Dockerfile 是否只保留最小运行依赖，避免带入调试工具和无关软件包。
- 需要数据库的模板是否仍然保持单容器编排，不引入 `docker-compose`。
- README 是否说明了本地编辑、生成骨架、打包发布和使用方式。

## 发布 Release

仓库内置 GitHub Actions 工作流 `.github/workflows/release-package.yml`。发布方式有两种：

```bash
git tag v1.0.0
git push origin v1.0.0
```

或者在 GitHub Actions 页面手动触发 `Release Package`，输入类似 `v1.0.0` 的版本号。

工作流会用 `git archive` 打包当前仓库，并把 ZIP 上传到对应的 GitHub Release。

## 设计边界

这个技能只负责生成 CTF Web 题目的工程骨架、容器配置、启动约束和题目文档，不负责在本地运行题目或验证漏洞利用链。按照技能规则，生成题目时不运行 PHP、Python、Java、Go、Rust 或 Docker 测试命令。
