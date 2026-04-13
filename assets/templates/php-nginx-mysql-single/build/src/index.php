<?php
require_once __DIR__ . "/db.php";

if (isset($_GET["source"])) {
    highlight_file(__FILE__);
    exit;
}

$pdo = get_pdo();
$rows = $pdo->query("SELECT id, title, content FROM notes ORDER BY id DESC LIMIT 5")->fetchAll();
?>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CTF Web + MySQL</title>
    <style>
        body {
            margin: 0;
            padding: 48px 16px;
            background: #fff;
            color: #111827;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
        }
        .box {
            max-width: 760px;
            margin: 0 auto;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 24px;
        }
        h1 {
            margin: 0 0 12px;
            font-size: 24px;
        }
        ul {
            padding-left: 20px;
        }
        li {
            margin: 8px 0;
            line-height: 1.5;
        }
        a {
            color: #2563eb;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="box">
        <h1>__CHALLENGE_TITLE__</h1>
        <p>当前模板已连通单容器 MySQL 示例数据。</p>
        <p>源码入口：<a href="/?source=1">/?source=1</a></p>
        <ul>
            <?php foreach ($rows as $row): ?>
                <li><?php echo htmlspecialchars($row["title"] . ": " . $row["content"], ENT_QUOTES, "UTF-8"); ?></li>
            <?php endforeach; ?>
        </ul>
    </div>
</body>
</html>
