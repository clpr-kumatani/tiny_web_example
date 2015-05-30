# Integration Test

# はじめに

本書はIntegration testの実行方法を記述しています。

また以下の作業はrootユーザーで行ってください。

# 動作環境

CentOS-6.6にて動作確認を行いました。それよりも古い環境の場合は動作確認してませんので、ご了承下さい。

# 前提条件

トップページのREADME.md (Tiny Web Example)を読み環境構築が完了していること。

# Gemのインストール
```
# cd /opt/axsh/tiny-web-example/spec_integration
# bundle install
```

実行結果例:
>```
># bundle install
>Don't run Bundler as root. Bundler can ask for sudo if it is needed, and installing your bundle as root will break this application for all
>non-root users on this machine.
>Fetching gem metadata from https://rubygems.org/.........
>Fetching version metadata from https://rubygems.org/..
>Resolving dependencies...
>Using bundler 1.9.9
>Installing diff-lcs 1.2.5
>Installing rspec-support 3.2.2
>Installing rspec-core 3.2.3
>Installing rspec-expectations 3.2.1
>Installing rspec-mocks 3.2.1
>Installing rspec 3.2.0
>Bundle complete! 2 Gemfile dependencies, 7 gems now installed.
>Bundled gems are installed into ./vendor/bundle.
>```

# Configの設定
```
# cd /opt/axsh/tiny-web-example/spec_integration/config
# cp webapi.conf.example webapi.conf
```

webapiに接続するDataBaseのIPアドレスを記述します
```
# vi webapi.conf
```

修正結果:
```
uri: 'http://localhost:8080'
```

# Integration Testの実行
```
# cd /opt/axsh/tiny-web-example/spec_integration
# bundle exec rspec ./spec/webapi_integration_spec.rb
```

実行結果例:
>```
># bundle exec rspec ./spec/webapi_integration_spec.rb
>
>Webapi Integration spec
>  post
>    create a new comment
>  get
>    show list for the comments
>    show detail the comment
>
>Finished in 0.04481 seconds (files took 0.15042 seconds to load)
>3 examples, 0 failures
>
>```
