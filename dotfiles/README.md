# Dotfiles

本目录收录终端与编辑器相关的个人配置文件。

## Vim

`.vimrc` 使用 [Pathogen](https://github.com/tpope/vim-pathogen) 管理插件（`execute pathogen#infect()`）。安装与用法见上游仓库说明；插件一般放在 `~/.vim/bundle/`。

## tmux

`.tmux.conf` 通过 [TPM（Tmux Plugin Manager）](https://github.com/tmux-plugins/tpm) 加载插件。按 TPM 文档将 `tpm` 装到 `~/.tmux/plugins/tpm/`，在 tmux 内用前缀键 + `I` 安装插件列表中的条目。

## Kitty

`kitty/` 下的配置需放到本机 Kitty 的配置目录：**`~/.config/kitty/`**。

可将本仓库中的 `kitty` 目录整体复制或符号链接到该路径，例如：

```bash
ln -sf /path/to/this/repo/dotfiles/kitty ~/.config/kitty
```

具体文件名（如 `kitty.conf`、`current-theme.conf`）需与 Kitty 默认查找规则一致；若你改了路径，请在 `kitty.conf` 里用 `include` 指向实际主题文件。
