# Unit Test

# はじめに

本書はUnit testの実行方法を記述しています。

また以下の作業はrootユーザーで行ってください。

# 動作環境

CentOS-6.6にて動作確認を行いました。それよりも古い環境の場合は動作確認してませんので、ご了承下さい。

# 前提条件

トップページのREADME.md (Tiny Web Example)を読み環境構築が完了していること。

# configファイルの設定

```
# cd /opt/axsh/tiny-web-example/webapi/spec
# cp webapi.conf.example webapi.conf
```

DataBaseのIPアドレスを記述します
```
# vi webapi.conf
```

修正結果:
```
# Database connection string
database_uri 'mysql2://localhost/tiny_web_example?user=root'
```

# Unit Testの実行

```
# cd /opt/axsh/tiny-web-example/webapi/spec
# bundle exec rspec ./comment_spec.rb
``` 
