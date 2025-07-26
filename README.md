### 作成物 1: 地域名を入れて天気が見えるアプリを作成する

https://qiita.com/enzen/items/14271ec8fdf01107d1ce
を参考にして設計 → 開発を行う

### 要件定義

対象地域: 日本国内，自由入力  
使用 API: WeatherAPI  
API リクエスト: 毎回リアルタイム習得  
表示範囲: 今日～ 3 日後  
表示データ: 天候，気温，湿度  
検索履歴: DB に 5 件まで保存  
技術スタック: ruby3.1.4, rails7.1, mysql8  
デプロイ: raspi nginx  

#### サイトマップ

![sitemap](https://github.com/user-attachments/assets/94f7ace7-b2df-41df-ad8a-02decf86e767)

#### ワイヤーフレーム

![wireflame](https://github.com/user-attachments/assets/a974b235-7081-407e-911c-f38cea08d50b)
検索欄タップで履歴表示五件まで
本日～明々後日天気表示画面はス

#### 機能設計

##### エンドポイント

/ , GET, 検索欄表示，cookie 履歴表示  
/weather, POST, 検索内容より/weather:id にリダイレクト  
/weather/:id, GET, :id で API を叩き，結果を cookie へ保存  

##### gem

faraday, API 呼び出し用  
pry-rails, デバッグ用  

##### コントローラ設計

検索ボタンを押すと，

1. weatherController が呼び出される  
2. 検索欄の内容を cookie に保存し，結果を天気教示画面へ送る  

### 実装
