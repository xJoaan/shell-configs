#!/bin/bash

# Script de instalación de dotfiles
# Autor: msistudio

set -e

echo "🚀 Instalando dotfiles..."

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Crear backup de archivos existentes
backup_if_exists() {
    if [ -f "$1" ]; then
        echo -e "${YELLOW}⚠️  Creando backup de $1${NC}"
        cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
    fi
}

# Instalar dependencias
echo -e "${BLUE}📦 Instalando dependencias...${NC}"
sudo apt-get update
sudo apt-get install -y git curl wget zsh

# Instalar Oh My Zsh si no está instalado
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${BLUE}📥 Instalando Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Instalar plugins de zsh
echo -e "${BLUE}🔌 Instalando plugins de zsh...${NC}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

# Instalar Starship
if ! command -v starship &> /dev/null; then
    echo -e "${BLUE}⭐ Instalando Starship...${NC}"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Instalar kubectl
if ! command -v kubectl &> /dev/null; then
    echo -e "${BLUE}☸️  Instalando kubectl...${NC}"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
fi

# Instalar Docker
if ! command -v docker &> /dev/null; then
    echo -e "${BLUE}🐳 Instalando Docker...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
    echo -e "${YELLOW}💡 Recuerda agregar tu usuario al grupo docker: sudo usermod -aG docker \$USER${NC}"
fi

# Instalar Terraform
if ! command -v terraform &> /dev/null; then
    echo -e "${BLUE}🏗️  Instalando Terraform...${NC}"
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update
    sudo apt-get install -y terraform
fi

# Instalar fuente Nerd Font
echo -e "${BLUE}🔤 Instalando MesloLGS Nerd Font...${NC}"
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts

if [ ! -f "MesloLGS NF Regular.ttf" ]; then
    curl -fLo "MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
    curl -fLo "MesloLGS NF Bold.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
    curl -fLo "MesloLGS NF Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
    curl -fLo "MesloLGS NF Bold Italic.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
    fc-cache -fv
fi

# Configurar fuente en GNOME Terminal
if command -v gsettings &> /dev/null; then
    echo -e "${BLUE}🎨 Configurando fuente en GNOME Terminal...${NC}"
    PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ use-system-font false
    gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ font 'MesloLGS NF 11'
fi

cd - > /dev/null

# Copiar archivos de configuración
echo -e "${BLUE}📝 Copiando archivos de configuración...${NC}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

backup_if_exists "$HOME/.zshrc"
cp "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"

mkdir -p "$HOME/.config"
backup_if_exists "$HOME/.config/starship.toml"
cp "$SCRIPT_DIR/starship.toml" "$HOME/.config/starship.toml"

mkdir -p "$HOME/.kube"
if [ ! -f "$HOME/.kube/color.yaml" ]; then
    cat > "$HOME/.kube/color.yaml" << 'EOF'
colors:
  # Optimizado para fondo negro
  info: "cyan"
  success: "green"
  warning: "yellow"
  error: "red"
  debug: "white"
  header: "blue"
  data: "white"
EOF
fi

echo -e "${GREEN}✅ ¡Instalación completada!${NC}"
echo ""
echo -e "${YELLOW}📌 Pasos finales:${NC}"
echo "1. Reinicia tu terminal o ejecuta: source ~/.zshrc"
echo "2. Si usas GNOME Terminal, verifica que la fuente sea 'MesloLGS NF'"
echo "3. Para usar Docker sin sudo: sudo usermod -aG docker \$USER (luego cierra sesión)"
echo ""
echo -e "${GREEN}🎉 ¡Disfruta tu nueva terminal!${NC}"
