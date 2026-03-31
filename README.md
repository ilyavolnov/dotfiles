# Dotfiles

Мои конфигурационные файлы для Linux (CachyOS/Arch).

## Состав

- **Zsh** + Powerlevel10k
- **Git**
- **Vim**
- **Xresources**

## Установка

```bash
# Клонируйте репозиторий
git clone https://github.com/<username>/dotfiles.git ~/.dotfiles

# Создайте симлинки
ln -sf ~/.dotfiles/.bashrc ~/
ln -sf ~/.dotfiles/.bash_profile ~/
ln -sf ~/.dotfiles/.zshrc ~/
ln -sf ~/.dotfiles/.zprofile ~/
ln -sf ~/.dotfiles/.p10k.zsh ~/
ln -sf ~/.dotfiles/.gitconfig ~/
ln -sf ~/.dotfiles/.Xresources ~/
ln -sf ~/.dotfiles/.viminfo ~/
ln -sf ~/.dotfiles/.wget-hsts ~/
ln -sf ~/.dotfiles/.yarnrc ~/

# Примените Xresources
xrdb ~/.Xresources
```

## Лицензия

MIT
