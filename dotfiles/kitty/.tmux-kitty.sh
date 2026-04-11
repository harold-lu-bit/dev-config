#!/bin/bash

# 检查是否存在名为 kitty 的主会话
if tmux has-session -t kitty 2>/dev/null; then
    SESSION_NAME="k-$RANDOM"
    
    # 1. 创建共享窗口的临时会话 (后台创建)
    tmux new-session -d -t kitty -s "$SESSION_NAME"
    
    # 2. 在指定路径新建一个窗口
    tmux new-window -t "$SESSION_NAME" -c "$PWD"
    
    # 3. 核心修复：设置信号陷阱
    # 无论你是输入 exit 退出，还是直接用鼠标/快捷键强制关掉 Kitty 窗口，
    # bash 在结束前都会执行这条命令，干净地把临时会话清理掉。
    trap "tmux kill-session -t $SESSION_NAME 2>/dev/null" EXIT HUP INT TERM
    
    # 4. 接入会话（注意：这里去掉了 exec，让外层 bash 保持存活以监听退出信号）
    tmux attach-session -t "$SESSION_NAME"
else
    # 主会话依然直接接管进程
    exec tmux new-session -s kitty -c "$PWD"
fi
