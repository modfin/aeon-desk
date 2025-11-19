#!/bin/bash


curl https://raw.githubusercontent.com/modfin/aeon-desk/refs/heads/master/setup.sh | bash


flatpak install --assumeyes --noninteractive flathub com.visualstudio.code
flatpak install --assumeyes --noninteractive flathub com.jetbrains.IntelliJ-IDEA-Ultimate
flatpak install --assumeyes --noninteractive flathub com.jetbrains.GoLand

## Installing Oh my zsh
distrobox enter default -- sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cat << 'EOF' >> .zshrc 

## zsh conf
ZSH_THEME="fishy" 
plugins=(git fzf)
EOF






## Installing Google Cloud Tools
distrobox enter default -- bash -c "
  mkdir -p .google
  cd .google
  curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-linux-x86_64.tar.gz
  tar -xf google-cloud-cli-linux-x86_64.tar.gz 
  ./google-cloud-sdk/install.sh --quiet"

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
    " >> $HOME/.bash_profile
    source $HOME/.bash_profile
  
  ### autocompleat for zsh
  kubectl completion zsh > "$HOME/.oh-my-zsh/completions/_kubectl"


cat << 'EOF' | tee -a .zshrc .bashrc

## k8s
alias k="kubectl"
EOF

  ## Install k8s krew
cat << 'EOF' | distrobox enter default
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

cat << 'EOF' | distrobox enter default
kubectl krew install ctx
kubectl krew install ns
EOF

cat << 'EOF' | tee -a .zshrc .bashrc
alias kubectx="kubectl ctx"
EOF



## Adding Podman / Docker hooks

sudo transactional-update pkg in podman-compose

cat << 'EOF' | tee -a .zshrc .bashrc

## Docker hooks
alias podman="distrobox-host-exec podman"
alias docker=podman
alias podman-compose="podman compose"
alias docker-compose=podman-compose
EOF






