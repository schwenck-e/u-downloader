#!/bin/bash

# Script para instalar yt-dlp e ffmpeg sem depender do Homebrew
# Compatível com macOS 12

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

INSTALL_DIR="$HOME/.local/bin"

echo -e "${GREEN}==================================${NC}"
echo -e "${GREEN}Instalador de Dependências${NC}"
echo -e "${GREEN}YouTube Downloader${NC}"
echo -e "${GREEN}==================================${NC}\n"

# Criar diretório de instalação
mkdir -p "$INSTALL_DIR"

# Instalar yt-dlp
echo -e "${YELLOW}[1/4] Instalando yt-dlp...${NC}"
if command -v yt-dlp &> /dev/null; then
    echo -e "${GREEN}      ✓ yt-dlp já está instalado!${NC}"
else
    curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$INSTALL_DIR/yt-dlp"
    chmod +x "$INSTALL_DIR/yt-dlp"
    echo -e "${GREEN}      ✓ yt-dlp instalado com sucesso!${NC}"
fi

# Instalar ffmpeg e ffprobe
echo -e "\n${YELLOW}[2/4] Instalando ffmpeg e ffprobe...${NC}"
if command -v ffmpeg &> /dev/null && command -v ffprobe &> /dev/null; then
    echo -e "${GREEN}      ✓ ffmpeg e ffprobe já estão instalados!${NC}"
else
    echo -e "      → Baixando ffmpeg..."
    
    # Baixar ffmpeg
    cd /tmp
    curl -sL "https://evermeet.cx/ffmpeg/getrelease/ffmpeg/zip" -o ffmpeg.zip
    unzip -q -o ffmpeg.zip
    mv ffmpeg "$INSTALL_DIR/" 2>/dev/null || true
    chmod +x "$INSTALL_DIR/ffmpeg"
    rm -f ffmpeg.zip
    echo -e "${GREEN}      ✓ ffmpeg instalado${NC}"
    
    echo -e "      → Baixando ffprobe..."
    
    # Baixar ffprobe
    curl -sL "https://evermeet.cx/ffmpeg/getrelease/ffprobe/zip" -o ffprobe.zip
    unzip -q -o ffprobe.zip
    mv ffprobe "$INSTALL_DIR/" 2>/dev/null || true
    chmod +x "$INSTALL_DIR/ffprobe"
    rm -f ffprobe.zip
    echo -e "${GREEN}      ✓ ffprobe instalado${NC}"
fi

# Adicionar ao PATH se necessário
echo -e "\n${YELLOW}Configurando PATH...${NC}"

SHELL_RC=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bash_profile" ]; then
    SHELL_RC="$HOME/.bash_profile"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q "$INSTALL_DIR" "$SHELL_RC"; then
        echo "" >> "$SHELL_RC"
        echo "# Adicionado pelo YouTube Downloader" >> "$SHELL_RC"
        echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$SHELL_RC"
        
        # Adicionar também o diretório do Deno se existir
        if [ -d "$HOME/.deno/bin" ] && ! grep -q ".deno/bin" "$SHELL_RC"; then
            echo "export PATH=\"\$HOME/.deno/bin:\$PATH\"" >> "$SHELL_RC"
        fi
        
        echo -e "${GREEN}      ✓ PATH configurado em $SHELL_RC${NC}"
        echo -e "${YELLOW}      Execute: source $SHELL_RC${NC}"
    else
        echo -e "${GREEN}      PATH já está configurado!${NC}"
    fi
fi

# Adicionar ao PATH da sessão atual
export PATH="$INSTALL_DIR:$PATH"

# Instalar Deno (JavaScript runtime)
echo -e "\n${YELLOW}[3/4] Instalando Deno (JavaScript runtime)...${NC}"
if command -v deno &> /dev/null; then
    echo -e "${GREEN}      ✓ Deno já está instalado!${NC}"
else
    echo -e "      → Baixando Deno..."
    curl -fsSL https://deno.land/x/install/install.sh | sh > /dev/null 2>&1
    
    # Mover para o diretório de instalação
    if [ -f "$HOME/.deno/bin/deno" ]; then
        cp "$HOME/.deno/bin/deno" "$INSTALL_DIR/"
        chmod +x "$INSTALL_DIR/deno"
        echo -e "${GREEN}      ✓ Deno instalado com sucesso!${NC}"
    else
        echo -e "${YELLOW}      ⚠ Deno instalado em ~/.deno/bin (adicione ao PATH)${NC}"
    fi
fi

# Verificar instalação
echo -e "\n${YELLOW}[4/4] Verificando instalação...${NC}"

if "$INSTALL_DIR/yt-dlp" --version &> /dev/null; then
    YT_VERSION=$("$INSTALL_DIR/yt-dlp" --version)
    echo -e "${GREEN}      ✓ yt-dlp: $YT_VERSION${NC}"
else
    echo -e "${RED}      ✗ yt-dlp: Erro na instalação${NC}"
fi

if "$INSTALL_DIR/ffmpeg" -version &> /dev/null 2>&1; then
    FFMPEG_VERSION=$("$INSTALL_DIR/ffmpeg" -version 2>&1 | head -n1 | cut -d' ' -f3)
    echo -e "${GREEN}      ✓ ffmpeg: $FFMPEG_VERSION${NC}"
else
    echo -e "${RED}      ✗ ffmpeg: Erro na instalação${NC}"
fi

if "$INSTALL_DIR/ffprobe" -version &> /dev/null 2>&1; then
    FFPROBE_VERSION=$("$INSTALL_DIR/ffprobe" -version 2>&1 | head -n1 | cut -d' ' -f3)
    echo -e "${GREEN}      ✓ ffprobe: $FFPROBE_VERSION${NC}"
else
    echo -e "${RED}      ✗ ffprobe: Erro na instalação${NC}"
fi

if command -v deno &> /dev/null || [ -f "$INSTALL_DIR/deno" ]; then
    if [ -f "$INSTALL_DIR/deno" ]; then
        DENO_VERSION=$("$INSTALL_DIR/deno" --version 2>&1 | head -n1 | cut -d' ' -f2)
    else
        DENO_VERSION=$(deno --version 2>&1 | head -n1 | cut -d' ' -f2)
    fi
    echo -e "${GREEN}      ✓ deno: $DENO_VERSION${NC}"
else
    echo -e "${YELLOW}      ⚠ deno: Não encontrado no PATH${NC}"
fi

echo -e "\n${GREEN}==================================${NC}"
echo -e "${GREEN}Instalação concluída!${NC}"
echo -e "${GREEN}==================================${NC}"
echo -e "\n${YELLOW}Para começar a usar agora, execute:${NC}"
echo -e "${YELLOW}export PATH=\"$INSTALL_DIR:\$PATH\"${NC}"
echo -e "\n${YELLOW}Ou abra um novo terminal.${NC}\n"
