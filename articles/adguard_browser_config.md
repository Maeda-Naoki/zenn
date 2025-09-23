---
title: "Adguard Home使うときにはChromeの設定も変更いるよ"
emoji: "🌐"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["adguard", "chrome", "dns"]
published: true
---

# TL;DR

- [Adguard Home](https://github.com/AdguardTeam/AdGuardHome)をDNSサーバーにすると広告がブロックできる
- クライアントの`Chrome`で`セキュア DNS `をOSデフォルト[^1]にしないと`Chrome`の広告はブロックされない

# 前提

家庭のLANに[Adguard Home](https://github.com/AdguardTeam/AdGuardHome)を導入してみました。  
QNAP NASではデフォルトで`dnsmasq`というDNSサーバーが`Port 53`で動いていたので、[Adguard Home](https://github.com/AdguardTeam/AdGuardHome)を`Port 10053`で動かす。  
`iptables`で`Port 53`への通信を`Port 10053`へ転送する。  
[Adguard Home](https://github.com/AdguardTeam/AdGuardHome)のダッシュボードでDNSリクエストを確認してみてもDNSリクエストがかなり少なく、`Chrome`で見たページに広告が残ったまま。

# システム構成

- QNAP NAS
  - `TS-264`
- Docker image
  - `adguard/adguardhome:v0.107.65`
- システム構成図
  ![システム構成図 抜粋版](/images/AdguardBrowserConfig/SystemOverview.png)
