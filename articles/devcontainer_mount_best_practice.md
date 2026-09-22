---
title: "DevContainerのマウントベストプラクティス"
emoji: "🐳"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["VSCode", "DevContainer", "Docker"]
published: true
---

# TL;DR

- `remoteUser`/`updateRemoteUserUID`で`UID`/`GID`を自動的にホスト/コンテナで一致させる
- DevContainerでホストとコンテナ間でソースコードなどを共有するときは、バインドマウントとしてContainerに接続すれば良い
- `node_modules`などホストで管理しなくて良いものは、ボリュームマウントとしてContainerに接続すれば良い

**これらはいずれも`devcontainer.json`で設定できる**

```json:devcontainer.json
{
    // UID/GID更新
    "remoteUser": "author",
    // バインドマウント
    "workspaceFolder": "/home/author/Article",
    "workspaceMount": "source=${localWorkspaceFolder},target=/home/author/Article,type=bind,consistency=cached",
    // ボリュームマウント
    "mounts": [
      "source=${devcontainerId}-node_modules,target=${containerWorkspaceFolder}/node_modules,type=volume",
      "source=${devcontainerId}-pnpm-store,target=${containerWorkspaceFolder}/.pnpm-store,type=volume"
    ],
    "postCreateCommand": "sudo chown -R $(id -u):$(id -g) ${containerWorkspaceFolder}/node_modules ${containerWorkspaceFolder}/.pnpm-store",
}
```

![記事まとめ画像](/images/DevcontainerHostBind/Summary.png)

# 前提

- [`DevContainer`](https://code.visualstudio.com/docs/devcontainers/containers)で開発をコンテナ内で行っている。
- コンテナでRootユーザーではなく、Non-Rootユーザーを使用している。

上記の場合、コンテナ側のNon-Rootユーザーとホスト側のユーザーのUIDが一致しないと、ファイル保存に失敗してしまう。

### （個人的）これまでの対策

これまでは`compose.yaml`や`Dockerfile`でコンテナ内のNon-RootユーザーのUIDを調整していたが、直接ファイル編集するのは面倒だし、`UID`設定用のスクリプトを使うのもイケてない。

```yaml:compose.yaml
services:
  node:
    build:
      context: ./
      args:
        UID: $UID
```

```bash:setDotEnv.sh
#!/bin/bash

echo "UID=$(id -u $USER)" > .env
```

# ベストプラクティス

### `UID`/`GID`更新

`updateRemoteUserUID`

コンテナ側ユーザーの`UID`/`GID`をホスト側ユーザーと一致してくれるようにしてくれるオプション  
有効化するには`containerUser`か`remoteUser`が設定されている必要がある。

:::message
デフォルトで`True`なので、明示的な設定不要です。
:::

### バインドマウント

```json:devcontainer.json
{
    "workspaceFolder": "/home/author/Article",  // ↓のworkspaceMount設定に必要なので設定しておく
    "workspaceMount": "source=${localWorkspaceFolder},target=/home/author/Article,type=bind,consistency=cached",
}
```

- `source=${localWorkspaceFolder}`
  - バインドマウントのソースディレクトリを指定する
  - 基本的に`${localWorkspaceFolder}`を指定しておけば良い
    - [pre-defined variables](https://containers.dev/implementors/json_reference/#variables-in-devcontainerjson)で定義されている
- `target=/home/author/Article`
  - バインドマウントのターゲットディレクトリを指定する
- `type=bind`
  - バインドマウントを意味する
    - このあたりは[Docker CLI --mount flag](https://docs.docker.com/reference/cli/docker/container/run/#mount)と同じ
- `consistency=cached`
  - Dockerの[パフォーマンス最適化オプション](https://docs.docker.jp/desktop/mac/osxfs-caching.html)
    - `consistent`: ホストとコンテナを常に同期
    - `cached`: ホスト側の更新を優先
    - `delegated`: コンテナ側の更新を優先
    - `default`: `consistent`と同じ

### ボリュームマウント

バインドマウントのついでに、`node_modules`や`.pnpm-store`など、リポジトリで管理していないファイルについてはボリュームマウントで管理するほうが速度的に良いので合わせて設定する。

ボリュームマウントの設定は`compose.yaml`でも行えるが、このためだけに`compose.yaml`を追加するのは面倒なのでバインドマウントと合わせて`devcontainer.json`に設定する。

```json:devcontainer.json
{
    "mounts": [
      "source=${devcontainerId}-node_modules,target=${containerWorkspaceFolder}/node_modules,type=volume",
      "source=${devcontainerId}-pnpm-store,target=${containerWorkspaceFolder}/.pnpm-store,type=volume"
    ],
    "postCreateCommand": "sudo chown -R $(id -u):$(id -g) ${containerWorkspaceFolder}/node_modules ${containerWorkspaceFolder}/.pnpm-store",
}
```

- `source=${devcontainerId}-node_modules`
  - ボリュームマウントのボリューム名を指定する
  - ボリューム名は重複禁止なので、他プロジェクトの`node_modules`ボリュームと重複しないように`${devcontainerId}`をプレフィックスとして付与する
- `target=${containerWorkspaceFolder}/node_modules`
  - ボリュームマウントのターゲットディレクトリを指定する
- `type=volume`
  - ボリュームマウントを意味する
    - このあたりは[Docker CLI --mount flag](https://docs.docker.com/reference/cli/docker/container/run/#mount)と同じ
- `postCreateCommand`
  - コンテナ作成後に実行する任意コマンド
  - 作成したボリュームのOwnerが`Root`なので、コンテナ作成後に所有者をNon-Root Userに変更する
    - Non-Root Userだと`sudo`が使えないので`Dockerfile`で`sudo`のインストールと`chown`だけパスワードレスで実行できるようにする

```Dockerfile:Dockerfile
# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
	sudo=1.9.16p2-3+deb13u2		&& \
	echo "${UserName} ALL=(ALL) NOPASSWD: /usr/bin/chown" > /etc/sudoers.d/${UserName} && \
	chmod 0440 /etc/sudoers.d/${UserName} && \
	rm -rf /var/lib/apt/lists/*
```

