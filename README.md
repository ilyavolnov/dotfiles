# Dotfiles

Мои конфигурационные файлы для Linux (CachyOS/Arch + Hyprland).

## Состав

### Shell
- **Zsh** + Powerlevel10k
- **Bash**

### Hyprland (Wayland)
- `hypr/hyprland.conf` - основной конфиг Hyprland
- `hypr/hypridle.conf` - настройки гибернации/сна
- `hypr/colors.conf` - цветовая схема
- `hypr/scripts/` - скрипты для cliphist, refresh UI

### Waybar
- `waybar/config` - основной конфиг
- `waybar/style.css` - стили
- `waybar/themes/` - темы (default, experimental, line, zen)
- `waybar/scripts/` - скрипты для обоев и цветов
- `waybar/assets/` - изображения

### GTK
- `gtk/settings-gtk3.ini` - GTK 3
- `gtk/settings-gtk4.ini` - GTK 4

### Другое
- `.gitconfig` - настройки Git
- `.Xresources` - X11 ресурсы
- `.viminfo` - Vim настройки
- `.yarnrc` - Yarn настройки
- `hyprcursor/manifest.json` - курсор Hyprcursor

## Установка

```bash
# Клонируйте репозиторий
git clone https://github.com/ilyavolnov/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Установите симлинки
stow .  # или вручную:
# ln -sf ~/.dotfiles/.bashrc ~/
# ln -sf ~/.dotfiles/.zshrc ~/
# ln -sf ~/.dotfiles/hypr/hyprland.conf ~/.config/hypr/
# ln -sf ~/.dotfiles/waybar/config ~/.config/waybar/
```

## Зависимости

- hyprland
- waybar
- wofi / rofi
- cliphist
- matugen (опционально)

## Лицензия

MIT
