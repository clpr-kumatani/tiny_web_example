# Tiny Web Example

# はじめに

tiny_web_exampleはwebapiとfrontendからなる小規模な教材用アプリケーションです。

本書ではアプリケーションの実行に必要なパッケージのインストール手順と設定方法を記述しています。

テストやパッケージ作成方法については以下のディレクトリを参照してください。

* UnitTest:        tiny_web_example/webapi/spec/README.md
* IntegrationTest: tiny_web_example/spec_integration/README.md
* RPMBuild:        tiny_web_example/rpmbuild/README.md

また以下の作業はrootユーザーで行ってください。

# 動作環境

CentOS-6.6にて動作確認を行いました。それよりも古い場合は動作確認していませんので、ご了承ください。

# インストール

## epel環境の構築

tiny_web_exampleはmysql-serverとnginxを使用します。nginxはCentOSのBaseリポジトリには存在しないので、EPELリポジトリを利用してインストールします。

### epel-releaseのインストール

```
# rpm -ivh http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
```

実行結果例:
>```
># rpm -ivh http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
>Retrieving http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
>warning: /var/tmp/rpm-tmp.AFsABI: Header V3 RSA/SHA256 Signature, key ID 0608b895: NOKEY
>Preparing...                ########################################### [100%]
>   1:epel-release           ########################################### [100%]
>```

### リポジトリリストの確認

epelリポジトリが有効になったことを確認します。

```
# yum repolist
```

実行結果例:
>```
># yum repolist
>Loaded plugins: fastestmirror
>Loading mirror speeds from cached hostfile
> * base: ftp.yz.yamagata-u.ac.jp
> * epel: ftp.tsukuba.wide.ad.jp
> * extras: ftp.yz.yamagata-u.ac.jp
> * updates: ftp.yz.yamagata-u.ac.jp
>repo id                      repo name                                                            status
>base                         CentOS-6.6 - Base                                                     6,518
>*epel                        Extra Packages for Enterprise Linux 6 - x86_64                       11,557
>extras                       CentOS-6.6 - Extras                                                      38
>updates                      CentOS-6.6 - Updates                                                  1,134
>repolist: 19,247
>```

epelが表示されていれば、epelリポジトリは有効です。

## ruby環境のインストール

tiny_web_exampleはアプリケーションの動作にruby環境が必要です。ここではrbenvを使用してrubyとbundlerのインストールを行います。

### rbenvのインストール
```
# git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
```

実行結果例:
>```
># git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
>Initialized empty Git repository in /root/.rbenv/.git/
>remote: Counting objects: 2057, done.
>remote: Total 2057 (delta 0), reused 0 (delta 0), pack-reused 2057
>Receiving objects: 100% (2057/2057), 344.17 KiB | 74 KiB/s, done.
>Resolving deltas: 100% (1272/1272), done.
>```

### rbenvの設定
```
# echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
# echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
# exec $SHELL -l
```

### ruby-buildに必要なパッケージのインストール
```
# yum install -y gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel
```

実行結果例:
>```
># yum install -y gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel
>Loaded plugins: fastestmirror
>Setting up Install Process
>Loading mirror speeds from cached hostfile
> * base: ftp.jaist.ac.jp
> * epel: ftp.jaist.ac.jp
> * extras: ftp.jaist.ac.jp
> * updates: ftp.jaist.ac.jp
>Package gcc-4.4.7-11.el6.x86_64 already installed and latest version
>Resolving Dependencies
>__(省略)__
>
>Installed:
>  gdbm-devel.x86_64 0:1.8.0-36.el6                  libffi-devel.x86_64 0:3.0.5-3.2.el6
>  libyaml-devel.x86_64 0:0.1.3-4.el6_6              ncurses-devel.x86_64 0:5.7-3.20090208.el6
>  openssl-devel.x86_64 0:1.0.1e-30.el6.8            readline-devel.x86_64 0:6.0-4.el6
>  zlib-devel.x86_64 0:1.2.3-29.el6
>
>Dependency Installed:
>  keyutils-libs-devel.x86_64 0:1.4-5.el6             krb5-devel.x86_64 0:1.10.3-37.el6_6
>  libcom_err-devel.x86_64 0:1.41.12-21.el6           libselinux-devel.x86_64 0:2.0.94-5.8.el6
>  libsepol-devel.x86_64 0:2.0.41-4.el6               libyaml.x86_64 0:0.1.3-4.el6_6
>
>Complete!
>```

### ruby-buildのインストール

```
# git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
```

実行結果例:
>```
># git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
>Initialized empty Git repository in /root/.rbenv/plugins/ruby-build/.git/
>remote: Counting objects: 4530, done.
>remote: Total 4530 (delta 0), reused 0 (delta 0), pack-reused 4530
>Receiving objects: 100% (4530/4530), 847.84 KiB | 70 KiB/s, done.
>Resolving deltas: 100% (2344/2344), done.
>```

### rubyのインストール

```
# rbenv install -v 2.0.0-p598
```

実行結果例:
>```
># rbenv install -v 2.0.0-p598
>/tmp/ruby-build.20150522151700.11775 ~
>Downloading ruby-2.0.0-p598.tar.gz...
>HTTP/1.1 200 OK
>Content-Type: binary/octet-stream
>Content-Length: 13608640
>Connection: keep-alive
>Date: Mon, 11 May 2015 13:57:49 GMT
>Last-Modified: Thu, 13 Nov 2014 14:55:37 GMT
>ETag: "e043a21ce0d138fd408518a80aa31bba"
>Accept-Ranges: bytes
>Server: AmazonS3
>X-Cache: RefreshHit from cloudfront
>Via: 1.1 4565d1650806ee8cdd757034d90ec07d.cloudfront.net (CloudFront)
>X-Amz-Cf-Id: gn8DN0xoqLLljcQTklcAR2DABrq7vHhhqsmc2KrZ5Plkwtvpqz8_RA==
>
>-> http://dqw8nmjcqpjn7.cloudfront.net/4136bf7d764cbcc1c7da2824ed2826c3550f2b62af673c79ddbf9049b12095fd
>Installing ruby-2.0.0-p598...
>/tmp/ruby-build.20150522151700.11775/ruby-2.0.0-p598 /tmp/ruby-build.20150522151700.11775 ~
>__(省略)__
>
>Installed ruby-2.0.0-p598 to /root/.rbenv/versions/2.0.0-p598
>
>/tmp/ruby-build.20150522152934.22095 ~
>~
>```

### rbenvの再読み込み

```
# rbenv rehash
```

### rubyの設定

現在インストールされているrubyのバージョン一覧を確認する
```
# rbenv versions
```

実行結果例:
>```
># rbenv versions
>  2.0.0-p598
>```

### 使用するrubyのバージョンを設定する
```
# rbenv global 2.0.0-p598
# ruby -v
```

実行結果例:
>```
># ruby -v
>ruby 2.0.0p598 (2014-11-13 revision 48408) [x86_64-linux]
>```

### bundlerのインストール
```
# gem install bundler --no-ri --no-rdoc
```

実行結果例:
>```
># gem install bundler --no-ri --no-rdoc
>Fetching: bundler-1.9.9.gem (100%)
>Successfully installed bundler-1.9.9
>1 gem installed
>```

## Yumを使ったインストール

すでにRPMパッケージとリポジトリを作成済みの方はYumによるインストールを推奨します。

### repoファイルの作成
```
# curl -fsSkL \
> https://raw.githubusercontent.com/axsh/tiny_web_example/master/rpmbuild/tiny-web-example.repo \
> -o /etc/yum.repos.d/tiny-web-example.repo
```

### baseurlの修正

baseurlを作成したリポジトリのあるサーバーのIPアドレスに変更します。
```
# vi /etc/yum.repos.d/tiny-web-example.repo
```

修正結果:
```
[tiny-web-example]
name=tiny-web-example
baseurl=http://10.0.22.100/pub/
enabled=1
gpgcheck=0
```

### tiny_web_exampleのインストール
```
# yum install -y tiny-web-example
```

実行結果例:
>```
># yum install -y tiny-web-example
>Loaded plugins: fastestmirror
>Setting up Install Process
>Loading mirror speeds from cached hostfile
>epel/metalink                                                                    | 5.0 kB     00:00
> * base: ftp.jaist.ac.jp
> * epel: ftp.jaist.ac.jp
> * extras: ftp.jaist.ac.jp
> * updates: ftp.jaist.ac.jp
>base                                                                             | 3.7 kB     00:00
>base/primary_db                                                                  | 4.6 MB     00:00
>epel                                                                             | 4.4 kB     00:00
>epel/primary_db                                                                  | 6.5 MB     00:00
>extras                                                                           | 3.4 kB     00:00
>extras/primary_db                                                                |  31 kB     00:00
>tiny-web-example                                                                 | 2.9 kB     00:00
>tiny-web-example/primary_db                                                      | 3.7 kB     00:00
>updates                                                                          | 3.4 kB     00:00
>updates/primary_db                                                               | 3.3 MB     00:00
>Resolving Dependencies
>__(省略)__
>
>Installed:
>  tiny-web-example.x86_64 0:0.0.1-1.daily.el6
>
>Dependency Installed:
>  GeoIP.x86_64 0:1.6.5-1.el6                            GeoIP-GeoLite-data.noarch 0:2015.04-2.el6
>  GeoIP-GeoLite-data-extra.noarch 0:2015.04-2.el6       compat-readline5.x86_64 0:5.2-17.1.el6
>  fontconfig.x86_64 0:2.8.0-5.el6                       freetype.x86_64 0:2.3.11-15.el6_6.1
>  gd.x86_64 0:2.0.35-11.el6                             geoipupdate.x86_64 0:2.2.1-2.el6
>  libX11.x86_64 0:1.6.0-2.2.el6                         libX11-common.noarch 0:1.6.0-2.2.el6
>  libXau.x86_64 0:1.0.6-4.el6                           libXpm.x86_64 0:3.5.10-2.el6
>  libjpeg-turbo.x86_64 0:1.2.1-3.el6_5                  libpng.x86_64 2:1.2.49-1.el6_2
>  libxcb.x86_64 0:1.9.1-2.el6                           libxslt.x86_64 0:1.1.26-2.el6_3.1
>  mysql.x86_64 0:5.1.73-3.el6_5                         mysql-server.x86_64 0:5.1.73-3.el6_5
>  nginx.x86_64 0:1.0.15-11.el6                          nginx-filesystem.noarch 0:1.0.15-11.el6
>  perl-DBD-MySQL.x86_64 0:4.013-3.el6                   perl-DBI.x86_64 0:1.609-4.el6
>  ruby.x86_64 0:1.8.7.374-4.el6_6                       ruby-libs.x86_64 0:1.8.7.374-4.el6_6
>
>Complete!
>```

## Gitを使用したインストール

### ソースコードの取得

```
# git clone https://github.com/axsh/tiny_web_example.git
# mkdir -p /opt/axsh
# mv -i tiny_web_example /opt/axsh/tiny-web-example
```

実行結果例:
>```
># git clone https://github.com/axsh/tiny_web_example.git
>Initialized empty Git repository in /home/vagrant/tiny_web_example/.git/
>remote: Counting objects: 295, done.
>remote: Compressing objects: 100% (10/10), done.
>remote: Total 295 (delta 3), reused 0 (delta 0), pack-reused 285
>Receiving objects: 100% (295/295), 288.04 KiB | 165 KiB/s, done.
>Resolving deltas: 100% (105/105), done.
># mkdir -p /opt/axsh
># mv -i tiny_web_example /opt/axsh
>```

### 依存パッケージのインストール

```
# yum install -y nginx mysql-server mysql-devel
```


実行結果例:
>```
># yum install -y nginx mysql-server mysql-devel
>Loaded plugins: fastestmirror
>Setting up Install Process
>Loading mirror speeds from cached hostfile
> * base: ftp.jaist.ac.jp
> * extras: ftp.jaist.ac.jp
> * updates: ftp.jaist.ac.jp
>No package nginx available.
>Resolving Dependencies
>--> Running transaction check
>___(省略)___
>
>Installed:
>  mysql-devel.x86_64 0:5.1.73-3.el6_5                mysql-server.x86_64 0:5.1.73-3.el6_5
>
>Dependency Installed:
>  keyutils-libs-devel.x86_64 0:1.4-5.el6             krb5-devel.x86_64 0:1.10.3-37.el6_6
>  libcom_err-devel.x86_64 0:1.41.12-21.el6           libselinux-devel.x86_64 0:2.0.94-5.8.el6
>  libsepol-devel.x86_64 0:2.0.41-4.el6               mysql.x86_64 0:5.1.73-3.el6_5
>  openssl-devel.x86_64 0:1.0.1e-30.el6.8             perl-DBD-MySQL.x86_64 0:4.013-3.el6
>  perl-DBI.x86_64 0:1.609-4.el6                      zlib-devel.x86_64 0:1.2.3-29.el6
>
>Complete!
>```

### gemパッケージのインストール

webapiで使用するgemをインストールする
```
# cd /opt/axsh/tiny-web-example/webapi
# bundle install
```

実行結果例:
>```
># bundle install
>Don't run Bundler as root. Bundler can ask for sudo if it is needed, and installing your bundle as root
>will break this application for all non-root users on this machine.
>Fetching gem metadata from https://rubygems.org/.........
>Fetching version metadata from https://rubygems.org/..
>Resolving dependencies...
>Installing rake 10.4.2
>Installing backports 3.6.4
>Using bundler 1.9.9
>Installing diff-lcs 1.2.5
>Installing fuguta 1.0.4
>Installing get_process_mem 0.2.0
>Installing kgio 2.9.3
>Installing multi_json 1.11.0
>Installing mysql2 0.3.18
>Installing rack 1.6.1
>Installing rack-cors 0.4.0
>Installing rack-protection 1.5.3
>Installing rack-test 0.6.3
>Installing raindrops 0.13.0
>Installing rspec-support 3.2.2
>Installing rspec-core 3.2.3
>Installing rspec-expectations 3.2.1
>Installing rspec-mocks 3.2.1
>Installing rspec 3.2.0
>Installing sequel 4.22.0
>Installing tilt 1.4.1
>Installing sinatra 1.4.6
>Installing sinatra-contrib 1.4.2
>Installing unicorn 4.9.0
>Installing unicorn-worker-killer 0.4.3
>Bundle complete! 11 Gemfile dependencies, 25 gems now installed.
>Bundled gems are installed into ./vendor/bundle.
>```

frontendで使用するgemをインストールする
```
# cd /opt/axsh/tiny-web-example/frontend
# bundle install
```

実行結果例:
>```
># bundle install
>Don't run Bundler as root. Bundler can ask for sudo if it is needed, and installing your bundle as root
>will break this application for all non-root users on this machine.
>Fetching gem metadata from https://rubygems.org/..........
>Fetching version metadata from https://rubygems.org/..
>Resolving dependencies...
>Installing backports 3.6.4
>Using bundler 1.9.9
>Installing get_process_mem 0.2.0
>Installing kgio 2.9.3
>Installing multi_json 1.11.0
>Installing mysql2 0.3.18
>Installing rack 1.6.1
>Installing rack-protection 1.5.3
>Installing rack-test 0.6.3
>Installing raindrops 0.13.0
>Installing sequel 4.22.0
>Installing tilt 1.4.1
>Installing sinatra 1.4.6
>Installing sinatra-contrib 1.4.2
>Installing unicorn 4.9.0
>Installing unicorn-worker-killer 0.4.3
>Bundle complete! 7 Gemfile dependencies, 16 gems now installed.
>Bundled gems are installed into ./vendor/bundle.
>```

### 起動スクリプトの配置
```
# cd /opt/axsh/tiny-web-example/contrib/etc
# cp default/* /etc/default/
# cp init/* /etc/init/
```

### configファイルの配置
```
# mkdir -p /etc/tiny-web-example
# cp tiny-web-example/* /etc/tiny-web-example/
```

### logディレクトリの作成
```
# mkdir -p /var/log/tiny-web-example
```

# 設定

## 起動スクリプトの設定

webapiの起動スクリプトを修正する
```
# vi /etc/default/tiny-web-example-webapi
```

修正結果:
```
# tiny-web-example
EXAMPLE_ROOT=/opt/axsh/tiny-web-example
PATH=/root/.rbenv/shims:$PATH

# Commnet out to run the vdc init script.
#RUN=yes

## rack params
RACK_ENV=development
BIND_ADDR=0.0.0.0
PORT=8080
UNICORN_CONF=/etc/tiny-web-example/unicorn-common.conf
```

frontendの起動スクリプトを修正する
```
# vi /etc/default/tiny-web-example-webapp
```

修正結果:
```
# tiny-web-example
EXAMPLE_ROOT=/opt/axsh/tiny-web-example
PATH=/root/.rbenv/shims:$PATH

# Commnet out to run the vdc init script.
#RUN=yes

## rack params
RACK_ENV=development
BIND_ADDR=0.0.0.0
PORT=80
UNICORN_CONF=/etc/tiny-web-example/unicorn-common.conf
```

## configファイルの設定

webapiとfrontendが接続するDatabaseのアドレスを記述します

webapi.confの修正
```
# vi /etc/tiny-web-example/webapi.conf
```

修正結果:
```
# Database connection string
database_uri 'mysql2://localhost/tiny_web_example?user=root'
```

webapp.ymlの修正
```
# vi /etc/tiny-web-example/webapp.yml
```

修正結果:
```
database_uri: 'mysql2://localhost/tiny_web_example?user=root'
```

## mysqldの起動
```
# service mysqld start
```

実行結果例:
>```
>Initializing MySQL database:  WARNING: The host 'vagrant-centos6' could not be looked up with resolveip.
>This probably means that your libc libraries are not 100 % compatible
>with this binary MySQL version. The MySQL daemon, mysqld, should work
>normally with the exception that host name resolving will not work.
>This means that you should use IP addresses instead of hostnames
>when specifying MySQL privileges !
>Installing MySQL system tables...
>OK
>Filling help tables...
>OK
>
>To start mysqld at boot time you have to copy
>support-files/mysql.server to the right place for your system
>
>PLEASE REMEMBER TO SET A PASSWORD FOR THE MySQL root USER !
>To do so, start the server, then issue the following commands:
>
>/usr/bin/mysqladmin -u root password 'new-password'
>/usr/bin/mysqladmin -u root -h vagrant-centos6 password 'new-password'
>
>Alternatively you can run:
>/usr/bin/mysql_secure_installation
>
>which will also give you the option of removing the test
>databases and anonymous user created by default.  This is
>strongly recommended for production servers.
>
>See the manual for more instructions.
>
>You can start the MySQL daemon with:
>cd /usr ; /usr/bin/mysqld_safe &
>
>You can test the MySQL daemon with mysql-test-run.pl
>cd /usr/mysql-test ; perl mysql-test-run.pl
>
>Please report any problems with the /usr/bin/mysqlbug script!
>
>                                                           [  OK  ]
>Starting mysqld:                                           [  OK  ]
>```

## DataBaseの作成
```
# mysqladmin create tiny_web_example
```

## DataBaseTableの作成
```
# cd /opt/axsh/tiny-web-example/webapi/
# bundle exec rake db:up
```

# アプリケーションの実行

## webapiの起動
```
# initctl start tiny-web-example-webapi RUN=yes
```

実行結果例:
>```
># initctl start tiny-web-example-webapi RUN=yes
>tiny-web-example-webapi start/running, process 2996
>```

## frontendの起動
```
# initctl start tiny-web-example-webapp RUN=yes
```

実行結果例:
>```
># initctl start tiny-web-example-webapp RUN=yes
>tiny-web-example-webapp start/running, process 2988
>```

# アプリケーションの動作確認

## webapiの確認

POSTの確認
```
# curl -fs -X POST --data-urlencode display_name='webapi test' --data-urlencode comment='sample message.' http://localhost:8080/api/0.0.1/comments
```

実行結果例:
>```
>{"id":1,"display_name":"webapi test","comment":"sample message.","created_at":"2015-05-21 11:18:07 UTC","updated_at":"2015-05-21 11:18:07 UTC"}
>```

GETの確認(list)
```
# curl -fs -X GET http://localhost:8080/api/0.0.1/comments
```

実行結果例:
>```
>[{"total":2,"results":[{"id":1,"display_name":"webapi test","comment":"sample message.","created_at":"2015-05-21 11:18:07 UTC","updated_at":"2015-05-21 11:18:07 UTC"},{"id":2,"display_name":"webapi test","comment":"sample message 2.","created_at":"2015-05-21 11:19:04 UTC","updated_at":"2015-05-21 11:19:04 UTC"}]}]
>```

GETの確認(show)
```
# curl -fs -X GET http://localhost:8080/api/0.0.1/comments/1
```

実行結果例:
>```
>{"id":1,"display_name":"webapi test","comment":"sample message.","created_at":"2015-05-21 11:18:07 UTC","updated_at":"2015-05-21 11:18:07 UTC"}
>```

## frontendの確認

Webブラウザからアクセスすると以下のような画面が表示されます

![sample_bbs](https://cloud.githubusercontent.com/assets/380254/7747443/675f3c94-fff5-11e4-9d03-4eb74a2c68e1.png)

NameとCommentを入れて動作するか確認してみましょう

