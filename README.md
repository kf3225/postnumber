# 開発環境構築 

Dockerを使用しての開発環境構築の学習用です

注意点などを羅列

docker-compose.yml
==

- ディレクトリ構成はこんな感じ
```
├── README.md
├── app
│   ├── build
│   │   └── Dockerfile
│   ├── cmd
│   │   └── sampleapp
│   │       └── main.go
│   └── go.mod
├── docker-compose.yml ←　ここ
├── nginx
│   ├── build
│   │   └── Dockerfile
│   └── conf.d
│       └── default.conf
├── pgadmin
│   └── storage
│       └── root_github.com
└── postgresql
    ├── build
    │   └── Dockerfile
    └── docker-entrypoint-initdb.d
        └── setup.sql
```
- contextはdocker-compose.yml配置場所からの相対パスで記述
- depends_onは依存関係を示す→そのコンテナがビルドされた後にビルド実行される
- networksを使用してサブネットやコンテナがどのネットワークに属すのかを記述可能でlinksよりも積極的に使用したい

<br />

Dockerfile(Golangのホットリロード)
==

```
FROM golang:1.15.3-alpine3.12

WORKDIR /go/src/app
COPY ./cmd ./cmd

RUN apk update && apk add git
RUN go get -d -v github.com/lib/pq
RUN go get -v github.com/cespare/reflex
CMD reflex -r '(\.go$|go\.mod)' -s go run cmd/sampleapp/main.go
```

- reflexを使用するものとする
- RUNコマンドにgo getでモジュールを取得する処理を記述
- CMDでreflexコマンドを実行するように記述するとホットリロードで変更が即時反映される環境が構築可能

<br />

Dockerfile(nginx)
==

```
FROM nginx:1.19-alpine

WORKDIR /etc/nginx/conf.d
ADD ./conf.d/default.conf .

CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
```

- default.confを/etc/nginx/conf.d配下に配置できるようにWORKDIRに設定
- daemon off→Dockerコンテナはコマンドがフォアグラウンドで実行されないとexitしてコンテナが落ちてしまうのでdaemon offにすることによってnginxをバックグラウンド実行させなければならない

<br />

default.conf
==

```
upstream goapp {
  server 172.30.0.5:8080;
}

server {
  listen 80;
  server_name proxy_server;

  location / {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Host $remote_addr;
    proxy_pass http://goapp;
  }
}
```

- locationディレクティブ以下はリバースプロキシする際の設定
- upstreamにリバースプロキシでどのサーバーにアクセスさせるかを記述
- コンテナの名前解決がよく分からなかったので、IPアドレスを直打ち（docker-compose.ymlの各コンテナのnetworksで設定しているのでそれを使用）
