# Dotfiles

Мои конфигурационные файлы для Linux (CachyOS/Arch + Hyprland).

## 📁 Структура

### Shell
| Файл | Описание |
|------|----------|
| `.bashrc`, `.bash_profile` | Bash конфиги |
| `.zshrc`, `.zprofile` | Zsh конфиги |
| `.p10k.zsh` | Powerlevel10k тема |
| `fish/config.fish` | Fish shell |

### Hyprland (Wayland)
| Файл | Описание |
|------|----------|
| `hypr/hyprland.conf` | Основной конфиг Hyprland |
| `hypr/hypridle.conf` | Настройки сна/гибернации |
| `hypr/colors.conf` | Цветовая схема |
| `hypr/scripts/` | Скрипты (cliphist, refresh UI) |

### Waybar
| Файл | Описание |
|------|----------|
| `waybar/config` | Основной конфиг |
| `waybar/style.css` | Стили |
| `waybar/themes/` | Темы (default, experimental, line, zen) |
| `waybar/scripts/` | Скрипты обоев и цветов |
| `waybar/assets/` | Изображения |

### Приложения
| Директория | Описание |
|------------|----------|
| `rofi/` | Rofi launcher (темы, конфиги) |
| `wofi/` | Wofi launcher |
| `kitty/` | Терминал Kitty |
| `btop/` | Монитор системы |
| `fastfetch/` | Fastfetch конфиги |
| `swaync/` | Уведомления |
| `spicetify/` | Spotify темы |
| `nwg-look/` | GTK темы |

### Системные
| Файл | Описание |
|------|----------|
| `kde/*` | KDE конфиги (kdeglobals, kiorc) |
| `qt/qt5ct.conf` | QT5 настройки |
| `gtk/*` | GTK 3/4 настройки |
| `hyprcursor/manifest.json` | Курсор |
| `matugen/` | Генератор цветов |
| `mimeapps.list` | MIME приложения |
| `.Xresources` | X11 ресурсы |

### Инструменты
| Файл | Описание |
|------|----------|
| `.gitconfig` | Git настройки |
| `.viminfo` | Vim |
| `.yarnrc` | Yarn |

## 🚀 Установка

```bash
# Клонируйте репозиторий
git clone https://github.com/ilyavolnov/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Используйте GNU Stow для симлинков
stow .  # создаст симлинки всех файлов

# Или вручную выборочно:
ln -sf ~/.dotfiles/.bashrc ~/
ln -sf ~/.dotfiles/.zshrc ~/
ln -sf ~/.dotfiles/hypr/hyprland.conf ~/.config/hypr/
ln -sf ~/.dotfiles/waybar/config ~/.config/waybar/
```

## 📦 Зависимости

### Обязательные
- hyprland
- waybar
- rofi / wofi
- kitty

### Рекомендуемые
- cliphist
- matugen
- spicetify-cli
- fastfetch
- btop
- swaync

## 🎨 Темы

- **Иконки:** YAMIS (Yet Another Monochrome Icon Set)
- **Курсор:** Bibata / Hyprcursor
- **Стиль:** Минимализм с кастомными цветами

## ⚙️ Примечания

- Конфиги для CachyOS (Arch-based)
- Wayland (Hyprland)
- Некоторые скрипты требуют кастомизации под вашу систему

## 📄 Лицензия

MIT
