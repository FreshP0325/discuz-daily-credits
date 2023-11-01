#!/bin/bash

# 1. 安装 Python 和 pip
sudo apt update
sudo apt install wget cron python3 python3-requests python3-pyaes -y

# 2. 下载脚本和依赖
wget https://github.com/FreshP0325/discuz-daily-credits/raw/main/hostloc_auto_get_points.py

# 3. 检查配置文件是否存在
config_file="hostloc_config.txt"

if [ -f "$config_file" ]; then
    # 配置文件存在，读取用户名和密码
    username=$(sed -n '1p' "$config_file")
    password=$(sed -n '2p' "$config_file")
else
    # 配置文件不存在，提示用户输入用户名和密码
    read -p "请输入 MJJ 用户名：" username
    read -p "请输入 MJJ 密码：" -s password

    # 保存用户名和密码到配置文件
    echo "$username" > "$config_file"
    echo "$password" >> "$config_file"
fi

# 4. 修改脚本中的用户名和密码
sed -i "92s|\"username\": .*|\"username\": \"$username\",|" hostloc_auto_get_points.py
sed -i "93s|\"password\": .*|\"password\": \"$password\",|" hostloc_auto_get_points.py

# 5. 创建 crontab 任务
crontab -l | { cat; echo "0 8 * * * cd $(pwd) && python3 hostloc_auto_get_points.py"; } | crontab -

# 6. 执行一次脚本
python3 hostloc_auto_get_points.py

echo "成了"
