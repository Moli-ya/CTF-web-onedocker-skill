<?php
if (isset($_GET["source"])) {
    highlight_file(__FILE__);
    exit;
}
?>
<!doctype html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>CTF Web Challenge</title>
    <style>
        body {
            margin: 0;
            padding: 48px 16px;
            background: #fff;
            color: #111827;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial, sans-serif;
        }
        .box {
            max-width: 720px;
            margin: 0 auto;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 24px;
        }
        h1 {
            margin: 0 0 12px;
            font-size: 24px;
        }
        p {
            margin: 8px 0;
            line-height: 1.6;
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
        <p>欢迎来到挑战环境。</p>
        <p>如需查看当前入口源码，请访问：<a href="/?source=1">/?source=1</a></p>
    </div>
</body>
</html>
