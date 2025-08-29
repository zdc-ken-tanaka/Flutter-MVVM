# CLAUDE.md

このファイルは、このリポジトリ内のコードを操作する際に Claude Code (claude.ai/code) にガイダンスを提供する。

## プロジェクト概要

Flutter 2.0を使用したMVVMアーキテクチャのサンプル音楽プレーヤーアプリケーション。
iTunes Search APIを使用してアーティスト名で楽曲を検索し、プレビュー再生できる。

## 開発コマンド

```bash
# 依存関係のインストール
flutter pub get

# アプリの実行
flutter run

# テストの実行
flutter test

# ビルド（Android）
flutter build apk

# ビルド（iOS）
flutter build ios

# 静的解析の実行
flutter analyze

# コードフォーマット
flutter format lib/
```

## MVVMアーキテクチャ構造

### Model層 (`lib/model/`)
- **apis/**: APIレスポンスとエラーハンドリング
  - `api_response.dart`: APIレスポンスの状態管理（INITIAL, LOADING, COMPLETED, ERROR）
  - `app_exception.dart`: カスタム例外クラス
- **services/**: 外部APIとの通信
  - `base_service.dart`: iTunes API基底URL定義（https://itunes.apple.com/search?term=）
  - `media_service.dart`: HTTPリクエスト処理とレスポンス変換
- **`media.dart`**: メディアデータモデル（アーティスト名、曲名、アートワーク等）
- **`media_repository.dart`**: サービス層とビューモデル層の仲介

### View層 (`lib/view/`)
- **screens/**: 画面定義
  - `home_screen.dart`: メイン画面（検索フィールド、楽曲リスト、プレーヤー）
- **widgets/**: 再利用可能なUIコンポーネント
  - `player_list_widget.dart`: 楽曲リスト表示
  - `player_widget.dart`: 音楽プレーヤーコントロール

### ViewModel層 (`lib/view_model/`)
- **`media_view_model.dart`**: 
  - ChangeNotifierを継承し、UIの状態管理
  - APIレスポンスの状態管理
  - 選択された楽曲の管理

### 依存性注入
- **Provider**パッケージを使用した状態管理
- `main.dart`でMultiProviderを使用してMediaViewModelを提供

## 主要な依存関係

- **provider**: ^5.0.0 - 状態管理
- **http**: ^0.13.1 - HTTPリクエスト
- **audioplayers**: ^0.18.2 - 音楽再生
- **Flutter SDK**: >=2.12.0 <3.0.0

## データフロー

1. ユーザーがHomeScreenで検索を実行
2. MediaViewModelのfetchMediaData()メソッドを呼び出し
3. MediaRepositoryを通じてMediaServiceがiTunes APIにリクエスト
4. レスポンスをMediaオブジェクトのリストに変換
5. ApiResponseでラップしてViewModelに返す
6. ViewModelがnotifyListeners()でUIを更新
7. HomeScreenがApiResponseのステータスに応じてUIを表示

## 注意事項

- Null safety対応済み（Dart SDK >=2.12.0）
- iTunes Search APIを使用（インターネット接続必須）
- テストファイル（`widget_test.dart`）はデフォルトのカウンターテストのまま（実際のアプリに合わせた更新が必要）