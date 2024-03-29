# Importing necessary modules
# ===================================================================================================
from matplotlib import pyplot as plt
import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.utils.data as data
import torchvision.datasets as datasets
from torchvision import transforms
import os
import sys
from collections import Counter
import torchsummary
from torch.utils.data import random_split
from sklearn.model_selection import train_test_split
from torch.utils.data import Subset
import time


# Initial setup and configuration
# ===================================================================================================
device = 'cuda' if torch.cuda.is_available() else 'cpu'

# Hyperparameters
# ===================================================================================================
learning_rate = 0.01
BATCH_SIZE = 100
epochs = 500

now = time.time()
output_file = open(f'{epochs}_{learning_rate}_{BATCH_SIZE}-w_RES-script_output{now}.txt', 'w')
sys.stdout = output_file
print('Using {} device '.format(device))

# Compute Mean and Std
# ===================================================================================================
mean_std_file = 'FER_mean_std.npz'
if os.path.exists(mean_std_file):
    # Load mean and std
    filedata = np.load(mean_std_file)
    mean = filedata['mean']
    std = filedata['std']
else:
    # Load the dataset without normalization
    unnormalized_transform = transforms.Compose([
        transforms.ToTensor()
    ])
    unnormalized_dataset = datasets.FER2013(
        root="DataSets\Torch_FER",  
        transform=unnormalized_transform
    )

    # Function to calculate mean and std
    def get_mean_std(loader):
        channels_sum, channels_squared_sum, num_batches = 0, 0, 0
        
        for data, _ in loader:
            channels_sum += torch.mean(data, dim=[0, 2, 3])
            channels_squared_sum += torch.mean(data**2, dim=[0, 2, 3])
            num_batches += 1
        
        mean = channels_sum / num_batches
        std = (channels_squared_sum / num_batches - mean**2)**0.5

        return mean, std

    # DataLoader for computing mean and std
    unnormalized_loader =  data.DataLoader(unnormalized_dataset, batch_size=BATCH_SIZE, shuffle=True)


    # Calculate mean and standard deviation
    mean, std = get_mean_std(unnormalized_loader)

    np.savez(mean_std_file, mean=mean.numpy(), std=std.numpy())
print(f"Calculated Mean: {mean}")
print(f"Calculated Std: {std}")


# Data Transformations
# ===================================================================================================
train_transforms = transforms.Compose([
    transforms.RandomHorizontalFlip(),
    transforms.RandomRotation(10),
    transforms.RandomAffine(degrees=0, translate=(0.1, 0.1)),
    transforms.ToTensor(),
    transforms.Normalize(mean=mean, std=std)
])

val_test_transforms = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize(mean=mean, std=std)
])

# Data Loading
# ===================================================================================================
train_dataset = datasets.FER2013(
    root="DataSets\Torch_FER",  
    split='train',
    transform=train_transforms  
)

val_dataset = datasets.FER2013(
    root="DataSets\Torch_FER",  
    split='train',
    transform=val_test_transforms 
)

# Calculate the split index
split = int(0.8 * len(train_dataset))

# Create training and validation datasets using Subset
train_dataset = Subset(train_dataset, range(0, split))
val_dataset = Subset(val_dataset, range(split, len(val_dataset)))


test_dataset = datasets.FER2013(
    root="DataSets\Torch_FER",  
    split='test',
    transform=val_test_transforms
)

unique_labels = set()
for _, label in train_dataset:
    unique_labels.add(label)


def count_categories(dataset):
    """Counts the number of instances per category in a given dataset."""
    try:
        # Directly use the labels as they are integers
        labels = [label for _, label in dataset]
        return Counter(labels)
    except Exception as e:
        print(f"Error occurred: {e}")
        return Counter()


train_loader = data.DataLoader(dataset=train_dataset, batch_size=BATCH_SIZE, shuffle=True)
train_loader_eval = data.DataLoader(dataset=val_dataset, batch_size=BATCH_SIZE, shuffle=True)
test_loader = data.DataLoader(dataset=test_dataset, batch_size=2*BATCH_SIZE, shuffle=True)

# Count categories in the datasets
train_category_counts = count_categories(train_dataset)
val_category_counts = count_categories(val_dataset)
test_category_counts = count_categories(test_dataset)

# Printing the counts
print("Training Set Category Counts:", train_category_counts)
print("Validation Set Category Counts:", val_category_counts)
print("Test Set Category Counts:", test_category_counts)

print('train_dataset')
print(train_dataset)
print('val_dataset')
print(val_dataset)
print('test_dataset')
print(test_dataset)



# Neural Network Architecture
# ===================================================================================================
class ResBlock(nn.Module):
    expansion = 1

    def __init__(self, in_channels, out_channels, stride=1):
        super(ResBlock, self).__init__()
        # First conv layer
        self.conv1 = nn.Conv2d(in_channels, out_channels, kernel_size=3, stride=stride, padding=1, bias=False)
        self.bn1 = nn.BatchNorm2d(out_channels)
        
        # Second conv layer
        self.conv2 = nn.Conv2d(out_channels, out_channels, kernel_size=3, stride=1, padding=1, bias=False)
        self.bn2 = nn.BatchNorm2d(out_channels)

        # Shortcut connection to downsample residual
        self.shortcut = nn.Sequential()
        if stride != 1 or in_channels != self.expansion * out_channels:
            self.shortcut = nn.Sequential(
                nn.Conv2d(in_channels, self.expansion * out_channels, kernel_size=1, stride=stride, bias=False),
                nn.BatchNorm2d(self.expansion * out_channels)
            )

    def forward(self, x):
        out = F.relu(self.bn1(self.conv1(x)))
        out = self.bn2(self.conv2(out))
        out += self.shortcut(x)
        out = F.relu(out)
        return out

class ResNet(nn.Module):
    def __init__(self, block, num_blocks, num_classes=7):
        super(ResNet, self).__init__()
        self.in_channels = 64

        # Initial input conv
        self.conv1 = nn.Conv2d(1, 64, kernel_size=3, stride=1, padding=1, bias=False)
        self.bn1 = nn.BatchNorm2d(64)
        
        # ResNet layers
        self.layer1 = self._make_layer(block, 64, num_blocks[0], stride=1)
        self.layer2 = self._make_layer(block, 128, num_blocks[1], stride=2)
        
        # Example fully connected layers
        self.linear1 = nn.Linear(4608, 500)
        self.linear2 = nn.Linear(500, num_classes)

    def _make_layer(self, block, out_channels, num_blocks, stride):
        strides = [stride] + [1]*(num_blocks-1)
        layers = []
        for stride in strides:
            layers.append(block(self.in_channels, out_channels, stride))
            self.in_channels = out_channels * block.expansion
        return nn.Sequential(*layers)

    def forward(self, x):
        out = F.relu(self.bn1(self.conv1(x)))
        out = self.layer1(out)
        out = self.layer2(out)
        out = F.avg_pool2d(out, 4)
        out = out.view(out.size(0), -1)
        out = F.relu(self.linear1(out))
        out = self.linear2(out)
        return out
    
# Training and Validation Loops
# ===================================================================================================
def train_loop(dataloader, model, loss_fn, optimizer):
    size = len(dataloader.dataset)
    for batch, (X,y) in enumerate(dataloader):
        X = X.to(device)
        y = y.to(device).long()
        pred = model(X)
        loss = loss_fn(pred,y)
    
        optimizer.zero_grad()
        loss.backward()
        optimizer.step()
    
        if batch %100 == 0:
            loss, current = loss.item(), batch*len(X)
            print(f"loss: {loss: > 7f} [{current: > 5d}/{size:>5d}]")

def test_loop(dataloader, model, loss_fn, valid_or_test_flag = "valid"):
    size = len(dataloader.dataset)
    test_loss, correct = 0,0
    with torch.no_grad():
        for X,y in dataloader:
            X = X.to(device)
            y = y.to(device).long()
            pred = model(X)
            test_loss += loss_fn(pred,y).item()
            correct += (pred.argmax(1)==y).type(torch.float).sum().item()
    test_loss /= size
    correct /= size
    if valid_or_test_flag == "test":
        print(f"Test Error: \n Accuracy {(100*correct):>0.1f}%, Avg. loss: {test_loss:>8f} \n")
    else: 
        print(f"Validation Error: \n Accuracy {(100*correct):>0.1f}%, Avg. loss: {test_loss:>8f} \n")   

    return(test_loss, correct)

# Visualization of Incorrect Examples
# ===================================================================================================
def visualize_incorrect_examples(model, dataloader, labels_dict, save_path="./images/", n_categories=8):
    if not os.path.exists(save_path):
        os.makedirs(save_path)

    model.eval()
    correct_examples = [[] for _ in range(n_categories)]
    incorrect_examples = [None] * n_categories

    with torch.no_grad():
        for images, labels in dataloader:
            images, labels = images.to(device), labels.to(device).squeeze(1)
            outputs = model(images)
            predictions = outputs.argmax(1)

            for img, label, pred in zip(images, labels, predictions):
                # Collect correct examples for each category
                if len(correct_examples[label]) < 1 and pred == label:
                    correct_examples[label].append(img.cpu())
                
                # Collect the first incorrect example for each category
                if pred != label and incorrect_examples[label] is None:
                    if len(correct_examples[pred]) >= 1:
                        incorrect_examples[label] = (correct_examples[pred][0], img.cpu(), label.item(), pred.item())

    # Plotting and saving
    for idx, example in enumerate(incorrect_examples):
        if example is not None:
            pred_correct_img, incorrect_img, correct_label, predicted_label = example
            fig, axs = plt.subplots(1, 3, figsize=(15, 5))

            # Correct example of predicted category
            pred_correct_img = transforms.ToPILImage()(pred_correct_img)
            axs[0].imshow(pred_correct_img, cmap='gray')
            axs[0].set_title(f"Predicted: {labels_dict[str(predicted_label)]}")
            axs[0].axis('off')

            # Incorrectly categorized image
            incorrect_img = transforms.ToPILImage()(incorrect_img)
            axs[1].imshow(incorrect_img, cmap='gray')
            axs[1].set_title("Incorrectly Categorized")
            axs[1].axis('off')

            # Correct example of actual category
            actual_correct_img = transforms.ToPILImage()(correct_examples[correct_label][0])
            axs[2].imshow(actual_correct_img, cmap='gray')
            axs[2].set_title(f"Actual: {labels_dict[str(correct_label)]}")
            axs[2].axis('off')

            plt.savefig(os.path.join(save_path, f"category_{idx}_incorrect_example.png"))
            plt.show()

# Model Training and Evaluation
# ===================================================================================================
model_dir = f'./models/{epochs}_{learning_rate}_{BATCH_SIZE}-w_RES{now}'
os.makedirs(model_dir, exist_ok=True)
model_file_path = os.path.join(model_dir, 'Trained_Net.pth')
model =  ResNet(ResBlock, [2, 2], num_classes=7).to(device)
print(model)
torchsummary.summary(model, input_size=(1, 48, 48))


loss_fn = nn.CrossEntropyLoss()
optimizer = torch.optim.SGD(model.parameters(),lr = learning_rate)
scheduler = torch.optim.lr_scheduler.ReduceLROnPlateau(optimizer, 'min')


val_losses = []
accuracy = []

# Model Loading and Training
# ===================================================================================================
if os.path.exists(model_file_path ):
    model.load_state_dict(torch.load(model_file_path ))
    model.eval()  # Set the model to evaluation mode
    print()
    print(f"Model loaded from {model_file_path }")
else:
    for t in range(epochs):
        print(f"Epoch {t+1})\n --------------------------")
        train_loop(train_loader, model, loss_fn, optimizer)
        test_loss, correct = test_loop(train_loader_eval, model, loss_fn, valid_or_test_flag = "valid")
        val_losses.append(test_loss)
        accuracy.append(correct) 
        scheduler.step(test_loss)
    print()
    print("Done Training")

    # Correct way to save the model
    torch.save(model.state_dict(), model_file_path)
    print(f"Model saved to {model_file_path}")

    plt.figure(figsize=(10,5))
    plt.title("Validation Accuracy")
    plt.plot(accuracy,label="Validation Accuracy")
    plt.xlabel("epochs")
    plt.ylabel("Accuracy")
    plt.legend()
    plt.savefig(f"FER_validation_accuracy-e{epochs}-lr{learning_rate}-bs{BATCH_SIZE}-w_RES{now}.png")
    plt.show()

    plt.figure(figsize=(10,5))
    plt.title("Validation Loss")
    plt.plot(val_losses,label="Validation Loss")
    plt.xlabel("epochs")
    plt.ylabel("Validation Loss")
    plt.legend()
    plt.savefig(f"FER_validation_loss-e{epochs}-lr{learning_rate}-bs{BATCH_SIZE}-w_RES{now}.png")
    plt.show()

labels_list = [
    "Angry", "Disgust", "Fear", "Happy", "Sad", "Surprise", "Neutral"
]

labels_dict = {str(i): label for i, label in enumerate(labels_list)}


visualize_incorrect_examples(model, test_loader, labels_dict)

# Final Testing
# ===================================================================================================
print()
print("Begin Test")
test_loop(test_loader, model, loss_fn,valid_or_test_flag = "test")

output_file.close()
sys.stdout = sys.__stdout__