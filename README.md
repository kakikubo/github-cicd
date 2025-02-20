# github-cicd

## ghコマンド

### リポジトリ作成

```bash
gh repo create github-cicd --public --clone --add-readme
```

### 実行中ワークフローの確認

```bash
gh run watch
```

### ワークフローの確認

コミットを元に確認

```bash
% gh run view
? Select a workflow run  [Use arrows to move, type to filter]
> ✓ Manual, Manual [main] 3m12s ago
  ✓ 手動実行ワークフロー, Hello [main] 5m7s ago
  ✓ 元の正しい形に修正, Hello [main] 7m5s ago
  X 存在しないコマンドを実行するケース, Hello [main] 9m37s ago
  X インデントがおかしいパターン, Hello [main] 12m35s ago
```

ワークフロー名を指定して確認

```bash
% gh workflow view
? Select a workflow  [Use arrows to move, type to filter]
> Hello (hello.yml)
  Manual (manual.yml)
```

↓選択すると

```bash
? Select a workflow Hello (hello.yml)
Hello - hello.yml
ID: 141709944

Total runs 9
Recent runs
   TITLE                               WORKFLOW  BRANCH  EVENT  ID
✓  手動実行ワークフロー                Hello     main    push   13122328705
✓  元の正しい形に修正                  Hello     main    push   13122295067
X  存在しないコマンドを実行するケース  Hello     main    push   13122253144
X  インデントがおかしいパターン        Hello     main    push   13122204890
X  わざとまちがった構文でテスト        Hello     main    push   13122167330

To see more runs for this workflow, try: gh run list --workflow hello.yml
To see the YAML for this workflow, try: gh workflow view hello.yml --yaml
```

### ワークフローの実行

```bash
% gh workflow run manual.yml -f greeting=goodbye
```

#### トラブルシューティング

`gh workflow run`コマンドを実行する際に、以下のエラーが発生する場合があります:

```plaintext
could not create workflow dispatch event: HTTP 403: Must have admin rights to Repository.
```

このエラーを解決するために、以下を確認してください:

1. GitHubリポジトリに対する管理者権限があることを確認する。
2. `gh auth status`コマンドを使用して、GitHub CLIが正しいアカウントで認証されていることを確認する。
3. 必要に応じて、`gh auth login`コマンドを使用して再認証する。

## runner

インストールされているソフトウェアは以下で確認可能

<https://github.com/actions/runner-images>

## action

Github Marketplaceからアクションを探す事ができる

<https://github.com/marketplace>

## 中間環境変数

1. コンテキストはシェルコマンドへハードコードせず、環境変数を経由して渡す
2. 環境変数はすべてダブルクォーテーションで囲む

## Variables

以下からセットできる。
<https://github.com/kakikubo/github-cicd/settings/variables/actions>

```bash
% gh variable set USERNAME --body ':octcat:'
✓ Updated variable USERNAME for kakikubo/github-cicd
```

でも可能。

```plaintext
* failed to set variable "USERNAME": HTTP 403: Must have admin rights to Repository. (https://api.github.com/repos/kakikubo/github-cicd/actions/variables)
```

といわれる時は、`personal-access-token`の権限で`Variables`の設定を確認する。`Read And Write`になっていれば良い。

## Secrets

以下からセットできる。
<https://github.com/kakikubo/github-cicd/settings/secrets/actions>

```bash
gh secret set PASSWORD --body 'SuperSecret!'
```

## Permission関連のドキュメント

<https://docs.github.com/ja/rest>

## Linter

actionlintをローカルで実行するには以下の通り

```bash
docker run --rm -v "$(pwd):$(pwd)" -w "$(pwd)" rhysd/actionlint:latest
```

## リリースタグとリリースノートの作成

```bash
gh release create v0.1.0 --title "v0.1.0" --notes "Wonderful Text" example.txt
```

## パッケージのビルド

```bash
export GHCR_USER=$(gh config get -h github.com user)
docker build -t ghcr.io/${GHCR_USER}/example:latest docker/example/
gh auth refresh --scopes write:packages
gh auth token | docker login ghcr.io -u ${GHCR_USER} --password-stdin
docker push ghcr.io/${GHCR_USER}/example:latest
```

## パッケージとリポジトリを自動リンクさせるビルド

```bash
docker build -t ghcr.io/${GHCR_USER}/auto-link:latest \
  --label "org.opencontainers.image.source=https://github.com/${GHCR_USER}/github-cicd" \
  docker/example/
```

上記で問題なく動作する筈だが、リポジトリとの自動リンクがうまくいかないケースがあった為、`/.github/workflows/docker-publish.yml` からDockerのビルドとプッシュを
行うようにした。

## OpenSSF Scorecard

```bash
% docker run -e GITHUB_AUTH_TOKEN=$(gh auth token) \
  gcr.io/openssf/scorecard:stable --repo="kakikubo/github-cicd"
```
