# source: https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-git
# first install git on windows
sudo apt-get update 
sudo apt-get install -y git
git config --global user.name "Miguel  Rodo"
git config --global user.email "rdxmig002@myuct.ac.za"
git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/bin/git-credential-manager.exe"
git config --global init.defaultBranch main
# to reconcile pulls
git config pull.ff only



