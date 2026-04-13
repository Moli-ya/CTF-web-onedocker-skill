# ctf-web-docker-skill

一个面向 Codex 的中文技能仓库，用来稳定生成单容器 CTF Web 题目骨架，并约束输出格式、启动逻辑与 Flag 注入安全细节。

## 关键点

- 中文工作流：先确认技术栈和数据库需求，再生成题目文件。
- 固定交付结构：统一输出到 `build/src`、`build/service`、`build/config`、`build/dockerfile` 和 `readme.md`。
- 安全约束内置：要求在启动阶段注入 `/flag`，并清理 `FLAG`、`A1CTF_FLAG`、`GZCTF_FLAG` 等环境变量。
- 可复用素材齐全：仓库内置模板、参考约束和目录初始化脚本。

## 目录

- `SKILL.md`：技能主规则与输出约束。
- `agents/openai.yaml`：技能入口描述。
- `assets/templates/`：单容器题目模板。
- `references/`：输出契约与风格参考。
- `scripts/create_challenge_tree.sh`：标准目录生成脚本。

## 使用

直接在 Codex 中调用：

```text
使用 $ctf-web-architect-zh 设计一个新的 CTF Web 题目并输出完整文件。
```

如果只想先生成目录骨架：

```bash
sh scripts/create_challenge_tree.sh demo-challenge
```

## Release

- 推送形如 `v1.0.0` 的标签，或在 GitHub Actions 手动触发 `Release Package`。
- 工作流会自动打包当前仓库为 ZIP，并上传到 GitHub Release 页面。

## GitHub 设置

- 仓库已包含 `.github/CODEOWNERS`，默认代码所有者为 `@Moli-ya`。
- “只允许你自己推送和合并”的关键设置不能仅靠仓库文件完成，需要在 GitHub 仓库设置里启用规则。
- 具体步骤见 [`.github/REPO_SETUP.md`](.github/REPO_SETUP.md)。
