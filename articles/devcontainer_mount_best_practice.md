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

