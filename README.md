# DeepLearning 将棋

## インストール

PyTorchのインストールコマンドは [Start Locally | PyTorch](https://pytorch.org/get-started/locally/) から作成する

```sh
conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia
conda install matplotlib
pip install cshogi
conda install scikit-learn
```

## ディレクトリ構成

```
- features.py
- train.py
- dataloader.py
- network
   `- policy_value_resnet.py
- utils
   `- csa_to_hcpe.py
- floodgate
   `- wdoor20xx # floodgateから取得した
       `- 20xx
           `- wdoor+floodgate-~~.csa
- checkpoints
   `- checkpoint-~.pth
- practice
   |- hello.py # Hello World
   |- pytorch.py # PyTorchを使ってみる
   `- image.py # 画像を表示する
```

## 訓練データ

大量の棋譜が入手できるコンピュータ将棋の対局サイトである [floodgate](http://wdoor.c.u-tokyo.ac.jp/shogi/) の棋譜を使用します。

http://wdoor.c.u-tokyo.ac.jp/shogi/x/

## 実行

```sh
!python utils/csa_to_hcpe.py floodgate tarin.hcpe test.hcpe
!python train.py train.hcpe test.hcpe
```
