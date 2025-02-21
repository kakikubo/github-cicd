# export GHCR_USER=$(gh config get -h github.com user) を実行しておく
# docker build -t ghcr.io/${GHCR_USER}/example:latest docker/example/ でビルド
# gh auth refresh --scopes write:packages
# gh auth token | docker login ghcr.io -u ${GHCR_USER} --password-stdin
# docker push ghcr.io/${GHCR_USER}/example:latest
# docker pull ghcr.io/${GHCR_USER}/example:latest
FROM nginx:1.27-alpine
ARG GHCR_USER
LABEL org.opencontainers.image.source https://github.com/${GHCR_USER}/github-cicd
RUN echo 'Hello Github Packages' > /usr/share/nginx/html/index.html

# 非rootユーザーを作成し、実行ユーザーを変更
RUN adduser -D appuser
USER appuser
