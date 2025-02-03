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

```
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
