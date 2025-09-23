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

# 確認事項

`dig`コマンドで`google.com`のIPアドレスを聞いてみる。  
これは正しく[Adguard Home](https://github.com/AdguardTeam/AdGuardHome)からレスポンスが返ってきた。  
ということで、NAS上の設定は問題ないしクライアントの設定も問題ない。

```bash
$ dig google.com

; <<>> DiG 9.18.39-0ubuntu0.24.04.1-Ubuntu <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 7043
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 1232
;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             178     IN      A       142.251.222.46

;; Query time: 11 msec
;; SERVER: NAS IP#53(1NAS IP) (UDP)
;; WHEN: Tue Sep 23 22:18:50 JST 2025
;; MSG SIZE  rcvd: 55
```
