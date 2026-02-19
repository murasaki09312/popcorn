# popcorn

Rails 8 + Hotwire + Tailwind + Stimulus(TypeScript) で構成した `popcorn` の開発環境です。  
Redisは使用しません。

## 技術スタック

- Ruby `3.2.2` (`.ruby-version`)
- Rails `8.1.2`
- SQLite3
- Hotwire (`turbo-rails`, `stimulus-rails`)
- Tailwind CSS (`cssbundling-rails` + `@tailwindcss/cli`)
- Stimulus Controller (TypeScript)

## 前提

- Ruby `3.2.2`
- Bundler `2.4.x` 以上
- Node.js `25.2.1` (`.node-version`)
- npm `11.x` 以上

## 初回セットアップ

```bash
bundle install
npm install
bin/rails db:prepare
```

必要に応じて `.env` などで以下を設定してください（未設定時は `#` を使用）:

- `SITE_LINE_URL`
- `SITE_INSTAGRAM_URL`
- `SITE_YOUTUBE_URL`

## 起動方法

### 1. 推奨: `bin/dev`（Rails + JS/CSS watcher）

```bash
bin/dev
```

起動後: `http://127.0.0.1:3000`

### 2. `rails s`（Rails単体）

```bash
npm run build
npm run build:css
bin/rails s
```

起動後: `http://127.0.0.1:3000`

## 動作確認ポイント

- `/` でトップページが表示される
- Tailwindクラスが反映される
- 「Toggle Text」ボタンで文言が切り替わる（Stimulus TypeScript）

TypeScript controller:

- `app/javascript/controllers/toggle_controller.ts`

## よくあるトラブル

### 1. `Address already in use - bind(2) for 127.0.0.1 port 3000`

3000番ポートを他プロセスが使用しています。

```bash
lsof -i :3000
kill <PID>
```

または別ポートで起動:

```bash
PORT=3001 bin/dev
# or
bin/rails s -p 3001
```

### 2. `bundle install` が失敗する

- ネットワーク接続を確認
- Bundlerを更新して再実行

```bash
gem install bundler
bundle install
```

### 3. `npm install` / `npm run build` が失敗する

- Node/npmのバージョン確認
- 依存再インストール

```bash
node -v
npm -v
rm -rf node_modules package-lock.json
npm install
```

### 4. `bin/dev` で watcher がすぐ終了する

`Procfile.dev` が `npm run build -- --watch=forever` と  
`npm run build:css -- --watch=always` になっているか確認してください。
