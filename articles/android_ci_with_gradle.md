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

# よく見るAndroid向けDockerfile

GitLab CIのテンプレート[^1]を見ると、Android SDKはインストールしているが`Gradle`については全く触れていない。

```yml
# Packages installation before running script
before_script:
  ...
  - wget --no-verbose --output-document=$ANDROID_HOME/cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS}_latest.zip
  - unzip -q -d "$ANDROID_HOME/cmdline-tools" "$ANDROID_HOME/cmdline-tools.zip"
  - mv -T "$ANDROID_HOME/cmdline-tools/cmdline-tools" "$ANDROID_HOME/cmdline-tools/tools"
  - export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/cmdline-tools/tools/bin

  # use yes to accept all licenses
  - yes | sdkmanager --licenses > /dev/null || true
  - sdkmanager "platforms;android-${ANDROID_COMPILE_SDK}"
  - sdkmanager "platform-tools"
  - sdkmanager "build-tools;${ANDROID_BUILD_TOOLS}"
...
```

#### ✅Good Point

- スクリプトがシンプルで読みやすくメンテナンスしやすい

#### ❌Bad Point

- 各JobでGradleがDLされてCI時間がぞうかしてしまう
  - どうなるかというと、`Build`・`Lint`・`Test`などの各JobでGradleをDLしてしまいます
