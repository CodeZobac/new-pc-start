#!/bin/bash

# Ubuntu Development Environment Setup Script
# Installs: Makefile, Kubernetes, Terraform, Python, Poetry, UV, Node, NPM, Docker, Docker Compose
# Author: Auto-generated setup script
# Date: $(date)

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should not be run as root"
        exit 1
    fi
}

# Update system packages
update_system() {
    log_info "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y curl wget gnupg lsb-release software-properties-common apt-transport-https ca-certificates
    log_success "System packages updated"
}

# Install build essentials (includes make/Makefile support)
install_build_essentials() {
    log_info "Installing build essentials (includes make)..."
    sudo apt install -y build-essential make gcc g++ libc6-dev
    log_success "Build essentials installed"
    make --version
}

# Install Python (latest)
install_python() {
    log_info "Installing Python..."
    sudo apt install -y python3 python3-pip python3-venv python3-dev
    
    # Create symlink for python command
    if ! command -v python &> /dev/null; then
        sudo ln -sf /usr/bin/python3 /usr/bin/python
    fi
    
    log_success "Python installed"
    python3 --version
    pip3 --version
}

# Install Poetry (official installer)
install_poetry() {
    log_info "Installing Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
    
    # Add to PATH
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.local/bin:$PATH"
    
    log_success "Poetry installed"
    ~/.local/bin/poetry --version || log_warning "Poetry installed but may need terminal restart"
}

# Install UV (Python package installer)
install_uv() {
    log_info "Installing UV..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    
    # Add to PATH
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.cargo/bin:$PATH"
    
    log_success "UV installed"
    ~/.cargo/bin/uv --version || log_warning "UV installed but may need terminal restart"
}

# Install Node.js and NPM (using NodeSource repository)
install_node() {
    log_info "Installing Node.js and NPM..."
    
    # Install Node.js 20.x LTS
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt install -y nodejs
    
    log_success "Node.js and NPM installed"
    node --version
    npm --version
}

# Install Docker (official repository)
install_docker() {
    log_info "Installing Docker..."
    
    # Remove old versions
    sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
    
    # Add Docker's official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    
    # Add Docker repository
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Install Docker Engine
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Add user to docker group
    sudo usermod -aG docker $USER
    
    log_success "Docker installed"
    sudo docker --version
    sudo docker compose version
    log_warning "You may need to log out and back in for Docker group membership to take effect"
}

# Install Kubernetes tools (kubectl, kubeadm, kubelet)
install_kubernetes() {
    log_info "Installing Kubernetes tools..."
    
    # Add Kubernetes GPG key
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    
    # Add Kubernetes repository
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    
    # Install Kubernetes tools
    sudo apt update
    sudo apt install -y kubectl kubeadm kubelet
    sudo apt-mark hold kubelet kubeadm kubectl
    
    log_success "Kubernetes tools installed"
    kubectl version --client
}

# Install Terraform (official repository)
install_terraform() {
    log_info "Installing Terraform..."
    
    # Add HashiCorp GPG key
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/hashicorp.gpg
    
    # Add HashiCorp repository
    echo "deb [signed-by=/etc/apt/keyrings/hashicorp.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    
    # Install Terraform
    sudo apt update
    sudo apt install -y terraform
    
    log_success "Terraform installed"
    terraform --version
}

# Install additional useful tools
install_additional_tools() {
    log_info "Installing additional development tools..."
    sudo apt install -y git vim nano htop tree jq unzip zip
    log_success "Additional tools installed"
}

# Main installation function
main() {
    log_info "Starting Ubuntu Development Environment Setup..."
    
    check_root
    update_system
    install_build_essentials
    install_python
    install_poetry
    install_uv
    install_node
    install_docker
    install_kubernetes
    install_terraform
    install_additional_tools
    
    log_success "All installations completed!"
    
    echo ""
    log_info "Installation Summary:"
    echo "✅ Make/Makefile support (build-essential)"
    echo "✅ Python 3 + pip"
    echo "✅ Poetry (Python package manager)"
    echo "✅ UV (Fast Python package installer)"
    echo "✅ Node.js + NPM"
    echo "✅ Docker + Docker Compose"
    echo "✅ Kubernetes tools (kubectl, kubeadm, kubelet)"
    echo "✅ Terraform"
    echo "✅ Additional development tools"
    
    echo ""
    log_warning "IMPORTANT NOTES:"
    echo "1. Restart your terminal or run 'source ~/.bashrc' to update PATH"
    echo "2. Log out and back in for Docker group membership to take effect"
    echo "3. For Poetry and UV, you may need to restart your terminal"
    
    echo ""
    log_info "Versions installed:"
    echo "Make: $(make --version | head -1)"
    echo "Python: $(python3 --version)"
    echo "Node.js: $(node --version)"
    echo "NPM: $(npm --version)"
    echo "Docker: $(sudo docker --version)"
    echo "Docker Compose: $(sudo docker compose version)"
    echo "kubectl: $(kubectl version --client --short 2>/dev/null || echo 'Restart terminal to use')"
    echo "Terraform: $(terraform --version | head -1)"
}

# Run main function
main "$@"
