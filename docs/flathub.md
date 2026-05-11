# Flathub publishing workflow

## Файли в цьому репо

| Файл | Призначення |
|---|---|
| `flatpak/io.github.o_murphy.ebalistyka.flathub.yml` | Шаблон маніфесту для Flathub (from-source build). Містить плейсхолдери `__VERSION__`, `__COMMIT_SHA__`, `__SHA256_FLUTTER_SDK__`. |
| `flatpak/io.github.o_murphy.ebalistyka.yml` | Локальний маніфест для тестування з готовим бандлом (використовує `flatpak/bundle/`). |
| `flatpak/io.github.o_murphy.ebalistyka.metainfo.xml` | AppStream-метадані. Управляються тут, в upstream-репо. **Не копіювати у Flathub-репо вручну.** |
| `flatpak/io.github.o_murphy.ebalistyka.desktop` | Desktop-файл. Аналогічно — тільки upstream. |
| `flatpak/ebalistyka-wrapper.sh` | Враппер, що виставляє `LD_LIBRARY_PATH` перед запуском бінарника. |
| `scripts/update-flathub.sh` | Автоматизує підготовку Flathub-репо до нового релізу. |
| `scripts/generate-pub-sources.sh` | Генерує `flatpak/pub-sources.json` зі списком усіх Dart-пакетів для офлайн-збірки. |
| `scripts/package-flatpak.sh` | Пакує готовий Flutter-бандл у `.flatpak` для GitHub Releases (не для Flathub). |

---

## Перед першим релізом — одноразово

### 1. Клонувати Flathub-репо

```bash
git clone https://github.com/flathub/io.github.o_murphy.ebalistyka ~/flathub-ebalistyka
```

### 2. Переконатись, що встановлені залежності

```bash
sudo apt install flatpak flatpak-builder git curl python3 python3-pip
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

---

## Реліз нової версії

### 1. Оновити версію та метадані

Переконатись, що в `pubspec.yaml` стоїть правильна версія і в
`flatpak/io.github.o_murphy.ebalistyka.metainfo.xml` є відповідний запис у `<releases>`.
`update-flathub.sh` додасть його автоматично, але краще перевірити заздалегідь.

### 2. Створити тег і запустити скрипт

```bash
git tag v0.1.13
git push origin v0.1.13

bash scripts/update-flathub.sh v0.1.13 ~/flathub-ebalistyka
```

Скрипт зробить:
- Резолвить commit SHA для тегу (локально або через GitHub API)
- Завантажить Flutter SDK і обчислить його SHA256
- Запустить `generate-pub-sources.sh` → запише `pub-sources.json`
- Підставить всі плейсхолдери в маніфест і запише готовий `io.github.o_murphy.ebalistyka.yml`
- Додасть запис `<release>` в `metainfo.xml` в upstream-репо (не у Flathub-репо)

### 3. Закомітити у Flathub-репо

Після завершення скрипту у Flathub-репо мають бути лише два файли:

```
io.github.o_murphy.ebalistyka.yml   ← згенерований маніфест
pub-sources.json                    ← згенерований список Dart-пакетів
```

```bash
cd ~/flathub-ebalistyka
git add io.github.o_murphy.ebalistyka.yml pub-sources.json
git commit -m "Update to v0.1.13"
git push
```

### 4. Відкрити PR у Flathub

Відкрити pull request з гілки у репо `flathub/io.github.o_murphy.ebalistyka`.

---

## Локальне тестування з готовим бандлом

Для перевірки маніфесту без відправки у Flathub:

```bash
# Зібрати Linux-бандл
flutter build linux --release

# Запакувати у .flatpak
bash scripts/package-flatpak.sh \
  build/linux/x64/release/bundle \
  x86_64
```

Артефакт з'явиться у `artifacts/flatpak/ebalistyka_linux_x86_64.flatpak`.

---

## Оновлення Flutter SDK у маніфесті

Якщо версія Flutter змінилась, оновити `FLUTTER_VERSION` у `scripts/update-flathub.sh`
і перевірити, що URL архіву актуальний:

```
https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_<version>-stable.tar.xz
```

SHA256 обчислюється автоматично під час виконання `update-flathub.sh`.

---

## Оновлення pub-пакетів вручну

Якщо `pubspec.lock` змінився і треба перегенерувати `pub-sources.json` окремо:

```bash
bash scripts/generate-pub-sources.sh
# або з явним шляхом виводу:
bash scripts/generate-pub-sources.sh flatpak/
```

Потрібен доступ до мережі та `python3` з `pip`.
