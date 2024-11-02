# dlshogi

https://github.com/TadaoYamaoka/DeepLearningShogi

## 必要なもの

### CUDA

以下から最新のCUDAをダウンロードする。

https://developer.nvidia.com/cuda-downloads

### cuDNN

以下から最新のcuDNNを `Tarball` からダウンロードする。

https://developer.nvidia.com/cudnn-downloads

ダウンロードしたzipファイルを解凍して、
先ほどダウンロードしたCUDAに階層を維持したままコピーする。

### TensorRT

以下から最新のTensorRTをダウンロードする。
その際、ダウンロード済みのCUDAのバージョンに注意して選択する。

https://developer.nvidia.com/tensorrt/download

## 環境変数への登録

以下を環境変数の `PATH` に登録する

- CUDAの `bin`
- TensorRT の `lib`

## インストール

```sh
git clone https://github.com/TadaoYamaoka/DeepLearningShogi.git dlshogi
cd dlshogi
pip install cython
python install -e .
```
