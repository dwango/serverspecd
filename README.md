# これはなに？

* 解決する問題
 * [Serverspec](http://http://serverspec.org/)はデフォルトでは単一のホストしかチェックできなかった件

* 解決した内容
 * 複数のホストとテストするattributeを定義すると、ホストの状態をチェック出来るServerspecのRakefileを作りました
 * hosts.ymlにhostsとroleの組み合わせを書くとテストしてくれます

* なお、UN*X用です。そしてsshでテストを実行します


# インストール

```sh
$ git clone git@github.com:dwango/serverspecd.git
$ bundle
```

## ディレクトリ構成

サンプルとしてmysqlのプロセスや設定をチェックしてくれる ``mysql_server`` 、ネットワーク周りを見てくれる ``network`` 、osのインストールされているパッケージなどをチェックしてくれる ``os`` などを同梱しています。参考にどうぞ。

```
.
|-- Gemfile
|-- Gemfile.lock
|-- README.md
|-- Rakefile
|-- attributes.yml.template
|-- hosts.yml.template
`-- spec
    |-- app
    |   `-- app_spec.rb
    |-- mysql_server
    |   `-- mysql_server_spec.rb
    |-- network
    |   `-- network_spec.rb
    |-- os
    |   `-- os_spec.rb
    |-- php
    |   `-- php_spec.rb
    |-- spec_helper.rb
    `-- zabbix-agent
        `-- zabbix-agent_spec.rb
```

## 使う

* attribute.yml.templeteをattribute.ymlに、hosts.yml.templeteをhosts.ymlにそれぞれリネーム
* hosts.ymlにホスト名とspecのディレクトリ名を書きます
* attributes.ymlにspecのディレクトリ名に設定するattributeを書きます


## 設定

### hosts.yml

* hosts.ymlにhostsとroleの組み合わせを書きます
* hosts.ymlの例

```yaml
nico:
  :roles:
    - os
maki:
  :roles:
    - os
    - network
```

* ノンパスで ``ssh nico`` , ``ssh maki`` できるようにしてください

### attributes.yml

* spec名のディレクトリのspecに対応する設定を書きます
* :で始まっている理由は、参考にしたコードに引っ張られました

```yaml
mysql_server:
    :listen_port: 3306
    :version: 5.5.37
    :user: mysql
    :innodb_buffer_pool_size: 24G
    :innodb_log_file_size: 600M
    :innodb_log_files_in_group: 3
php:
    :version: 5.5.12
    :max_execution_time: 0
    :memory_limit: 128M
    :post_max_size: 512M
    :upload_max_filesize: 2M
    :max_input_time: -1
    :timezone: Asia/Tokyo
    :libmcrypt_version: 2.5.8
network:
    :gw_addr: 192.168.0.254
    :gw_addr_device: bond0
```

### specファイルを作ってroleに追加する方法

hogeというroleを作ってみましょう。まずはspecファイルを作ります。

```sh
$ mkdir spec/hoge
$ touch spec/hoge/hoge_spec.rb
```

hosts.ymlのrolesに追加します。

```yaml
nico:
  :roles:
    - os
    - hoge # add 'hoge' role
maki:
  :roles:
    - os
    - network
```

### specファイルを作ろう

* attributes.ymlのspecに対応した値を読み出すためにproperties = property['spec']が必要です

```sh
$ cat spec/network/network_spec.rb
require 'spec_helper'
properties = property['network']

describe service('network') do
  it { should be_enabled }
  it { should be_running }
end
```


## 実行

* 実行時の一覧

```sh
$ rake -T
rake serverspec            # Run serverspec to all hosts
rake serverspec:hostname1  # Run serverspec to hostname1
rake serverspec:hostname2  # Run serverspec to hostname2
```

* 特定のホストに対してテスト

```sh
$ rake serverspec:hostname1
```

* デバッグ情報も表示

```sh
$ rake serverspec:hostname1 --trace SPEC_OPTS="-fd"
```


# その他

## TODO

* specファイルに propaties = propaties['spec']と書かないといけないのを何とかしたい
* rake serverspecして全てのサーバをチェックしたとき、一つ目のサーバのチェックが失敗すると、それ以降のサーバのチェックが走りません。何とかしたい

## 参考

* http://serverspec.org/ Serverspec
* https://github.com/serverspec/serverspec Serverspec(github.com)
* http://mizzy.org/blog/2013/05/12/1/ serverspec のテストをホスト間で共有する方法
* http://mizzy.org/blog/2013/05/12/2/ serverspec でホスト固有の属性値を扱う方法
* https://github.com/hayato1980/serverspec-example NTPのチェック部分をコピーしました

## see also

* http://qiita.com/norobust/items/478866c355e35947835c serverspec で複数ホストの指定を簡単にしてみた
