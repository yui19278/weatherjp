# 天気検索くん(仮)

https://qiita.com/enzen/items/14271ec8fdf01107d1ce
を参考にして設計 → 開発を行う

# 現在公開中！

https://tenki.yui19278.com

## アプリ作成動機

メモ帳アプリの写経を終えて　次は外部 API を使用した簡易アプリの作成  
最低限の軽い天気表示アプリを作りたい　ブラウザの待ち受けにしていつも天気が確認できるように  
検索画面を実装するが，基本的な使い方としては検索結果(居住区)をずっと表示しておくだけのものにする予定

次はブログを作りたい(どう外部 API と絡めようか..)

## 要件定義

以下は chatgpt と壁打ちしながら作成した要件定義である．　これを基に実装を行う．

### 機能

- 天気検索機能
  - 地域名を入力し天気を検索する
  - サジェスト候補に存在する地名が入力されている場合検索ボタンを有効化
- 天気予報表示機能
  - 検索地域の今日～ 2 日後の予報を表示する
- 検索履歴保存 / 表示機能
  - 検索地域を Cookie に紐づけ DB に保存し，検索時に候補として表示する

### 画面仕様

- 検索画面
  - 地域入力欄を置く
  - 地域入力欄に入力された文字に応じ，候補市区町村をリアルタイムサジェスト
  - 入力内容がサジェストと一致 => 検索ボタンが押せるように
- 検索地域画面
  - 検索した地域の天気予報を置く

### データ仕様

- 表示データ
  - 日付
  - 天気
  - 最高気温
  - 最低気温
  - 湿度
- 使用 API
  - OpenWeatherAPI を使用
- 検索履歴
  - SQLite に保存
  - Cookie でユーザ識別を行う
  - 5 件保存する
  - 重複は加味しない

### エラーハンドリング

- API 通信失敗時
- 存在しない地名

### サイトマップ

![sitemap](https://github.com/user-attachments/assets/1c6ad46a-fb11-4646-9b45-4926f167af72)

### ワイヤーフレーム

![wireflame](https://github.com/user-attachments/assets/4d5d48b4-c0d8-4d6a-977c-61921809a1ec)

### エンドポイント

/, GET, 検索ページを表示  
/weathers, GET, 検索を行い結果を表示

### gem

- faraday
  - http クライアント
- dotenv-rails
  - 環境変数
- pry-rails
  - デバッグ

## 開発

### 所感

- MVC 開発を心掛けた contoller -> view 分離(今ココ) -> model
- 開発をはじめてから rails の記法を学び，後から service 層を作って分割した　次は設計段階でディレクトリ構成まで考えたい
- API リクエストのエラーハンドリング想定が甘かった リク失敗は考慮，リク成功 → データ形式ミス は考えていなかった
- 数日後予報が無料 API だとめんどくさそうなので当日の天気だけを検索する実装として妥協した　事前の API 情報収集不足である
- RESTful な Web アプリを作るうえで，/weather は show より index の方が適切 途中で show→index に切り替えた
- API リクエストでハマった 環境変数名前違い, api キー間違え ←!?, 引数不一致で受け取れない, パースできない, faraday-retry 追加(v2 から仕様が変わっていた), ビューで呼び出すキーが違った
- 同じブランチで controller と view を開発してしまった 次は気を付ける
- 曜日表示が gem でできるとは 便利だ

二日目

- DB 設計も設計の段階でできるな
- DB を作るために cokkie の仕様について調べる　二種類あるらしい　今回は永続 cokkie を使う
  動作イメージ

1. ユーザが remember me にチェックを入れて検索する
2. 記憶トークンを生成する
3. ブラウザ cokkies に記憶トークンと地域名を保存（user_token, location)
4. トークンをハッシュ化して DB へ保存
5. ユーザが再びアクセスした際，アプリが cookies に保存されたトークンを受け取る
6. DB にあるトークンと cookies から渡されたトークンが一致するか確認
7. 一致したら検索履歴欄に地域名を渡す
   DB モデル名は seachHistory[user_token string, location string]
   作成結果
   search_histories  
   id integer  
   user_token varchar  
   location varchar  
   created_at datetime
   updated_at datetime

- マイグレーション調整(user_token nullfalse, location nullfalse)も事前に設計できた
  同じ usertoken で同じ地点を二か所登録できないように

```
add_index :search_histories, [:user_token, :location], unique: true
```

- 次は issue 作って稼働したい
  search_histories.yml にテスト書いて動作確認
- 昨日は MCV それぞれでブランチを作ろうとしていたが，issue 事にブランチ作ってそこで mcv すべて作ってしまうほうが効率がよさそうだ
- @histories(nil)で読んでエラー -> before actions
- 保存の際に 1 つの引数しか渡せていない
  token = "ce620e21-a2d1-4985-9378-dda2b75982c8"
  SearchHistory.where(user_token: token).order(updated_at: :desc).limit(5).pluck(:location, :updated_at)
- token を二重発行してる？
- token 判定を session で行っていた
  token = "5bdc0f56-506c-4253-ae9e-9a711467e568"
  => "ce620e21-a2d1-4985-9378-dda2b75982c8"
- 実装できた 検索結果が見つからない場合保存しないことを考慮していなかった -> if の中に移動
- 履歴保存箇所がきれいにサービス分離できなかった為削除　これも次回の事前設計に回す
- 戻るで戻った場合に履歴が更新されない問題
- 次への練習として，最後のビューの手直しは issue 稼働を行う．

### 参考

https://qiita.com/foot_raming/items/a0c9951365e41d66dac8
form-label の使い方

https://qiita.com/rk2530/items/8fdf6807e4f7cc33afbd
openweatherAPI で都市の気象データを取得している

https://qiita.com/sibakenY/items/cf44a2d79dae9f6443f0
service に分割している様子

https://guides.rubyonrails.org/routing.html
routes から path 生成

https://qiita.com/kidach1/items/43e53811c12351915278
RESTful とルーティング

https://nekorails.hatenablog.com/entry/2018/09/28/152745
faraday 使い方

```
connection = Faraday.new("http://example.com")
connection.params[:page] = 2
connection.get("/cats")
```

https://qiita.com/Masashi9410/items/16ce1c6da64eae497615
erb コメントアウト

https://qiita.com/t_t238/items/591cd44d89560b72154a
json / parse について

f.response :json, content_type: /json/ # 規定/\bjson$/から applicatiom/jspn, charset=utf=8 へ緩める

https://qiita.com/shimadama/items/7e5c3d75c9a9f51abdd5
曜日入れるために日本語対応

https://plog.kobacchi.com/rails-remember-me-by-cookie/
Cokkie を使ってログイン状態を保持する

https://qiita.com/kimascript/items/d718e5cdd629af3fe6a0
rails テーブル削除

https://zenn.dev/atsumu22/articles/69173f1cb5e880
重複登録　一意性

https://qiita.com/Chiba_67/items/8af392db90f5d1d9a5c5
一意制約(2)

https://qiita.com/akinov/items/852fe789fe98a44350a9
後から null

https://pikawaka.com/rails/validation#acceptance
validation

https://zenn.dev/mybest_dev/articles/973c927f3931ce
asociated の使い方がいまいちわからない

https://qiita.com/coe401_/items/ad7dc2f3e319c5beaf40
ruby cokkies 実装について

https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Set-Cookie
cokkie の挙動
