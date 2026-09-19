@echo off
chcp 65001 >nul
title 踏仙君模拟器 - 手机访问服务

:: ---- 需要管理员权限（允许局域网/手机访问） ----
net session >nul 2>&1
if %errorlevel% neq 0 (
  echo 首次运行需要管理员权限，正在请求...
  powershell -NoProfile -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
  exit /b
)

echo ==================================================
echo.
echo   踏仙君模拟器 服务已启动（本窗口保持开启）
echo.
echo   1. 手机和电脑连接【同一个WiFi】
echo   2. 手机浏览器地址栏输入下面这行：
echo.
powershell -NoProfile -Command "$ip=(Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -notmatch '^(127\.|169\.254\.)'} | Select-Object -First 1).IPAddress; Write-Host ('    http://' + $ip + ':8766/') -ForegroundColor Yellow"
echo.
echo   3. 若Windows弹出防火墙提示，请点【允许访问】
echo   4. 关闭本窗口即停止服务
echo.
echo   电脑自己玩不需要本脚本，直接双击 index.html
echo ==================================================
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command "$l=New-Object System.Net.HttpListener; $l.Prefixes.Add('http://+:8766/'); $l.Start(); $root=$env:USERPROFILE+'\Desktop\taxian'; while($l.IsListening){ $c=$l.GetContext(); try{ $p=$c.Request.Url.AbsolutePath; if($p -eq '/'){ $p='/index.html' }; $f=Join-Path $root ($p.TrimStart('/') -replace '/','\'); if(Test-Path -LiteralPath $f){ $b=[IO.File]::ReadAllBytes($f); $c.Response.ContentType='text/html; charset=utf-8'; $c.Response.ContentLength64=$b.Length; $c.Response.OutputStream.Write($b,0,$b.Length) } else { $c.Response.StatusCode=404 } } catch {} finally { $c.Response.Close() } }"
pause
