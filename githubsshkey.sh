#! /bin/bash

# This script generates a new SSH key and adds it to the ssh-agent.
# It also configures the SSH config file to use the new key for GitHub.

# Check if the user has provided a GitHub email address
if [ -z "$1" ]; then
  echo "Usage: $0 <github_email>"
  exit 1
fi

GITHUB_EMAIL=$1

# Genarete a new SSH key
echo "Generating a new SSH key..."
ssh-keygen -t ed25519 -C "$GITHUB_EMAIL" -f ~/.ssh/id_ed25519 -N ""
if [ $? -ne 0 ]; then
  echo "Failed to generate SSH key."
  exit 1
fi
echo "SSH key generated successfully."

# Start the ssh-agent
echo "Starting the ssh-agent..."
eval "$(ssh-agent -s)"
if [ $? -ne 0 ]; then
  echo "Failed to start ssh-agent."
  exit 1
fi
echo "ssh-agent started successfully."

# Add the SSH key to the ssh-agent
echo "Adding the SSH key to the ssh-agent..."
ssh-add ~/.ssh/id_ed25519
if [ $? -ne 0 ]; then
  echo "Failed to add SSH key to ssh-agent."
  exit 1
fi
echo "SSH key added to ssh-agent successfully."

# Add the SSH key to the ssh config file
echo "Adding the SSH key to the ssh config file..."
if [ ! -f ~/.ssh/config ]; then
  touch ~/.ssh/config
fi

echo "Host github.com" >> ~/.ssh/config
echo "  HostName github.com" >> ~/.ssh/config
echo "  User git" >> ~/.ssh/config
echo "  IdentityFile ~/.ssh/id_ed25519" >> ~/.ssh/config
echo "SSH key added to ssh config file successfully."

# Cat the ssh public key to the clipboard
echo "Your public key is:"
cat ~/.ssh/id_ed25519.pub
