# RPM Build

# はじめに

本書ではtiny-web-exampleのRPMパッケージ作成手順を記述しています。

また以下の作業はrootユーザーで行ってください。

# 動作環境

CentOS-6.6にて動作確認を行いました。それよりも古い環境の場合は動作確認してませんので、ご了承下さい。

# 前提条件

トップページのREADME.md (Tiny Web Example)を読み環境構築が完了していること。

# rpmbuild環境の構築

rpmをビルドするために必要なパッケージをインストールします
```
# yum install -y rpm-build rpmlint yum-utils
```

実行結果例:
>```
># yum install -y rpm-build rpmlint yum-utils
>Loaded plugins: fastestmirror
>Setting up Install Process
>Loading mirror speeds from cached hostfile
> * base: mirror.fairway.ne.jp
> * epel: ftp.iij.ad.jp
> * extras: mirror.fairway.ne.jp
> * updates: mirror.fairway.ne.jp
>Resolving Dependencies
>__(省略)__
>
>Installed:
>  rpm-build.x86_64 0:4.8.0-38.el6_6                 rpmlint.noarch 0:0.94-3.1.el6                 yum-utils.noarch 0:1.1.30-30.el6
>
>Dependency Installed:
>  desktop-file-utils.x86_64 0:0.15-9.el6 elfutils.x86_64 0:0.158-3.2.el6 enchant.x86_64 1:1.5.0-4.el6          gdb.x86_64 0:7.2-75.el6
>  hunspell.x86_64 0:1.2.8-16.el6         patch.x86_64 0:2.6-6.el6        python-enchant.x86_64 0:1.3.1-5.2.el6 python-magic.x86_64 0:5.04-21.el6
>  unzip.x86_64 0:6.0-2.el6_6
>
>Complete!
>```

# ソースコードの取得
```
# git clone https://github.com/axsh/tiny_web_example.git
```

実行結果例:
>```
># git clone https://github.com/axsh/tiny_web_example.git
>Initialized empty Git repository in /root/tiny_web_example/.git/
>remote: Counting objects: 307, done.
>remote: Compressing objects: 100% (22/22), done.
>Receiving objects: 100% (307/307), 294.71 KiB | 103 KiB/s, done.
>remote: Total 307 (delta 10), reused 0 (delta 0), pack-reused 285
>Resolving deltas: 100% (112/112), done.
>```


# 依存関係のインストール
```
# cd tiny_web_example
# yum-builddep ./rpmbuild/SPECS/tiny-web-example.spec
```

実行結果例:
>```
># yum-builddep ./rpmbuild/SPECS/tiny-web-example.spec
>Loaded plugins: fastestmirror
>Enabling epel-source repository
>Loading mirror speeds from cached hostfile
>epel-source/metalink                                                                                                        | 5.0 kB     00:00
> * base: mirror.fairway.ne.jp
> * epel: ftp.iij.ad.jp
> * epel-source: ftp.iij.ad.jp
> * extras: mirror.fairway.ne.jp
> * updates: mirror.fairway.ne.jp
>epel-source                                                                                                                 | 3.7 kB     00:00
>epel-source/primary_db                                                                                                      | 1.8 MB     00:00
>Getting requirements for ./rpmbuild/SPECS/tiny-web-example.spec
> --> Already installed : mysql-devel-5.1.73-3.el6_5.x86_64
>No uninstalled build requires
>```

# rpmbuildの実行
```
rpmbuild -bb ./rpmbuild/SPECS/tiny-web-example.spec
```

実行結果例:
>```
># rpmbuild -bb ./rpmbuild/SPECS/tiny-web-example.spec
>Executing(%prep): /bin/sh -e /var/tmp/rpm-tmp.w7wyVS
>+ umask 022
>+ cd /root/rpmbuild/BUILD
>+ '[' -d tiny-web-example-0.0.1 ']'
>+ git clone git://github.com/axsh/tiny_web_example.git tiny-web-example-0.0.1
>Initialized empty Git repository in /root/rpmbuild/BUILD/tiny-web-example-0.0.1/.git/
>remote: Counting objects: 307, done.
>remote: Compressing objects: 100% (22/22), done.
>remote: Total 307 (delta 10), reused 0 (delta 0), pack-reused 285
>Receiving objects: 100% (307/307), 294.71 KiB | 103 KiB/s, done.
>Resolving deltas: 100% (112/112), done.
>__(省略)__
>
>+ umask 022
>+ cd /root/rpmbuild/BUILD
>+ cd tiny-web-example-0.0.1
>+ RUBYDIR=/usr/bin/ruby
>+ rpmbuild/rules clean
>rm -rf /root/rpmbuild/BUILD/tiny-web-example-0.0.1/vendor/bundle
>rm -f /root/rpmbuild/BUILD/tiny-web-example-0.0.1/bundle-install-stamp
>rm -f build-stamp
>+ rm -rf /root/rpmbuild/BUILDROOT/tiny-web-example-0.0.1-1.daily.el6.x86_64
>+ exit 0
>```

