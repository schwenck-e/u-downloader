#!/bin/bash
# u-downloader v1.0.0 - Universal video downloader with professional interface

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; BLUE='\033[0;34m'
CYAN='\033[0;36m'; BOLD='\033[1m'; DIM='\033[2m'; NC='\033[0m'
CHECKMARK="✓"
SPINNER_FRAMES=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
SPINNER_INDEX=0

draw_progress_bar() {
    local percent=$1 bar_width=40 filled=$((percent * bar_width / 100)) bar=""
    for ((i=0; i<bar_width; i++)); do
        if [ $i -lt $filled ]; then
            bar+="█"
        else
            bar+="░"
        fi
    done
    echo -n "$bar"
}

show_completed_step() {
    echo -e "\n${BLUE}[$1/$2]${NC} $(draw_progress_bar 100) ${GREEN}${CHECKMARK}${NC} $3"
}

show_progress_step() {
    local bar=$(draw_progress_bar ${4:-0}) spinner="${SPINNER_FRAMES[$SPINNER_INDEX]}"
    local percent_text=""
    if [ -n "$4" ] && [ "$4" -gt 0 ]; then
        percent_text=" ${DIM}${4}%${NC}"
    fi
    echo -ne "\r\033[K${BLUE}[$1/$2]${NC} ${bar} ${CYAN}${spinner}${NC} $3${percent_text}"
}

update_spinner() { SPINNER_INDEX=$(( (SPINNER_INDEX + 1) % ${#SPINNER_FRAMES[@]} )); }

show_usage() {
    cat << 'EOF'
Uso: ./downloader.sh [opções] <URL>
  -q, --quality <qual>     Qualidade (best, 1080p, 720p, 480p)
  -o, --output <pasta>     Destino (padrão: ~/Downloads)
  -p, --playlist           Baixar playlist inteira
  -a, --audio-only         Apenas áudio (MP3)
  -c, --cookies <browser>  Usar cookies do navegador (safari, chrome, firefox)
  -u, --update             Atualizar yt-dlp para última versão
  -v, --verbose            Saída detalhada
  -h, --help               Ajuda
  
Exemplos:
  ./downloader.sh https://youtube.com/watch?v=VIDEO_ID
  ./downloader.sh -q 1080 -p https://youtube.com/playlist?list=ID
  ./downloader.sh -a https://soundcloud.com/track
  ./downloader.sh --update  # Atualizar yt-dlp
  
Nota: -c requer acesso total ao disco nas Preferências do Sistema
EOF
}

OUTPUT_DIR="$HOME/Downloads"; QUALITY="best"; PLAYLIST=false; AUDIO_ONLY=false; VERBOSE=false; USE_COOKIES=false; BROWSER=""; UPDATE_YTDLP=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -q|--quality) QUALITY="$2"; shift 2 ;;
        -o|--output) OUTPUT_DIR="$2"; shift 2 ;;
        -p|--playlist) PLAYLIST=true; shift ;;
        -a|--audio-only) AUDIO_ONLY=true; shift ;;
        -c|--cookies) USE_COOKIES=true; BROWSER="$2"; shift 2 ;;
        -u|--update) UPDATE_YTDLP=true; shift ;;
        -v|--verbose) VERBOSE=true; shift ;;
        -h|--help) show_usage; exit 0 ;;
        -*) echo -e "${RED}Opção desconhecida: $1${NC}"; show_usage; exit 1 ;;
        *) URL="$1"; shift ;;
    esac
done

# Atualizar yt-dlp se solicitado
if [ "$UPDATE_YTDLP" = true ]; then
    echo -e "${CYAN}${BOLD}Atualizando yt-dlp...${NC}\n"
    
    if command -v yt-dlp &>/dev/null; then
        YTDLP_PATH=$(command -v yt-dlp)
        
        if [[ "$YTDLP_PATH" == *".local/bin/yt-dlp"* ]]; then
            # Instalado manualmente - atualizar via GitHub
            echo "Baixando última versão do GitHub..."
            curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$YTDLP_PATH"
            chmod +x "$YTDLP_PATH"
            echo -e "\n${GREEN}✓ yt-dlp atualizado com sucesso!${NC}"
        else
            # Instalado via Homebrew
            echo "Atualizando via Homebrew..."
            brew upgrade yt-dlp
        fi
        
        VERSION=$(yt-dlp --version)
        echo -e "${GREEN}✓ Versão atual: $VERSION${NC}\n"
    else
        echo -e "${RED}✗ yt-dlp não está instalado${NC}"
        exit 1
    fi
    exit 0
fi

if [ -z "$URL" ]; then
    echo -e "${RED}Erro: URL não fornecida${NC}\n"
    show_usage
    exit 1
fi

# Validação básica de URL
if [[ ! "$URL" =~ ^https?:// ]]; then
    echo -e "${RED}Erro: URL inválida. Deve começar com http:// ou https://${NC}"
    exit 1
fi

# Verificar espaço em disco (avisar se menos de 1GB)
AVAILABLE_SPACE=$(df -k "$OUTPUT_DIR" | tail -1 | awk '{print $4}')
if [ "$AVAILABLE_SPACE" -lt 1048576 ]; then  # 1GB em KB
    SPACE_MB=$((AVAILABLE_SPACE / 1024))
    echo -e "${YELLOW}⚠️  Aviso: Espaço em disco baixo (${SPACE_MB}MB disponíveis)${NC}"
    echo -e "${YELLOW}   Certifique-se de ter espaço suficiente para o download${NC}\n"
fi

# Trap para limpar ao interromper (Ctrl+C)
cleanup() {
    echo -e "\n\n${YELLOW}⚠️  Download cancelado pelo usuário${NC}"
    if [ -n "$YTDL_PID" ] && kill -0 $YTDL_PID 2>/dev/null; then
        kill $YTDL_PID 2>/dev/null
    fi
    [ -f "$TEMP_LOG" ] && rm -f "$TEMP_LOG"
    exit 130
}
trap cleanup INT TERM

echo ""
echo -e "${BOLD}${CYAN}╔════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║          u-downloader v1.0.0           ║${NC}"
echo -e "${BOLD}${CYAN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${DIM}URL:${NC}       ${URL:0:50}..."
echo -e "  ${DIM}Destino:${NC}   $OUTPUT_DIR"
if [ "$AUDIO_ONLY" = true ]; then
    echo -e "  ${DIM}Formato:${NC}   MP3 Audio"
else
    echo -e "  ${DIM}Formato:${NC}   H.264/AAC ${QUALITY}"
fi
if [ "$PLAYLIST" = true ]; then
    echo -e "  ${DIM}Modo:${NC}      Playlist (subpasta automática)"
fi
echo ""

# Marcar início do download
START_TIME=$(date +%s)

show_progress_step 1 7 "Verificando yt-dlp" 50; update_spinner; sleep 0.2
if ! command -v yt-dlp &>/dev/null; then
    echo -e "\n${RED}yt-dlp não instalado!${NC}"
    exit 1
fi
show_progress_step 1 7 "Verificando yt-dlp" 100; show_completed_step 1 7 "yt-dlp encontrado"

show_progress_step 2 7 "Verificando ffmpeg" 50; update_spinner; sleep 0.2
show_progress_step 2 7 "Verificando ffmpeg" 100; show_completed_step 2 7 "ffmpeg encontrado"

show_progress_step 3 7 "Preparando diretório" 50
if [ ! -d "$OUTPUT_DIR" ]; then
    if ! mkdir -p "$OUTPUT_DIR"; then
        echo -e "\n${RED}✗ Erro ao criar diretório: $OUTPUT_DIR${NC}"
        exit 1
    fi
fi
show_progress_step 3 7 "Preparando diretório" 100; show_completed_step 3 7 "Diretório pronto"

show_progress_step 4 7 "Configurando formato" 30; update_spinner

if [ "$PLAYLIST" = true ]; then
    CMD="yt-dlp -o '$OUTPUT_DIR/%(playlist)s/%(title)s.%(ext)s'"
else
    CMD="yt-dlp -o '$OUTPUT_DIR/%(title)s.%(ext)s'"
fi

command -v ffmpeg &>/dev/null && CMD="$CMD --embed-thumbnail --embed-metadata"
if [ "$USE_COOKIES" = true ] && [ -n "$BROWSER" ]; then
    CMD="$CMD --cookies-from-browser $BROWSER"
fi
show_progress_step 4 7 "Configurando formato" 70; update_spinner

if [ "$AUDIO_ONLY" = true ]; then
    CMD="$CMD -x --audio-format mp3 --audio-quality 0"
else
    case $QUALITY in
        best) CMD="$CMD -f 'bestvideo[vcodec^=avc1][ext=mp4]+bestaudio[acodec^=mp4a]/best' --merge-output-format mp4" ;;
        1080|1080p) CMD="$CMD -f 'bestvideo[height<=1080][vcodec^=avc1]+bestaudio[acodec^=mp4a]/best[height<=1080]' --merge-output-format mp4" ;;
        720|720p) CMD="$CMD -f 'bestvideo[height<=720][vcodec^=avc1]+bestaudio[acodec^=mp4a]/best[height<=720]' --merge-output-format mp4" ;;
        480|480p) CMD="$CMD -f 'bestvideo[height<=480][vcodec^=avc1]+bestaudio[acodec^=mp4a]/best[height<=480]' --merge-output-format mp4" ;;
        *) CMD="$CMD -f 'bestvideo[vcodec^=avc1]+bestaudio[acodec^=mp4a]/best' --merge-output-format mp4" ;;
    esac
fi

if [ "$PLAYLIST" = true ]; then
    CMD="$CMD --yes-playlist"
else
    CMD="$CMD --no-playlist"
fi
show_progress_step 4 7 "Configurando formato" 100; show_completed_step 4 7 "Formato configurado"

TEMP_LOG="/tmp/ytdl-$$.log"
> "$TEMP_LOG"

if [ "$VERBOSE" = false ]; then
    CMD="$CMD --newline --no-warnings"
fi

CMD="$CMD '$URL'"

show_progress_step 5 7 "Extraindo informações" 0
eval $CMD > "$TEMP_LOG" 2>&1 & YTDL_PID=$!

STEP5_DONE=false
STEP6_DONE=false
LAST_PERCENT=""

while kill -0 $YTDL_PID 2>/dev/null; do
    update_spinner
    
    if [ ! -f "$TEMP_LOG" ]; then
        sleep 0.3
        continue
    fi
    
    if grep -q "\[download\].*%" "$TEMP_LOG" 2>/dev/null; then
        if [ "$STEP5_DONE" = false ]; then
            show_progress_step 5 7 "Extraindo informações" 100
            show_completed_step 5 7 "Informações extraídas"
            STEP5_DONE=true
        fi
        
        PERCENT=$(grep "\[download\]" "$TEMP_LOG" | tail -1 | grep -o '[0-9]\+%' | head -1 | tr -d '%')
        
        if [ -n "$PERCENT" ] && [ "$PERCENT" != "$LAST_PERCENT" ]; then
            show_progress_step 6 7 "Baixando" "$PERCENT"
            LAST_PERCENT="$PERCENT"
        fi
    fi
    
    if grep -q "\[ExtractAudio\]\|\[Merger\]\|\[Metadata\]" "$TEMP_LOG" 2>/dev/null && [ "$STEP6_DONE" = false ]; then
        if [ "$LAST_PERCENT" != "100" ]; then
            show_progress_step 6 7 "Baixando" 100
        fi
        show_completed_step 6 7 "Download completo"
        STEP6_DONE=true
        show_progress_step 7 7 "Processando" 50
    fi
    
    sleep 0.3
done

wait $YTDL_PID; RESULT=$?

if [ $RESULT -eq 0 ]; then
    if [ "$STEP5_DONE" = false ]; then
        show_progress_step 5 7 "Extraindo" 100
        show_completed_step 5 7 "Informações extraídas"
    fi
    
    if [ "$STEP6_DONE" = false ]; then
        show_progress_step 6 7 "Baixando" 100
        show_completed_step 6 7 "Download completo"
    fi
    
    show_progress_step 7 7 "Processando" 100
    show_completed_step 7 7 "Concluído"
    
    # Calcular tempo total
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    MINUTES=$((DURATION / 60))
    SECONDS=$((DURATION % 60))
    
    echo ""; echo -e "${BOLD}${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${GREEN}║   ✓ Download concluído com sucesso!   ║${NC}"
    echo -e "${BOLD}${GREEN}╚════════════════════════════════════════╝${NC}"; echo ""
    
    if [ "$PLAYLIST" = true ]; then
        PLAYLIST_NAME=$(grep -o "Downloading playlist: .*" "$TEMP_LOG" | head -1 | sed 's/.*Downloading playlist: //')
        if [ -z "$PLAYLIST_NAME" ]; then
            PLAYLIST_NAME=$(grep -o "\[download\] Downloading video .* of .*" "$TEMP_LOG" | head -1 | sed 's/.*of //' | sed 's/ .*//')
        fi
        echo -e "  ${GREEN}${CHECKMARK}${NC} Playlist organizada em:"
        if [ -n "$PLAYLIST_NAME" ]; then
            echo -e "  ${BOLD}$OUTPUT_DIR/$PLAYLIST_NAME/${NC}"
        else
            echo -e "  ${BOLD}$OUTPUT_DIR/[Nome da Playlist]/${NC}"
        fi
    else
        FILENAME=$(grep -o "Destination: .*" "$TEMP_LOG" | tail -1 | sed 's/.*Destination: //')
        if [ -n "$FILENAME" ]; then
            echo -e "  ${GREEN}${CHECKMARK}${NC} Arquivo: ${BOLD}$(basename "$FILENAME")${NC}"
            # Mostrar tamanho do arquivo se existir
            if [ -f "$FILENAME" ]; then
                FILESIZE=$(du -h "$FILENAME" | cut -f1)
                echo -e "  ${GREEN}${CHECKMARK}${NC} Tamanho: ${BOLD}${FILESIZE}${NC}"
            fi
        fi
        echo -e "  ${GREEN}${CHECKMARK}${NC} Local: ${BOLD}$OUTPUT_DIR${NC}"
    fi
    
    # Mostrar tempo total
    if [ $MINUTES -gt 0 ]; then
        echo -e "  ${GREEN}${CHECKMARK}${NC} Tempo: ${BOLD}${MINUTES}m ${SECONDS}s${NC}"
    else
        echo -e "  ${GREEN}${CHECKMARK}${NC} Tempo: ${BOLD}${SECONDS}s${NC}"
    fi
    echo ""
    
    if [ "$VERBOSE" = true ]; then
        echo -e "${DIM}════════════════════${NC}"
        cat "$TEMP_LOG"
        echo -e "${DIM}════════════════════${NC}"
        echo ""
    fi
else
    echo ""
    echo -e "${BOLD}${RED}╔════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${RED}║        ✗ Erro ao baixar vídeo          ║${NC}"
    echo -e "${BOLD}${RED}╚════════════════════════════════════════╝${NC}"
    echo ""
    tail -10 "$TEMP_LOG"
    echo ""
    rm -f "$TEMP_LOG"
    exit 1
fi

rm -f "$TEMP_LOG"
