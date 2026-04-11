# Clean Config

这套目录用于在新机器上恢复你的 VS Code / Cursor 用户级配置。

## 恢复顺序

1. 先应用 `shared/default-settings.json`
   - 只放必须在默认用户层生效，或更适合放在默认层的设置。

2. 再应用 `shared/settings.json`
   - 这是 VS Code / Cursor 共用的主设置。

3. 在应用对应的配置
   - VS Code: `vscode/settings.json`
   - Cursor: `cursor/settings.json`

4. 再应用 `shared/keybindings.json`
   - 这是 VS Code / Cursor 共用的快捷键增量。

5. 再应用对应编辑器的快捷键
   - VS Code: `vscode/keybindings.json`
   - Cursor: `cursor/keybindings.json`

6. 先安装 `shared/extensions.txt`
   - 这是 VS Code / Cursor 共用的主扩展集。
   - 也可以改用 [`scripts/install-extensions.sh`](scripts/install-extensions.sh) 批量安装，详见下文「批量安装扩展」。

7. 最后安装对应编辑器的扩展增量
   - VS Code: `vscode/extensions.txt`
   - Cursor: `cursor/extensions.txt`
   - 同样可以用 `install-extensions.sh` 指向对应清单文件。

## 批量安装扩展

仓库里提供了脚本 [`scripts/install-extensions.sh`](scripts/install-extensions.sh)，用于按清单批量安装扩展。脚本会忽略空行和以 `#` 开头的注释行，因此扩展清单可以带分组注释。

### 前置条件

- 已安装对应编辑器的命令行工具，并且能在终端里直接执行 `code`（VS Code）或 `cursor`（Cursor）。
- 使用 bash 执行脚本。

### 用法

```bash
# 在 clean-config 目录下执行（路径可按你的克隆位置调整）
cd clean-config

# 共用扩展 + VS Code 增量（未指定 profile 时会提示是否安装到默认 profile）
./scripts/install-extensions.sh shared/extensions.txt vscode
./scripts/install-extensions.sh vscode/extensions.txt vscode

# 共用扩展 + Cursor 增量
./scripts/install-extensions.sh shared/extensions.txt cursor
./scripts/install-extensions.sh cursor/extensions.txt cursor
```

#### 指定 profile（可选第三个参数）

```bash
# VS Code
./scripts/install-extensions.sh shared/extensions.txt vscode VIM
./scripts/install-extensions.sh vscode/extensions.txt vscode VIM

# Cursor（把 MyProfile 换成你实际的 profile 名称）
./scripts/install-extensions.sh shared/extensions.txt cursor MyProfile
./scripts/install-extensions.sh cursor/extensions.txt cursor MyProfile
```

#### 行为说明

- VS Code 分支使用 `code --install-extension … --force`，便于覆盖到期望版本。
- Cursor 分支使用 `cursor --install-extension …`（不带 `--force`，与当前 Cursor CLI 行为一致）。
- 若部分扩展安装失败，脚本会以退出码 `2` 结束，并在最后汇总成功、跳过与失败数量。
