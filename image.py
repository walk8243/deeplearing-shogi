from torchvision import datasets, transforms
import matplotlib.pyplot as plt

# データセット
transform = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize((0.1307,), (0.3081,))
])
test_data = datasets.MNIST('data', train=False, transform=transform)

test_index = 0
data = test_data[test_index][0]
plt.imshow(data.squeeze().numpy(), cmap='gray')
plt.show()

test_data[test_index][1]
