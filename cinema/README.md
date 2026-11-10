# Cinema – Movie Explorer

Two versions of the same app are included:

| Folder | What it is |
|---|---|
| `lib/`, `pubspec.yaml` | **Flutter (Dart) source** – the main project for the exam |
| `html_version/index.html` | **Single-file HTML/CSS/JS version** – ready for GitHub Pages |
| `screenshots/` | Screenshots taken from the HTML version (desktop / tablet / mobile) |

## Run the Flutter version
```
flutter create --platforms web .
flutter pub get
flutter run -d chrome
```
Build for the web: `flutter build web --base-href "/<repo-name>/"`

## Publish the HTML version on GitHub Pages
1. Upload `html_version/index.html` to the **root** of a GitHub repository (file name must be exactly `index.html`).
2. Settings → Pages → Deploy from a branch → `main` / `(root)` → Save.
3. Open `https://<username>.github.io/<repo-name>/` after ~1–2 minutes.
