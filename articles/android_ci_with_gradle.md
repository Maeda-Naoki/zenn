---
title: "Android向けCI回す時、Gradle意識していますか？"
emoji: "🔨"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["Android", "Gradle", "CI"]
published: true
---

# TL;DR

- CIでGradleを忘れがちで各JobでGradle DLして時間もったいない
- Dockerfile内で直接Gradle versionやPATHを設定しているのはちょくちょく見る
- `./gradlew --gradle-user-home ./.gradleHome` でGradle展開先を指定するのが複数アプリ開発ではよさげ
