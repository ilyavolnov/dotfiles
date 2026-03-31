#!/bin/bash
# Скрипт быстрой установки dotfiles для Arch Linux
# Запускать от обычного пользователя!

set -e

echo "=== Dotfiles Installer for Arch Linux ==="
echo ""

# Обновление системы
echo "[1/5] Обновление системы..."
sudo pacman -Syu --noconfirm

# Установка базовых пакетов
echo "[2/5] Установка пакетов..."
sudo pacman -S --needed - < <(grep -v '^#' ~/dotfiles/packages.txt | grep -v '^$')

# Клонирование dotfiles если нет
if [ ! -d ~/dotfiles ]; then
    echo "[3/5] Клонирование dotfiles..."
    git clone https://github.com/ilyavolnov/dotfiles.git ~/dotfiles
else
    echo "[3/5] Dotfiles уже на месте..."
    cd ~/dotfiles && git pull
fi

# Применение симлинков
echo "[4/5] Применение конфигураций..."
cd ~/dotfiles
stow . --adopt

# Установка Spicetify
echo "[5/5] Настройка Spicetify..."
if command -v spicetify &> /dev/null; then
    spicetify backup apply
    spicetify config inject_css 1 replace_colors 1 overwrite_assets 1
    spicetify apply
fi

echo ""
echo "=== Готово! ==="
echo "Перезайдите в систему или перезапустите сессию"
echo "Для применения Hyprland: logout → выберите Hyprland в DM"
