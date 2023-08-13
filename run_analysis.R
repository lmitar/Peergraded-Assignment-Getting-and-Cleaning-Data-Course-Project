
# Load required libraries
library(dplyr)

# Define paths
dataset_path <- "path_to/UCI HAR Dataset"

# Load training data
subject_train <- read.table(file.path(dataset_path, "train", "subject_train.txt"))
X_train <- read.table(file.path(dataset_path, "train", "X_train.txt"))
y_train <- read.table(file.path(dataset_path, "train", "y_train.txt"))

# Load test data
subject_test <- read.table(file.path(dataset_path, "test", "subject_test.txt"))
X_test <- read.table(file.path(dataset_path, "test", "X_test.txt"))
y_test <- read.table(file.path(dataset_path, "test", "y_test.txt"))

# Merge training and test data
subject <- rbind(subject_train, subject_test)
X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)

# Read features and extract mean and std columns
features <- read.table(file.path(dataset_path, "features.txt"))
mean_std_features <- grep("mean\\(|std\\(", features$V2)
X_mean_std <- X[, mean_std_features]

# Read activity labels and replace numeric labels with descriptive names
activity_labels <- read.table(file.path(dataset_path, "activity_labels.txt"))
y_descriptive <- factor(y$V1, levels = activity_labels$V1, labels = activity_labels$V2)

# Create a tidy dataset with the average of each variable for each activity and each subject
combined_data <- cbind(subject, y_descriptive, X_mean_std)
tidy_data <- combined_data %>%
    group_by(V1, y_descriptive) %>%
    summarise_all(mean)

# Save the tidy dataset
write.table(tidy_data, file="tidy_dataset.txt", row.names=FALSE)
