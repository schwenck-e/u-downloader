# 🔧 Solução de Problemas

## ⚠️ Warning: No supported JavaScript runtime

**Sintoma:**
```
WARNING: [youtube] No supported JavaScript runtime could be found.
```

**Solução:**
Instale o Deno (runtime JavaScript):

```bash
# Via Homebrew (se disponível)
brew install deno

# Ou instalação manual
curl -fsSL https://deno.land/x/install/install.sh | sh

# Adicione ao PATH
echo 'export PATH="$HOME/.deno/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**Nota:** O download ainda funciona sem o Deno, mas alguns formatos podem não estar disponíveis.

---

## ❌ ERROR: Postprocessing: Unable to embed using ffprobe & ffmpeg

**Sintoma:**
```
ERROR: Postprocessing: Unable to embed using ffprobe & ffmpeg; ffprobe not found.
```

**Solução:**
Execute o instalador de dependências:

```bash
./install-dependencies.sh
source ~/.zshrc
```

Ou instale manualmente:
```bash
# Via Homebrew
brew install ffmpeg

# Via instalador manual já fornecido
```

**Workaround:** Se não conseguir instalar o ffmpeg, o vídeo será baixado normalmente, mas a thumbnail ficará em arquivo separado (.webp ou .jpg).

---

## 🔍 yt-dlp não encontrado após instalação

**Sintoma:**
```
yt-dlp: command not found
```

**Solução:**
Atualize o PATH:

```bash
export PATH="$HOME/.local/bin:$PATH"
source ~/.zshrc  # ou source ~/.bash_profile
```

Ou reinicie o terminal.

---

## 📦 Erro "Qualidade não reconhecida"

**Antes (errado):**
```bash
./downloader.sh -q 1080 https://...
```

**Agora (correto):**
```bash
# Ambos funcionam
./downloader.sh -q 1080 https://...
./downloader.sh -q 1080p https://...
```

O script foi atualizado para aceitar ambos os formatos.

---

## 🚫 Erro de permissão ao executar scripts

**Sintoma:**
```
Permission denied
```

**Solução:**
```bash
chmod +x downloader.sh
chmod +x install-dependencies.sh
```

---

## 🌐 Erro de rede durante download

**Sintoma:**
```
ERROR: unable to download video data
```

**Soluções:**

1. Verifique sua conexão de internet
2. Tente novamente (pode ser problema temporário do YouTube)
3. Teste com outro vídeo
4. Atualize o yt-dlp:
   ```bash
   # Via Homebrew
   brew upgrade yt-dlp
   
   # Ou manualmente
   curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o ~/.local/bin/yt-dlp
   chmod +x ~/.local/bin/yt-dlp
   ```

---

## 🎬 Vídeo incompatível com QuickTime Player

**Sintoma:**
```
Este arquivo contém algumas mídias incompatíveis com o QuickTime Player.
```

**Causa:**
O vídeo foi baixado com codec VP9 ou WebM que o QuickTime não suporta.

**Solução:**
O script foi atualizado para baixar apenas vídeos em H.264/AAC (compatível com QuickTime).

**Converter vídeo existente:**
Se você já tem um vídeo incompatível, pode convertê-lo:

```bash
# Instalar ffmpeg se ainda não tiver
./install-dependencies.sh

# Converter o vídeo
ffmpeg -i "video-original.mp4" -c:v libx264 -c:a aac -movflags +faststart "video-compativel.mp4"
```

**Alternativa - Players mais compatíveis:**
- **VLC Media Player** (reproduz qualquer formato)
  ```bash
  brew install --cask vlc
  ```
- **IINA** (player nativo para macOS com suporte a todos os formatos)
  ```bash
  brew install --cask iina
  ```

**Verificar codec do vídeo:**
```bash
ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=noprint_wrappers=1:nokey=1 "seu-video.mp4"
```

Se retornar `vp9` ou `av1`, o QuickTime não vai reproduzir. Se retornar `h264`, deveria funcionar.

---

### Atualizar yt-dlp
```bash
# Via Homebrew
brew upgrade yt-dlp

# Ou manualmente
cd ~/.local/bin
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o yt-dlp
chmod +x yt-dlp
```

### Atualizar ffmpeg
```bash
# Via Homebrew
brew upgrade ffmpeg

# Manualmente: execute o instalador novamente
./install-dependencies.sh
```

---

## 💡 Dicas de Performance

### Downloads lentos
- Use uma qualidade menor: `-q 720` ou `-q 480`
- Verifique sua conexão de internet
- Teste em horários diferentes (servidores do YouTube podem estar ocupados)

### Economizar espaço em disco
- Baixe apenas áudio: `-a`
- Use qualidade menor: `-q 480` ou `-q 360`
- Delete thumbnails separadas após o download

---

## 📞 Ainda tendo problemas?

1. Verifique se está usando a versão mais recente do script
2. Execute com mais detalhes:
   ```bash
   yt-dlp -v <URL>  # modo verbose
   ```
3. Verifique os logs de erro completos
4. Teste o yt-dlp diretamente (sem o script):
   ```bash
   yt-dlp <URL>
   ```
