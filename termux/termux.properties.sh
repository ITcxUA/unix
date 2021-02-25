#!/bin/sh

NAME="termux.properties.sh"
title="termux.properties"
mkdir -p ~/.termux

cat <<EOF > $HOME/.termux/$title
## Черный стиль интерфейса
use-black-ui = true

##============ ≠≠≠ ============
## Установка комбинаций клавиш для управления сессиями

## Создать новую сессию при помощи ctrl + t (Ум. громкость + t)
shortcut.create-session = ctrl + t

## Переключиться на следующую при помощи ctrl + 2
shortcut.next-session = ctrl + 2

## Переключится на предыдущую сессию при помощи ctrl + 1
shortcut.previous-session = ctrl + 1

## Переименовать текущую сессию при помощи ctrl + n
shortcut.rename-session = ctrl + n

##============ ≠≠≠ ============
## Поведение символа гудка

# Вибрация (default).
bell-character=vibrate

# Звук.
bell-character=beep

# Игнорировать.
bell-character=ignore

##============ ≠≠≠ ============
## Поведение кнопки "назад"

# Послать Escape.
back-key=escape

# Убрать клавиатуру или выйти из приложения.
back-key=back
EOF

termux-reload-settings
