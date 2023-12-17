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

# Graldeも同梱されているDockerfile

BitriseのAndroid向け`Dockerfile`[^2]を見ると、Android SDKに加えて`Gradle`もインストールしている。  
インストールする`Gradle`のバージョンについては、環境変数`GRADLE_VERSION`で指定している模様。

```Dockerfile
...
# --- Install Gradle from PPA

# Gradle PPA
ENV GRADLE_VERSION=6.3
ENV PATH=$PATH:"/opt/gradle/gradle-6.3/bin/"
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip -P /tmp \
    && unzip -d /opt/gradle /tmp/gradle-*.zip \
    && chmod +775 /opt/gradle \
    && gradle --version \
    && rm -rf /tmp/gradle*
...
```

#### ✅Good Point

- `Gralde`もDocker Imageとして配布されるため環境差分が発生しない

#### ❌Bad Point

- `GRADLE_VERSION`のメンテを忘れると、古い`Gradle`使い続けることになる
  - ちなみに通常`Gradle`バージョンは、`gradle-wrapper.properties`で定義されている

# 結局どうしたのか

[よく見るAndroid向けDockerfile](#よく見るandroid向けdockerfile)と[Graldeも同梱されているDockerfile](#graldeも同梱されているdockerfile)を見て、
「**これCIのキャッシュに任せたほうがいいんじゃない**」っと思ったので下記のよう[^3]にして見ました。

```yml
debugBuild:
  stage: debug
  image: $CI_REGISTRY_IMAGE:latest
  script:
    - ./gradlew --gradle-user-home ./.gradleHome assembleDebug
  cache:
    key: ${CI_COMMIT_REF_SLUG}
    policy: pull-push
    paths:
      - ./.gradleHome
```

Workingディレクトリ配下の`.gradleHome`に、`Gradle`をDLするように指定して、CIのキャッシュに`.gradleHome`を設定しています。
これで後続のJobは`.gradleHome`をキャッシュとして再利用します。
`Gradle`は、**ユーザーホームディレクトリに`Gradle`が既に存在する場合はDLを行わず**、本来のJobを実行します。
