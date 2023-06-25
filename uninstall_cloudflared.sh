#!/bin/bash
# 删除 Cloudflared
function uninstall_cloudflared() {
    echo "正在卸载 Cloudflared..."
    
    # 停止服务
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo systemctl stop cloudflared
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        sudo launchctl unload /Library/LaunchDaemons/com.cloudflare.cloudflared.plist
    fi
    
    # 删除二进制文件
    sudo rm -f /usr/local/bin/cloudflared
    
    # 删除配置文件
    sudo rm -f /usr/local/etc/cloudflared/config.yml
    
    # 删除 LaunchDaemon 文件（仅 macOS）
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sudo rm -f /Library/LaunchDaemons/com.cloudflare.cloudflared.plist
    fi
    
    echo "Cloudflared 已成功卸载."
}

# 检查是否干净删除
function check_uninstall() {
    echo "正在检查 Cloudflared 是否已完全删除..."
    
    # 检查二进制文件
    if [[ -f "/usr/local/bin/cloudflared" ]]; then
        echo "Cloudflared 二进制文件未被删除."
    else
        echo "Cloudflared 二进制文件已被删除."
    fi
    
    # 检查配置文件
    if [[ -f "/usr/local/etc/cloudflared/config.yml" ]]; then
        echo "Cloudflared 配置文件未被删除."
    else
        echo "Cloudflared 配置文件已被删除."
    fi
    
    # 检查 LaunchDaemon 文件（仅 macOS）
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if [[ -f "/Library/LaunchDaemons/com.cloudflare.cloudflared.plist" ]]; then
            echo "Cloudflared LaunchDaemon 文件未被删除."
        else
            echo "Cloudflared LaunchDaemon 文件已被删除."
        fi
    fi
    
    # 检查进程
    if [[ -n $(ps aux | grep -i "cloudflared" | grep -v "grep") ]]; then
        echo "Cloudflared 进程仍在运行."
    else
        echo "Cloudflared 进程已停止."
    fi
}

# 主函数
function main() {
    uninstall_cloudflared
    check_uninstall
}

# 执行主函数
main
