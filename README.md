# 🚀 Dotfiles - Terminal Configuration

Configuración personalizada para terminal con soporte para Git, Kubernetes, Docker, AWS y más.

## ✨ Características

- 🎨 **Prompt colorido** optimizado para fondo negro con Starship
- 🔧 **Aliases útiles** para kubectl (k, kg, kd, etc.)
- 🎯 **Oh My Zsh** con plugins:
  - zsh-autosuggestions
  - zsh-syntax-highlighting
  - git, docker, kubectl
- 🔤 **Fuente Nerd Font** (MesloLGS NF) con iconos
- ⚡ **Herramientas DevOps**: git, kubectl, docker, terraform

## 🖼️ Vista Previa

El prompt muestra:
- 👤 Usuario
- 📁 Directorio actual
- 🌿 Rama de Git (con icono )
- ⎈ Contexto de Kubernetes
- ☁️ Región de AWS
- 🐳 Contexto de Docker
- 🕐 Hora actual

## 📦 Instalación Rápida

```bash
git clone https://github.com/xJoaan/shell-configs.git
cd dotfiles
chmod +x install.sh
./install.sh
```

## 🔧 Instalación Manual

Si prefieres instalar manualmente:

1. **Clonar repositorio:**
   ```bash
   git clone https://github.com/TU_USUARIO/dotfiles.git ~/dotfiles
   ```

2. **Copiar archivos:**
   ```bash
   cp ~/dotfiles/.zshrc ~/.zshrc
   mkdir -p ~/.config
   cp ~/dotfiles/starship.toml ~/.config/starship.toml
   ```

3. **Instalar dependencias:**
   ```bash
   # Oh My Zsh
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   
   # Starship
   curl -sS https://starship.rs/install.sh | sh
   
   # Plugins de zsh
   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
   ```

4. **Instalar fuente:**
   ```bash
   mkdir -p ~/.local/share/fonts
   cd ~/.local/share/fonts
   curl -fLo "MesloLGS NF Regular.ttf" https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
   fc-cache -fv
   ```

5. **Configurar fuente en terminal** (GNOME Terminal):
   ```bash
   PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')
   gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ use-system-font false
   gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ font 'MesloLGS NF 11'
   ```

## ⌨️ Aliases de Kubectl

| Alias | Comando |
|-------|---------|
| `k` | kubectl |
| `kg` | kubectl get |
| `kd` | kubectl describe |
| `kdel` | kubectl delete |
| `kl` | kubectl logs |
| `kex` | kubectl exec -it |
| `ka` | kubectl apply -f |
| `kgp` | kubectl get pods |
| `kgs` | kubectl get svc |
| `kgn` | kubectl get nodes |
| `kgd` | kubectl get deployments |
| `kc` | kubectl config |
| `kcc` | kubectl config current-context |
| `kcu` | kubectl config use-context |

## 🎨 Personalización

### Cambiar colores de Starship

Edita `~/.config/starship.toml` y modifica las variables de color:

```toml
[git_branch]
style = "bg:#TU_COLOR fg:black bold"
```

### Agregar más aliases

Edita `~/.zshrc` y agrega tus aliases personalizados en la sección correspondiente.

## 🐛 Problemas Comunes

### No se ven los iconos
- Asegúrate de tener instalada la fuente MesloLGS NF
- Configura tu terminal para usar esta fuente
- Reinicia la terminal

### Los colores se ven mal
- Verifica que tu terminal soporte colores de 24-bit
- Ajusta los colores en `starship.toml` según tu esquema de colores

## 📝 Licencia

MIT

## 🤝 Contribuciones

¡Las contribuciones son bienvenidas! Siéntete libre de abrir issues o pull requests.

## 👨‍💻 Autor

msistudio
