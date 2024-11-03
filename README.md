# DeepLearning 将棋

## ローカルコードの実行

### インストール

PyTorchのインストールコマンドは [Start Locally | PyTorch](https://pytorch.org/get-started/locally/) から作成してください。

```sh
conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia
conda install matplotlib
pip install cshogi
conda install scikit-learn
```

### ディレクトリ構成

```
- features.py
- train.py
- dataloader.py
- network
   `- policy_value_resnet.py
- utils
   |- csa_to_hcpe.py
   `- plot_log_policy_value.py # 学習の精度をログから可視化する
- data # 学習データ
   `- floodgate
       |- wdoor20xx # floodgateから取得した
       |   `- wdoor+floodgate-~~.csa
       |- train.hcpe
       |- train_average.hcpe
       `- test.hcpe
- results # 実行結果
   `- 20xxxxxx_xxxxxx
       |- result.model
       |- result.onnx
       `- checkpoint-xxx.pth
- logs # 実行ログ
   `- train-20xxxxxx_xxxxxx.log
- checkpoints
   `- checkpoint-~.pth
- tutorial
   |- hello.py # Hello World
   |- pytorch.py # PyTorchを使ってみる
   `- image.py # 画像を表示する
```

### 訓練データ

大量の棋譜が入手できるコンピュータ将棋の対局サイトである [floodgate](http://wdoor.c.u-tokyo.ac.jp/shogi/) の棋譜を使用します。

http://wdoor.c.u-tokyo.ac.jp/shogi/x/

### 実行

#### 学習ファイルの生成

```sh
python utils/csa_to_hcpe.py floodgate tarin.hcpe test.hcpe
```

#### 学習

```sh
python train.py train.hcpe test.hcpe
```

## dlshogi

### インストール

[dlshogi](dlshogi.md) を参考にインストールしてください。

さらに追加で以下のライブラリをインストールしてください。

```sh
conda install onnx pandas
```

### 学習

学習ファイルは上と同じものを使用してください。

```sh
python -m dlshogi.train --epoch 1 --batchsize 1024 --model shogi.model --log logs/train.log --lr 0.01 --use_amp --use_evalfix train.hcpe test.hcpe
```

### ONNX形式への変換

```sh
python -m dlshogi.convert_model_to_onnx shogi.model shogi.onnx
```

### 学習ファイルの生成

```sh
python -m dlshogi.utils.csa_to_hcpe floodgate floodgate.hcpe --eval 5000 --filter_moves 50 --filter_rating 3500
python -m dlshogi.utils.uniq_hcpe --average floodgate.hcpe floodgate_average.hcpe
python -m dlshogi.utils.sample_hcpe floodgate_average.hcpe floodgate_test.hcpe 640000
```
