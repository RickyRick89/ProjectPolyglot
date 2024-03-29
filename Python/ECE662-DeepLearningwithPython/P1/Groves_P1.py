# Importing necessary modules
# ===================================================================================================
from matplotlib import pyplot as plt
import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F
import torch.utils.data as data
from torchvision import transforms
import os
import medmnist
from medmnist import INFO, Evaluator

# Initial setup and configuration
# ===================================================================================================
print(f"MedMNIST v{medmnist.__version__} @ {medmnist.HOMEPAGE}")
device = 'cuda' if torch.cuda.is_available() else 'cpu'
print('Using {} device '.format(device))

# Hyperparameters
# ===================================================================================================
learning_rate = 0.01
BATCH_SIZE = 223
epochs = 150

# Dataset selection
# ===================================================================================================
data_flag = 'tissuemnist'

# Dataset Information
# ===================================================================================================
info = INFO[data_flag]
task = info['task']
n_channels = info['n_channels']
n_classes = len(info['label'])
DataClass = getattr(medmnist, info['python_class'])

# Data Transformations
# ===================================================================================================
data_transform = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize(mean=[.5], std=[.5])
])


# Data Loading
# ===================================================================================================
train_dataset = DataClass(split='train', transform=data_transform, download=True)
test_dataset = DataClass(split='test', transform=data_transform, download=True)

train_loader = data.DataLoader(dataset=train_dataset, batch_size=BATCH_SIZE, shuffle=True)
train_loader_eval = data.DataLoader(dataset=train_dataset, batch_size=BATCH_SIZE, shuffle=True)
test_loader = data.DataLoader(dataset=test_dataset, batch_size=2*BATCH_SIZE, shuffle=True)

print(train_dataset)



# Neural Network Architecture
# ===================================================================================================
class Net(nn.Module):
    def __init__(self):
        super().__init__()
        self.conv1 = nn.Conv2d(1, 10, stride=1, kernel_size=3, padding=1, padding_mode='replicate')  # makes 20 maps of 28x28
        self.pool = nn.MaxPool2d(2, 2)                              # 20 maps of 14x14
        self.conv2 = nn.Conv2d(10, 20, stride=1, kernel_size=3, padding=1, padding_mode='replicate') # 40 maps of 14x14
        self.pool = nn.MaxPool2d(2, 2)                              # 40 maps of 7x7
        self.fc1 = nn.Linear(20 * 7*7, 100)                       # FC 40*7*7 to 100 neurons                   
        self.fc2 = nn.Linear(100, 50)                              # FC 100 to 50 neurons
        self.fc3 = nn.Linear(50,8)                  # 50 to 4 neurons to form logits
    def forward(self, x):
        x = self.pool(F.relu(self.conv1(x)))
        x = self.pool(F.relu(self.conv2(x)))
        x = torch.flatten(x, 1)
        x = F.relu(self.fc1(x))
        x = F.relu(self.fc2(x))
        logits = self.fc3(x)
        return logits
    
# Training and Validation Loops
# ===================================================================================================
def train_loop(dataloader, model, loss_fn, optimizer):
    size = len(dataloader.dataset)
    for batch, (X,y) in enumerate(dataloader):
        X = X.to(device)
        y = y.to(device).squeeze(1).long()
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
            y = y.to(device).squeeze(1).long()
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
model_file_path  = './Trained_Net.pth'
model =  Net().to(device)
print(model)

loss_fn = nn.CrossEntropyLoss()
optimizer = torch.optim.SGD(model.parameters(),lr = learning_rate)

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
    plt.show()

    plt.figure(figsize=(10,5))
    plt.title("Validation Loss")
    plt.plot(val_losses,label="Validation Loss")
    plt.xlabel("epochs")
    plt.ylabel("Validation Loss")
    plt.legend()
    plt.show()

labels_dict = {'0': 'Collecting Duct, Connecting Tubule', '1': 'Distal Convoluted Tubule', 
               '2': 'Glomerular endothelial cells', '3': 'Interstitial endothelial cells', 
               '4': 'Leukocytes', '5': 'Podocytes', '6': 'Proximal Tubule Segments', 
               '7': 'Thick Ascending Limb'}


visualize_incorrect_examples(model, test_loader, labels_dict)

# Final Testing
# ===================================================================================================
print()
print("Begin Test")
test_loop(test_loader, model, loss_fn,valid_or_test_flag = "test")