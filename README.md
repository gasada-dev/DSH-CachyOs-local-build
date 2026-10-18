# DSH-CachyOs-local-build

Неофициальная локальная сборка **DeepSeek Harness Desktop 0.2.1-rc.2** для **CachyOS / Arch Linux x86_64 (glibc)**.

Собрана из [официальных исходников DeepSeek](https://github.com/deepseek-ai/deepseek-harness), тег `dsh-v0.2.1-rc.2`, коммит `687f282e8625c6b8d11ff58211a90524be2e4317`. Локальная поправка разрешает Linux x64 в запускателе Desktop и выбирает правильную платформу runtime. Это запуск готовых артефактов через upstream `start:desktop`, а не официальный Linux-релиз или пакет pacman. Автообновление и обновление через paru не настроены.

## Скачать и установить

Откройте [Releases](https://github.com/gasada-dev/DSH-CachyOs-local-build/releases) и скачайте архив `DSH-CachyOs-local-build-0.2.1-rc.2-linux-x64.tar.zst`, `SHA256SUMS`, `install.sh` и `launch.sh` в одну папку.

Зависимости CachyOS / Arch:

```sh
sudo pacman -S --needed gtk3 nss alsa-lib libxss libxtst libnotify libsecret xdg-utils at-spi2-core util-linux-libs zstd
```

В папке со скачанными файлами:

```sh
sha256sum -c SHA256SUMS
sh install.sh ./DSH-CachyOs-local-build-0.2.1-rc.2-linux-x64.tar.zst
```

Установка без sudo: приложение появится в меню как **DeepSeek Harness (CachyOS local build)**. Команда запуска:

```sh
~/.local/bin/dsh-cachyos
```

Архив включает исходники, собранные артефакты, зависимости, Electron и подготовленный Linux runtime (Node/Python/pnpm). Устанавливать npm-зависимости или компилировать проект повторно не требуется. Первый запуск может занимать некоторое время: upstream проверяет runtime. Понадобится около 4 ГБ свободного места для распаковки, дополнительно к архиву.

## Данные и удаление

- Приложение: `~/.local/share/DSH-CachyOs-local-build/deepseek-harness`
- Сессии и настройки Harness: `~/.local/share/deepseek-harness-data`
- Настройки Electron: `~/.config/deepseek-harness-desktop`
- Журнал: `~/.local/state/deepseek-harness.log`

Для удаления закройте приложение и удалите папку приложения, `~/.local/bin/dsh-cachyos` и `~/.local/share/applications/dsh-cachyos.desktop`. Пользовательские данные хранятся отдельно. Перед заменой сборки сохраните их резервную копию; установщик отказывается перезаписывать существующую папку приложения.

Архив не содержит пользовательских ключей, аккаунтов, сессий и конфигурации Electron. API-ключ вводится после запуска. Сборка использует upstream development launcher с локальными отладочными портами 9222/9229/9230.

## Исходники и проверка

Linux-поправка: [`linux-x64.patch`](linux-x64.patch). Исходники и `check-linux-launch.mjs` также находятся внутри архива.

```sh
git clone --depth 1 --branch dsh-v0.2.1-rc.2 https://github.com/deepseek-ai/deepseek-harness.git
git -C deepseek-harness apply /absolute/path/to/linux-x64.patch
cd deepseek-harness
npx --yes pnpm@11.28.5 install --frozen-lockfile
node_modules/.bin/pnpm run build
node_modules/.bin/pnpm --filter @deepseek-ai/dsh-desktop exec install-electron
node_modules/.bin/pnpm --filter @deepseek-ai/dsh-desktop run prepare:primary-runtime
node_modules/.bin/pnpm run start:desktop
```

Для сборки требуется Node.js `^22.19.0 || >=24`. Проверено на CachyOS x86_64/Wayland: все 9 проверок `pnpm run build`, проверки Node/Python/Office runtime, открытие окна API-ключа и загрузка основного интерфейса. Работа модели без API-ключа не проверялась. Поддержка других дистрибутивов и функций Desktop не гарантируется.

## Лицензии

DeepSeek Harness: MIT, Copyright (c) 2026 DeepSeek. Оригинальные `LICENSE`, `THIRD_PARTY_NOTICES.md` и лицензии зависимостей сохранены в архиве. Этот репозиторий не является официальным релизом DeepSeek.
