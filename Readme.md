# Sub2Conf
This is a tool to let you be able to convert a v2ray subscription into a v2ray config.

## Functionalities
* Convert subscription into json formated configuration with loadbalancing.
* Connectivity testing

# Usage
```Bash
docker run --rm -it 94xychen/sub2conf [subscription link]
```

The output will be the json formated configuration, You can either just copy this config into your config file or you can use the script and cron mechanism to refresh the configuration schedulely like what I've done:

```Bash
#!/bin/bash
set -ue
set -o pipefail

function restart_v2ray {
  /bin/systemctl restart v2ray
}

function roll_back {
  mv ${v2ray_config_path}.back ${v2ray_config_path}
  restart_v2ray
}

function assert_active {
  sleep 10
  if [ "$(/bin/systemctl is-active v2ray)" != 'active' ]
  then
    roll_back
    # TODO notify
  fi
}

trap 'assert_active' ERR

v2ray_config_path='/usr/local/etc/v2ray/config.json'

# Back the origin config
cp ${v2ray_config_path} ${v2ray_config_path}.back

/usr/bin/docker run --rm -it --network host 94xychen/sub2conf:arm-v7-latest '[your subscription link]' > ${v2ray_config_path}

restart_v2ray

assert_active
```

## TODO
- [x] Filter nodes base on speed testing.
