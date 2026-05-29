# 输出契约

## 前置确认
在输出代码前必须先确认：
1. 题目名称，且该名称必须作为题目顶层目录名。
2. 技术栈（默认优先级：`PHP > HTML > Java > JavaScript > Go > Rust > Python`）。
3. 是否需要数据库（并说明单容器限制）。

## 固定目录结构
```text
/<题目名称>/build/src/
/<题目名称>/build/service/
/<题目名称>/build/config/
/<题目名称>/build/dockerfile
/<题目名称>/final/
/<题目名称>/readme.md
/<题目名称>/wp.md
```

## 输出格式
- 必须使用 Markdown 代码块。
- 必须一次性输出全部文件内容。
- 每个文件单独一个代码块，并在首行标注文件路径。

## 推荐输出骨架
````markdown
```dockerfile
# /<题目名称>/build/dockerfile
...
```

```bash
# /<题目名称>/build/service/start.sh
...
```

```nginx
# /<题目名称>/build/config/nginx.conf
...
```

```php
# /<题目名称>/build/src/index.php
...
```

```markdown
# /<题目名称>/readme.md
...
```

```markdown
# /<题目名称>/wp.md
...
```
````

## 必过检查项
- Dockerfile 中没有 Flag 生成/写入语句。
- `start.sh` 检测 `FLAG/A1CTF_FLAG/GZCTF_FLAG`。
- 缺失注入时输出 `error! please_call_admin` 并退出。
- 写入 `/flag` 后执行环境变量清理。
- `readme.md` 包含题型、难度、考点、`docker build`、`docker save`、`docker load`、`docker run` 命令。
- `docker save` 的导出目标必须位于题目根目录的 `final/` 下。
- `wp.md` 包含解题步骤、漏洞利用链路、核心请求示例与获取 Flag 的完整路径。
- `final/` 在题目交付时保持为空，仅用于保存 `docker save` 导出的镜像文件。

