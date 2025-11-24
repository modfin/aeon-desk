#!/bin/bash

cd $HOME
sudo echo Staring dev installation

## Adding Podman / Docker hooks
echo "Installing podman compose (needs sudo)"
sudo transactional-update pkg in -y -l podman-compose


curl https://raw.githubusercontent.com/modfin/aeon-desk/refs/heads/master/setup.sh | bash

flatpak install --assumeyes --noninteractive flathub com.visualstudio.code
flatpak install --assumeyes --noninteractive flathub com.jetbrains.IntelliJ-IDEA-Ultimate
flatpak install --assumeyes --noninteractive flathub com.jetbrains.GoLand

## Installing Oh my zsh
echo "curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh" | distrobox enter

cat << 'EOF' >> .zshrc 

## zsh conf
ZSH_THEME="fishy" 
plugins=(git fzf)
EOF






## Installing Google Cloud Tools
cat << 'EOF' | distrobox enter
  mkdir -p .google
  cd .google
  curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
  tar -xf google-cloud-cli-linux-x86_64.tar.gz 
  ./google-cloud-sdk/install.sh --quiet
EOF

cat << 'EOF' >> .bashrc

# The next line updates PATH and shell command completion for the Google Cloud SDK.
source ~/.google/google-cloud-sdk/path.bash.inc
source ~/.google/google-cloud-sdk/completion.bash.inc
EOF

cat << 'EOF' >> .zshrc

# The next line updates PATH and shell command completion for the Google Cloud SDK.
source ~/.google/google-cloud-sdk/path.zsh.inc
source ~/.google/google-cloud-sdk/completion.zsh.inc
EOF


## k8s tools
curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" > $HOME/.local/bin/kubectl
chmod +x $HOME/.local/bin/kubectl

  ### autocompleat for bash
  kubectl completion bash > ~/.kube/completion.bash.inc
    printf "
    # kubectl shell completion
    source '$HOME/.kube/completion.bash.inc'
    " >> $HOME/.bashrc
  
  ### autocompleat for zsh
  kubectl completion zsh > "$HOME/.oh-my-zsh/completions/_kubectl"





## Install k8s krew
cat << 'EOF' | distrobox enter
  cd "$(mktemp -d)"
  OS="$(uname | tr '[:upper:]' '[:lower:]')"
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')"
  KREW="krew-${OS}_${ARCH}"
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz"
  tar zxvf "${KREW}.tar.gz"
  ./"${KREW}" install krew
EOF


cat << 'EOF' | tee -a .zshrc .bashrc
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
EOF

cat << 'EOF' | distrobox enter
kubectl krew install ctx
kubectl krew install ns
kubectl krew install stern
EOF

cat << 'EOF' | tee -a .zshrc .bashrc

## k8s
alias k="kubectl"
alias kubectx="kubectl ctx"
alias stern="kubectl stern"
EOF




cat << 'EOF' | tee -a .zshrc .bashrc

## Docker hooks to host
alias podman="distrobox-host-exec podman"
alias docker=podman
alias podman-compose="distrobox-host-exec podman compose"
alias docker-compose=podman-compose
EOF







