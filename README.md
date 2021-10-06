# memo_app
sinatraを使ったmemoアプリになります。CRUD処理を実装しており最低限のデザインもあてています。

# 使い方
①このリポジトリをローカルにダウンロードします。

②コマンドライン上でこのフォルダの階層に移動します。

③ローカルでDB用のテーブルを作成します。
PostgreSQLで自分のアカウントにログインします
```
$ psql -U アカウント名
```
`memos`というデータベースを作成します
```
アカウント名=# CREATE DATABASE memos;

テーブルを作成します
```
CREATE TABLE memos_app
(id  serial NOT NULL,
title text NOT NULL,
content text NOT NULL,
PRIMARY KEY (id));
```

④$ bundle exec ruby app.rbを実行します。

⑤http://localhost:4567にアクセスします。
