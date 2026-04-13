# GitHub 发布与权限设置

这份仓库里的文件只能提前准备工作流和代码所有者，真正的推送/合并限制需要在 GitHub 仓库设置里手动开启。

## 1. 创建公开仓库

建议仓库名直接使用 `CTF-web-onedocker-skill`，可见性设为 `Public`。

## 2. 禁止陌生人发 PR

进入 `Settings -> General -> Features -> Pull requests`：

- 推荐选择 `Collaborators only`。
- 如果你连协作者 PR 也不想要，可以直接取消勾选 `Pull requests`。

如果仓库是个人账号下的公开仓库，而且你没有添加其他协作者，那么这里设成 `Collaborators only` 后，实际上就只有你自己能发 PR。

## 3. 只允许你自己更新默认分支

进入 `Settings -> Rules -> Rulesets -> New ruleset -> New branch ruleset`，建议这样配：

- `Target branches`：选择默认分支，或直接匹配 `main`。
- `Bypass list`：只保留 `Repository admins`。
- 如果你希望连自己也必须走 PR，再把 `Repository admins` 从 `Always allow` 改成 `For pull requests only`。

建议启用这些规则：

- `Restrict updates`
- `Restrict deletions`
- `Block force pushes`
- `Require a pull request before merging`
- `Require approvals`：`1`
- `Require review from code owners`
- `Require conversation resolution before merging`
- `Require linear history`

如果这个仓库只有你一个管理员，那么上面的规则生效后，只有你能推送、合并，其他人既不能直接推，也不能自己合并。

## 4. 发布 ZIP 到 Release

仓库已经包含 `.github/workflows/release-package.yml`，支持两种方式：

- 推送标签：`git tag v1.0.0 && git push origin v1.0.0`
- 手动触发：`Actions -> Release Package -> Run workflow`

工作流会把当前仓库打包成 ZIP，并上传到对应的 GitHub Release 页面。

## 5. 建议补一个 LICENSE

如果你准备真正开源，最好补一个 `LICENSE` 文件。否则仓库虽然公开可见，但默认并不等于别人可以按开源协议自由使用。
