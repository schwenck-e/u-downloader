# u-downloader

Universal cross-platform video downloader supporting **1872+ sites** including YouTube, Vimeo, Instagram, TikTok, Facebook, Twitch and more.

**Compatible with:** Linux, macOS, BSD, WSL

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20BSD-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

## 🌐 Sites Suportados

Este script utiliza o **yt-dlp**, que suporta mais de 1872 sites! Alguns dos mais populares:

**Vídeo & Streaming:**
- YouTube, Vimeo, Dailymotion
- Facebook, Instagram, TikTok, Twitter/X
- Twitch, Reddit, 9gag

**Educação:**
- Coursera, Udemy, Khan Academy
- Academic Earth
- LinkedIn Learning

**Música:**
- SoundCloud, Bandcamp, Mixcloud
- Spotify (com autenticação)

📋 **Ver lista completa:** `~/.local/bin/yt-dlp --list-extractors`

## 📋 Pré-requisitos

Você precisa instalar o yt-dlp, ffmpeg e deno. Escolha o método para seu sistema operacional:

### Linux

**Debian/Ubuntu:**
```bash
sudo apt update
sudo apt install python3-pip ffmpeg curl
pip3 install yt-dlp
curl -fsSL https://deno.land/install.sh | sh
```

**Fedora/RHEL:**
```bash
sudo dnf install python3-pip ffmpeg curl
pip3 install yt-dlp
curl -fsSL https://deno.land/install.sh | sh
```

**Arch Linux:**
```bash
sudo pacman -S yt-dlp ffmpeg curl deno
```

### macOS

**Opção 1: Instalador Automático (Recomendado para macOS 12)**
```bash
chmod +x install-dependencies.sh
./install-dependencies.sh
source ~/.zshrc  # ou source ~/.bash_profile
```

**O instalador agora inclui:**
- ✅ yt-dlp (downloader)
- ✅ ffmpeg & ffprobe (processamento de vídeo)
- ✅ deno (JavaScript runtime - elimina warnings)

**Opção 2: Via Homebrew (se disponível)**
```bash
brew install yt-dlp ffmpeg deno
```

**Nota:** Se você está no macOS 12 e o Homebrew apresentar erros relacionados ao Xcode, use a Opção 1.

## 🚀 Instalação

1. Torne o script executável:
```bash
chmod +x downloader.sh
```

2. (Opcional) Crie um alias no seu `.zshrc` ou `.bash_profile`:
```bash
echo 'alias ytdl="~/Documents/projects/downloader/downloader.sh"' >> ~/.zshrc
source ~/.zshrc
```

## 💻 Uso

### Sintaxe básica
```bash
./downloader.sh [opções] <URL_DO_VIDEO>
```

### Opções disponíveis

| Opção | Descrição |
|-------|-----------|
| `-q, --quality` | Qualidade do vídeo: `best`, `1080`/`1080p`, `720`/`720p`, `480`/`480p` |
| `-o, --output` | Pasta de destino (padrão: ~/Downloads) |
| `-p, --playlist` | Baixar playlist inteira (cria subpasta automática) |
| `-a, --audio-only` | Baixar apenas áudio em MP3 |
| `-c, --cookies` | Usar cookies do navegador: `safari`, `chrome`, `firefox` (requer permissões) |
| `-u, --update` | Atualizar yt-dlp para a última versão |
| `-v, --verbose` | Mostrar saída detalhada |
| `-h, --help` | Mostrar ajuda |

## 📖 Exemplos

### Baixar um vídeo do YouTube com melhor qualidade
```bash
./downloader.sh https://www.youtube.com/watch?v=VIDEO_ID
```

### Baixar vídeo de outros sites
```bash
# Vimeo
./downloader.sh https://vimeo.com/123456789

# TikTok
./downloader.sh https://tiktok.com/@user/video/ID

# Instagram
./downloader.sh https://instagram.com/p/POST_ID/

# Twitch VOD
./downloader.sh https://twitch.tv/videos/VIDEO_ID

# Facebook
./downloader.sh https://facebook.com/watch/?v=VIDEO_ID
```

### Baixar em 720p ou 1080p
```bash
./downloader.sh -q 720p https://www.youtube.com/watch?v=VIDEO_ID
./downloader.sh -q 1080 https://vimeo.com/VIDEO_ID
```

### Baixar apenas áudio (MP3)
```bash
./downloader.sh -a https://www.youtube.com/watch?v=VIDEO_ID
./downloader.sh -a https://soundcloud.com/artist/track
```

### Baixar playlist completa (cria subpasta automática)
```bash
./downloader.sh -p https://www.youtube.com/playlist?list=PLAYLIST_ID
```
**Resultado:** Cria `~/Downloads/Nome da Playlist/` com todos os vídeos organizados

### Baixar playlist em MP3
```bash
./downloader.sh -p -a https://www.youtube.com/playlist?list=PLAYLIST_ID
```

### Usar cookies do navegador (para vídeos privados/bloqueados)
```bash
./downloader.sh -c chrome https://www.youtube.com/watch?v=VIDEO_ID
./downloader.sh -c safari https://instagram.com/p/POST_ID/
```
**Nota:** Requer dar permissão "Acesso Total ao Disco" ao Terminal em Preferências do Sistema > Privacidade
Use apenas se encontrar erro "confirme que não é um robô"

### Combinar opções
```bash
# Playlist do Vimeo em 1080p
./downloader.sh -p -q 1080 https://vimeo.com/showcase/PLAYLIST_ID

# Áudio de playlist do SoundCloud
./downloader.sh -p -a https://soundcloud.com/user/sets/playlist
```

### Atualizar yt-dlp
```bash
./downloader.sh --update
```
Atualiza o yt-dlp automaticamente para a última versão disponível.

### Salvar em pasta específica
```bash
./downloader.sh -o ~/Vídeos/YouTube https://www.youtube.com/watch?v=VIDEO_ID
```

### Combinar opções
```bash
./downloader.sh -q 1080p -o ~/Vídeos https://www.youtube.com/watch?v=VIDEO_ID
```

## 🎯 Recursos

- ✅ **Cross-platform** - Linux, macOS, BSD, WSL
- ✅ **Suporte universal**
- ✅ **Interface moderna**
- ✅ **Validações inteligentes** - Verifica URL e espaço em disco
- ✅ Download de vídeos em múltiplas qualidades
- ✅ **Compatível com QuickTime Player** (usa H.264/AAC)
- ✅ **Playlists organizadas** em subpastas automáticas
- ✅ Extração de áudio em MP3
- ✅ **Autenticação opcional** via cookies do navegador
- ✅ **Atualização automática** do yt-dlp integrada
- ✅ **Informações detalhadas** - Tempo e tamanho do download
- ✅ **Tratamento de interrupção** - Limpeza automática ao cancelar (Ctrl+C)
- ✅ Metadados e thumbnails embutidos
- ✅ **Status visual** de cada etapa do processo
- ✅ Verificação automática de dependências
- ✅ Sem warnings do JavaScript runtime (Deno incluído)

## ⚠️ Limitações

- Sites com DRM (proteção antipirataria) podem não funcionar
- Alguns sites requerem autenticação via cookies (`-c chrome`)
- A qualidade disponível varia por site

## 💡 Dicas

- Use `-v` para ver detalhes do processo e diagnosticar problemas
- Para vídeos privados/protegidos, use `-c chrome` ou `-c safari`
- Se um site não funcionar, verifique se está na lista: `~/.local/bin/yt-dlp --list-extractors`
- Para ver formatos disponíveis de um vídeo: `~/.local/bin/yt-dlp -F URL`
- Alguns sites podem bloquear downloads em massa - use com moderação

## 🔧 Solução de problemas

### Erro: "yt-dlp não está instalado"
```bash
brew install yt-dlp
```

### Erro: "ffmpeg não está instalado"
```bash
brew install ffmpeg
```

### Atualizar yt-dlp para versão mais recente
```bash
brew upgrade yt-dlp
```

## ⚠️ Avisos legais

- Use este script apenas para baixar conteúdo que você tem permissão para baixar
- Respeite os direitos autorais e os termos de serviço dos sites
- O uso inadequado é de sua responsabilidade
- Este script é apenas para uso pessoal e educacional

## 📝 Licença

Este script é fornecido "como está", sem garantias de qualquer tipo.
