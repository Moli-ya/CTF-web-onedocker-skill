# 输出契约

## 前置确认
在输出代码前必须先确认：
1. 技术栈（默认优先级：`PHP > HTML > Java > JavaScript > Go > Rust > Python`）
2. 是否需要数据库（并说明单容器限制）

## 固定目录结构
```text
/build/src/
/build/service/
/build/config/
/build/dockerfile
/readme.md
```

## 输出格式
- 必须使用 Markdown 代码块。
- 必须一次性输出全部文件内容。
- 每个文件单独一个代码块，并在首行标注文件路径。

## 推荐输出骨架
````markdown
```dockerfile
# /build/dockerfile
...
```

```bash
# /build/service/start.sh
...
```

```nginx
# /build/config/nginx.conf
...
```

```php
# /build/src/index.php
...
```

```markdown
# /readme.md
...
```
````

## 必过检查项
- Dockerfile 中没有 Flag 生成/写入语句。
- `start.sh` 检测 `FLAG/A1CTF_FLAG/GZCTF_FLAG`。
- 缺失注入时输出 `error! please_call_admin` 并退出。
- 写入 `/flag` 后执行环境变量清理。
- `readme.md` 包含题型、难度、考点、构建和运行命令。

