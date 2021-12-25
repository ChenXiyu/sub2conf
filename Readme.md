# Sub2Conf
This is a tool to let you be able to convert a v2ray subscription into a v2ray config.

## Functionalities
* Convert subscription into json formated configuration with loadbalancing.
* Connectivity testing

# Usage
```Bash
docker run --rm -it 94xychen/sub2conf --subscription_url [subscription link] --output [path of configuration file] --speed_testing
```

The converted configuration will be placed to the filr path you specified to the "--output" option. And you can use the script and cron mechanism to refresh the configuration schedulely like what I've done:

```Bash
#!/bin/bash -e
#file: /root/refresh_subscriptions.sh
set -ue
set -o pipefail

function restart_v2ray {
  /bin/systemctl restart v2ray
}

function backup {
  cp "$1" "$1.back"
}

function roll_back {
  mv "$1.back" "$1"
  restart_v2ray
}

function assert_active {
  sleep 10
  [ "$(/bin/systemctl is-active v2ray)" != 'active' ] && roll_back "$v2ray_config"
}

function refresh_config {
  local v2ray_config=$1
  local sub_url=$2
  local v2ray_config_dir=`dirname $v2ray_config`

  /usr/bin/docker run --rm -it --network host -v "$v2ray_config_dir":"$v2ray_config_dir" 94xychen/sub2conf --subscription_url "$sub_url" --output "$v2ray_config" --speed_testing
}

v2ray_config=$1
sub_url=$2

trap 'assert_active' EXIT

backup "$v2ray_config"

refresh_config "$v2ray_config" "$sub_url"

restart_v2ray
```

And

```
#crontab
0 5 * * 1 /root/refresh_subscriptions.sh "/path/of/v2ray/config/file" "[your subscription url]" >>/var/log/refresh_subscriptions.log 2>&1

```

## TODO
- [x] Filter nodes base on speed testing.
