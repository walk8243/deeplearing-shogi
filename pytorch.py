import torch
from torch import nn
import torch.nn.functional as F
from torch.utils.data import DataLoader
from torchvision import datasets, transforms
import matplotlib.pyplot as plt

# ハイパーパラメータの設定
learning_rate = 0.001
batch_size = 64
epochs = 5

# データセット
transform=transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize((0.1307,), (0.3081,))
])
training_data = datasets.MNIST('data', train=True, download=True, transform=transform)
test_data = datasets.MNIST('data', train=False, transform=transform)

# データローダ
train_dataloader = DataLoader(training_data, batch_size, shuffle=True)
test_dataloader = DataLoader(test_data, batch_size)

# デバイス
use_cuda = True
device = torch.device("cuda" if use_cuda else "cpu")

# ニューラルネットワークの定義
class Net(nn.Module):
    def __init__(self):
        super(Net, self).__init__()
        self.conv1 = nn.Conv2d(1, 32, kernel_size=3, stride=1, padding=0)
        self.conv2 = nn.Conv2d(32, 64, kernel_size=3, stride=1, padding=0)
        self.fc1 = nn.Linear(9216, 128)
        self.fc2 = nn.Linear(128, 10)
    
    def forward(self, x):
        x = self.conv1(x)
        x = F.relu(x)
        x = self.conv2(x)
        x = F.relu(x)
        x = F.max_pool2d(x, 2)
        x = torch.flatten(x, 1)
        x = self.fc1(x)
        x = F.relu(x)
        output = self.fc2(x)
        return output

# モデル
model = Net()
model.to(device)

# 損失関数
loss_fn = nn.CrossEntropyLoss()

# オプティマイザ
optimizer = torch.optim.SGD(model.parameters(), lr=learning_rate)

# 指定エポック数だけ訓練を行う
for t in range(epochs):
    print(f"Epoch {t+1}\n-------------------------------")
    model.train()
    for batch_idx, (data, target) in enumerate(train_dataloader):
        data, target = data.to(device), target.to(device)
        # 順伝播
        output = model(data)
        # 損失計算
        loss = loss_fn(output, target)
        # 誤差逆伝播
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
        # 一定間隔で進捗表示
        if batch_idx % 100 == 99:
            print('epoch: {}, steps: {}/{}, train loss: {:.6f}'.format(t+1, batch_idx+1, len(train_dataloader), loss.item()))
    
    # エポックの終わりにテストデータすべてを使用して評価する
    model.eval()
    test_loss = 0
    correct = 0
    
    with torch.no_grad():
        for data, target in test_dataloader:
            data, target = data.to(device), target.to(device)
            output = model(data)
            test_loss += loss_fn(output, target).item()
            correct += (output.argmax(1) == target).type(torch.float).sum().item()
    
    print('epoch: {}, test loss: {:.6f}, test accuracy: {:.6f}'.format(t+1, test_loss/len(test_dataloader), correct/len(test_dataloader.dataset)))

# 学習したモデルを使用して推論を行う
test_index = 0
data = test_data[test_index][0]
# test_data[test_index][1] # 正解

model.eval()
with torch.no_grad():
    x = data.unsqueeze(0).to(device)
    logits = model(x)
    pred = torch.softmax(logits, dim=1).squeeze().cpu()
    plt.bar(range(10), pred)
    plt.show()
