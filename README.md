# MonoSense 公式サイト

個人でアプリやゲームを作って発信する「MonoSense」のサイト。作っているアプリの紹介、note の連載（Claude Code への指示を検証する開発ログ）、X（@M0noSense）への入口をまとめている。

- 公開先（予定）：https://m0nosense.github.io/ （GitHub の組織 `m0nosense` の GitHub Pages）
- HTML と CSS だけの静的サイト。ビルドは不要で、外部のスクリプトやフォントも読み込まない
- 配色は「温かいオレンジ」。旧 MonoSense のキャラクター「モノくん」（`images/monokun.png`）を引き継いでいる。ダークモードにも対応

## ファイル

| ファイル | 中身 |
| --- | --- |
| `index.html` | トップページ（アプリ・連載・X と note の入口） |
| `style.css` | 見た目のすべて。色は先頭の `:root` にまとめてある |
| `404.html` | ページが見つからないときの画面 |
| `og.png` | X などで共有したときに出る画像（1200×630） |
| `favicon.png` / `apple-touch-icon.png` | タブとホーム画面のアイコン |
| `images/apps/` | アプリのアイコン（256×256 の PNG） |
| `images/note/` | 連載 #0 の見出し画像 |
| `tools/make_images.swift` | `og.png` とアイコンを作り直すスクリプト |
| `.nojekyll` | GitHub Pages にファイルをそのまま公開させるための空ファイル |

## 手元で見る

```bash
python3 -m http.server 8765
```

ブラウザで http://localhost:8765/ を開く。

## 更新のしかた

- **note の記事を足す**：`index.html` の `<ul class="articles">` の中の `<li>` を 1 つ複製して、URL・アプリ名・番号・タイトル・日付を書き換える。新しい記事ほど上に置く。値段は書かず、`price-free`（無料）か `price-paid`（有料）の札だけにする
- **アプリを足す**：`index.html` の `<article class="app-card">` を 1 つ複製して書き換える。アイコンは `images/apps/` に 256×256 の PNG で置く。状態の札は `status-live`（公開中）・`status-soon`（公開準備中）・`status-dev`（開発中）
- **アプリがストアに出たら**：そのアプリの札を `status-live` の「公開中」に変え、App Store などへのリンクを `<p class="links">` に足す
- **共有画像やアイコンを作り直す**：このフォルダで `swift tools/make_images.swift`（Mac のみ）

## 載せないもの

- メールアドレス、広告・課金・アプリの各種 ID、トークン、ローカルのパス
- 公開していないアプリ・リポジトリの情報

## 公開の手順（GitHub Pages）

1. **組織を作る（あなたが GitHub の画面で）**：https://github.com/account/organizations/new?plan=free を開き、Organization name に `m0nosense`、「My personal account」を選んで作る（連絡先のメールアドレスは自分で入力する）
2. **リポジトリを作る**：組織 `m0nosense` に、公開（Public）のリポジトリ `m0nosense.github.io` を空のまま作る

   ```bash
   gh repo create m0nosense/m0nosense.github.io --public --description "MonoSense の公式サイト" --homepage https://m0nosense.github.io/
   ```

3. **このフォルダを push する**

   ```bash
   git init -b main
   git add -A
   git commit -m "MonoSense の公式サイトを作成"
   git remote add origin https://github.com/m0nosense/m0nosense.github.io.git
   git push -u origin main
   ```

4. **GitHub Pages を確かめる**：リポジトリの Settings → Pages で、Source が「Deploy from a branch」、Branch が `main` の `/ (root)` になっていることを確かめる（`<組織名>.github.io` という名前のリポジトリは、ふつうは自動でこの設定になる）
5. **表示を確かめる**：数分後に https://m0nosense.github.io/ を開く。X の投稿画面に URL を貼って、共有画像（`og.png`）が出ることも確かめる
6. **プロフィールに載せる**：X（@M0noSense）と note のプロフィールの「ウェブサイト」に https://m0nosense.github.io/ を入れる

以後の更新は、ファイルを直して commit → `git push` するだけで反映される（数分かかる）。
