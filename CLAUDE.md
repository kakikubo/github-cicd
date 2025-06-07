# CLAUDE.md

このファイルは、このリポジトリのコードを扱う際にClaude Code（claude.ai/code）へのガイダンスを提供します。

## プロジェクト概要

このリポジトリはGitHub Actions CI/CDの例とデモンストレーションのコレクションです。さまざまなワークフロー設定、Docker設定、Goコード例、およびGitHub Actionsのポリシーが含まれています。

### リポジトリ構造

- `.github/workflows/`: CI/CDのさまざまな側面をカバーする多数のGitHub Actionsワークフロー例を含みます
- `docker/example/`: Dockerの設定例
- `go/`: デモンストレーションプロジェクト付きのGoコード例
- `policy/`: GitHub Actionsワークフローの検証用Regoポリシーファイル

## 一般的なコマンド

### GitHub CLI (gh) コマンド

```bash
# 実行中のワークフローを表示
gh run watch

# ワークフローの詳細を表示
gh workflow view

# ワークフローを実行
gh workflow run manual.yml -f greeting=goodbye

# アセット付きでリリースを作成
gh release create v0.1.0 --title "v0.1.0" --notes "リリースノート" example.txt

# 変数とシークレットを設定
gh variable set VARIABLE_NAME --body '値'
gh secret set SECRET_NAME --body '値'
```

### Dockerコマンド

```bash
# Dockerイメージをビルド
export GHCR_USER=$(gh config get -h github.com user)
docker build -t ghcr.io/${GHCR_USER}/example:latest docker/example/

# GitHub Container Registryに認証
gh auth refresh --scopes write:packages
gh auth token | docker login ghcr.io -u ${GHCR_USER} --password-stdin

# イメージをGitHub Container Registryにプッシュ
docker push ghcr.io/${GHCR_USER}/example:latest

# リポジトリへの自動リンク付きでビルド
docker build -t ghcr.io/${GHCR_USER}/auto-link:latest \
  --label "org.opencontainers.image.source=https://github.com/${GHCR_USER}/github-cicd" \
  docker/example/
```

### Goコマンド

```bash
# excellentパッケージでテストを実行
cd go/excellent
go test ./...

# バージョン情報付きでexampleをビルド
go build -o example -ldflags "-X main.version=v1.2.3" go/example/main.go
```

### リンティングとセキュリティスキャン

```bash
# GitHub Actionsワークフロー検証のためのactionlintを実行
docker run --rm -v "$(pwd):$(pwd)" -w "$(pwd)" rhysd/actionlint:latest

# シークレットスキャンのためのGitleaksを実行
docker run -v $(pwd):$(pwd) -w "$(pwd)" \
  --rm -it zricethezav/gitleaks detect --source="$(pwd)" --verbose --redact \
  --log-opts="--all --full-history"

# OpenSSF Scorecardを実行
docker run -e GITHUB_AUTH_TOKEN=$(gh auth token) \
  gcr.io/openssf/scorecard:stable --repo="owner/repo"
```

## GitHub Actionsセキュリティのベストプラクティス

1. 中間環境変数を使用してコンテキスト値を安全に渡す
2. 環境変数は常に二重引用符で囲む
3. 最小限の必要なアクセス権限でワークフローレベルの権限を使用する
4. Regoポリシーを使用したconftestでワークフローファイルを検証する

## ワークフローポリシー

このリポジトリにはワークフロー検証用のRegoポリシーが含まれています。ポリシーは以下を強制します：

- ワークフローでの明示的な権限定義
- ワークフローレベルでの空の権限（権限はジョブレベルで定義する必要がある）

これらのポリシーに対してワークフローを検証するにはconftestを使用します。