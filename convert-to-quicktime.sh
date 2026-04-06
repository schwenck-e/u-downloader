#!/bin/bash

# Script para converter vídeos para formato compatível com QuickTime
# Converte para H.264/AAC

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

if [ $# -eq 0 ]; then
    echo -e "${RED}Uso: $0 <arquivo-video>${NC}"
    echo ""
    echo "Exemplos:"
    echo "  $0 video.mp4"
    echo "  $0 video.webm"
    exit 1
fi

INPUT="$1"
OUTPUT="${INPUT%.*}-quicktime.mp4"

if [ ! -f "$INPUT" ]; then
    echo -e "${RED}Erro: Arquivo '$INPUT' não encontrado${NC}"
    exit 1
fi

if ! command -v ffmpeg &> /dev/null; then
    echo -e "${RED}ffmpeg não está instalado!${NC}"
    echo "Execute: ./install-dependencies.sh"
    exit 1
fi

echo -e "${GREEN}==================================${NC}"
echo -e "${GREEN}Conversor para QuickTime${NC}"
echo -e "${GREEN}==================================${NC}"
echo "Entrada: $INPUT"
echo "Saída: $OUTPUT"
echo -e "${GREEN}==================================${NC}\n"

echo -e "${YELLOW}Convertendo para H.264/AAC...${NC}\n"

ffmpeg -i "$INPUT" \
    -c:v libx264 \
    -preset medium \
    -crf 23 \
    -c:a aac \
    -b:a 192k \
    -movflags +faststart \
    "$OUTPUT"

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}✓ Conversão concluída!${NC}"
    echo -e "${GREEN}Arquivo salvo: $OUTPUT${NC}"
    echo -e "\n${YELLOW}O arquivo original foi preservado.${NC}"
else
    echo -e "\n${RED}✗ Erro na conversão${NC}"
    exit 1
fi
