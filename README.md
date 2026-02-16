# Asteroids

基于 [LÖVE](https://love2d.org/) (Love2D) 的经典小行星风格射击游戏，使用 Lua 编写。

## 运行要求

- [LÖVE](https://love2d.org/) 11.x 或更高版本

## 如何运行

1. 安装 LÖVE：从 [love2d.org](https://love2d.org/) 下载并安装。
2. 在项目根目录执行：

   **Windows（资源管理器中）：**  
   将整个项目文件夹拖到 `love.exe` 上。

   **或使用命令行：**
   ```bash
   love "f:\chrome_download\asteroids game"
   ```
   若已将 `love` 加入 PATH，也可在项目目录下执行：
   ```bash
   love .
   ```

## 操作说明

| 按键 | 作用 |
|------|------|
| **W** | 加速（推进） |
| **A / ←** | 左转 |
| **D / →** | 右转 |
| **空格** | 发射激光 |
| **鼠标左键** | 发射激光 |
| **ESC** | 暂停 / 取消暂停 |

## 游戏规则

- 驾驶飞船躲避并击碎小行星，被撞到会爆炸并损失一条命。
- 共 3 条命，全部耗尽后游戏结束。
- 用激光击中小行星可将其摧毁。

## 项目结构

```
asteroids game/
├── main.lua          # 入口与主循环
├── conf.lua          # LÖVE 窗口与配置
├── globals.lua       # 全局变量与工具函数
├── objects/
│   ├── player.lua    # 玩家飞船（移动、射击、生命）
│   ├── asteroids.lua # 小行星
│   └── Lazer.lua     # 激光
├── states/
│   └── game.lua      # 游戏状态（运行/暂停/结束）
├── components/
│   └── text.lua      # 文本显示组件
└── README.md
```

## 配置

- 窗口分辨率在 `conf.lua` 中设置（默认 1980×1080）。
- 调试模式等可通过 `globals.lua` 中的 `SHOW_DEBUGGING` 控制。
