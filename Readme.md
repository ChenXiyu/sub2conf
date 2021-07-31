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
#!/bin/bash
#file: /root/refresh_subscriptions.sh
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

v2ray_config_path='/etc/v2ray/config.json'

# Back the origin config up
cp ${v2ray_config_path} ${v2ray_config_path}.back

/usr/bin/docker run --rm -it --network host -v /etc/v2ray/:/etc/v2ray 94xychen/sub2conf:latest --subscription_url "$1" --output ${v2ray_config_path} --speed_testing

restart_v2ray

assert_active
```

And

```
#crontab
0 5 1 * * /root/refresh_subscriptions.sh [your subscription url] >> /var/log/refresh_subscriptions.log
```

## TODO
- [x] Filter nodes base on speed testing.
