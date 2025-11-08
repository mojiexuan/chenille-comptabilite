# Logo 文件说明

## 📁 请将您的 Logo 文件放在这里

### 启动页 Logo

文件名（二选一）：

- `logo.png` （推荐）
- `logo.jpg` （也支持）

尺寸建议：512×512px 或 1024×1024px

---

### 应用图标

文件名（二选一）：

- `icon.png` （推荐）
- `icon.jpg` （也支持）

尺寸建议：1024×1024px

生成图标命令：

```bash
flutter pub run flutter_launcher_icons
```

---

## ✅ JPG 和 PNG 都支持

- **PNG**: 支持透明背景，推荐用于启动页 Logo
- **JPG**: 文件更小，适合不需要透明背景的场景

代码会自动优先加载 PNG，如果不存在则加载 JPG
