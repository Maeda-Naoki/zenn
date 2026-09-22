---
title: "GitLab for Open Source Programに登録しようぜ"
emoji: "🧑‍💻"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["GitLab", "OSS", "CICD"]
published: true
---

:::message

この記事は、[GitLab Advent Calendar 2023](https://qiita.com/advent-calendar/2023/gitlab)の20日目の記事になります。

:::

https://qiita.com/advent-calendar/2023/gitlab

# TL;DR

- [GitLab.com](https://gitlab.com/)のFreeアカウントで使える[GitLab CI](https://docs.gitlab.com/ee/ci/)の時間は400分。
- [GitLab for Open Source](https://about.gitlab.com/solutions/open-source/)に登録すると[GitLab Ultimate](https://about.gitlab.com/solutions/open-source/#:~:text=potential.%20Features%20of-,GitLab%20Ultimate,-%E2%80%94including%2050%2C000%20compute)の機能が開放されるので[GitLab CI](https://docs.gitlab.com/ee/ci/)の時間は50,000分になる。
- [GitLab for Open Source](https://about.gitlab.com/solutions/open-source/)は、OSSライセンス設定しているPublicリポジトリなら登録できる。

# [GitLab CI](https://docs.gitlab.com/ee/ci/)のCompute quota

GitLab v16.1までは、`CI/CD minutes`と呼ばれていました。  
要するに[GitLab CI](https://docs.gitlab.com/ee/ci/)の共用Runnerを動かせる時間です。  
[アカウント種別](https://about.gitlab.com/pricing/)によって時間は異なるが、Freeアカウントであれば400分使用できる。

![](https://storage.googleapis.com/zenn-user-upload/9320e26d09d6-20231223.png)

> 昔はPublicなOSSリポジトリは、`CI/CD minutes`にかなり長めの時間が設定されていたが、マイニング対策か[制限時間が設定された](https://about.gitlab.com/blog/2020/09/01/ci-minutes-update-free-users/)。

# [GitLab for Open Source Program](https://about.gitlab.com/solutions/open-source/)

[GitLab for Open Source Program](https://about.gitlab.com/solutions/open-source/)に参加できれば、self-managedまたはSaaS版のGitLabで[GitLab Ultimate](https://about.gitlab.com/solutions/open-source/#:~:text=potential.%20Features%20of-,GitLab%20Ultimate,-%E2%80%94including%2050%2C000%20compute)の機能が開放されます。

:::message

self-managed版GitLabは、Runnerも自前用意なのでCompute quotaに関する恩恵はなし。

:::

## 参加条件

GitLab for Open Source Programへの参加条件は3つ[^1]です。

1. MITライセンスなどの **[OSI Approved Licenses](https://opensource.org/licenses/)を設定していること**
2. **非営利であること**
3. **Publicリポジトリであること**

一般的なOSSリポジトリであれば、上記条件は自然と満たしています。

## 登録手順

下の入力欄を埋めるだけでいい。

![](https://storage.googleapis.com/zenn-user-upload/df820660c1b5-20231223.png)

主な入力内容は下記になります。

- 名前
- メールアドレス
- プロジェクト説明
- プロジェクトの公開設定
- ライセンス情報

:::message

ライセンス情報は、LICENSEファイルのリンクに加えてスクショが必要です。

> Take screenshots. During the application process, you'll need to provide three screenshots of your project. We suggest taking them in advance, since you’ll need to submit them on the second page of the application form.

:::

## 登録完了

登録が完了すると下記のようなメールが届きます。  
![](https://storage.googleapis.com/zenn-user-upload/271e637472b9-20231223.png)

たったこれだけの登録で[GitLab Ultimate](https://about.gitlab.com/solutions/open-source/#:~:text=potential.%20Features%20of-,GitLab%20Ultimate,-%E2%80%94including%2050%2C000%20compute)が付与されるのは太っ腹以外の何者でもないので皆さま是非登録させてもらいましょう。

## おまけ

[GitLab for Open Source Program](https://about.gitlab.com/solutions/open-source/)は、 **1年毎に更新が必要** [^2] です。
3ヶ月前から更新可能なようですので、早めに更新しましょう。

[^1]: https://about.gitlab.com/solutions/open-source/join/

[^2]: https://about.gitlab.com/solutions/open-source/join/#must-i-renew-my-membership-in-the-program
