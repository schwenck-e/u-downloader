# u-downloader v1.0.0

Universal cross-platform video downloader supporting **1872+ sites**.

## ✨ Features

- 🌐 **1872+ sites supported** (YouTube, Vimeo, Instagram, TikTok, Facebook, Twitch, and more)
- 💻 **Cross-platform** (Linux, macOS, BSD, WSL)
- ⚡ **Professional progress bars** (Docker-style with real-time animations)
- 📁 **Smart playlist organization** (automatic subfolder creation)
- 🎵 **Audio extraction** (MP3 format)
- 🔒 **Privacy-first** (optional browser cookie support)
- ✅ **Smart validation** (URL format check, disk space verification)
- 🛡️ **Graceful interruption** (Ctrl+C with automatic cleanup)
- 🔄 **Auto-updater** (built-in yt-dlp update functionality)
- 📊 **Download statistics** (time, file size, progress tracking)

## 📦 Installation

### Linux (Debian/Ubuntu)
```bash
sudo apt update && sudo apt install python3-pip ffmpeg curl
pip3 install yt-dlp
git clone https://github.com/schwenck-e/u-downloader.git
cd u-downloader && chmod +x downloader.sh
```

### Linux (Arch)
```bash
sudo pacman -S yt-dlp ffmpeg curl git
git clone https://github.com/schwenck-e/u-downloader.git
cd u-downloader && chmod +x downloader.sh
```

### macOS (Homebrew)
```bash
brew install yt-dlp ffmpeg
git clone https://github.com/schwenck-e/u-downloader.git
cd u-downloader && chmod +x downloader.sh
```

### BSD (FreeBSD)
```bash
pkg install yt-dlp ffmpeg git
git clone https://github.com/schwenck-e/u-downloader.git
cd u-downloader && chmod +x downloader.sh
```

## 🚀 Quick Start

```bash
# Download a video
./downloader.sh https://youtube.com/watch?v=VIDEO_ID

# Download in specific quality (1080p)
./downloader.sh -q 1080 https://vimeo.com/VIDEO_ID

# Extract audio only (MP3)
./downloader.sh -a https://soundcloud.com/track

# Download entire playlist
./downloader.sh -p https://youtube.com/playlist?list=PLAYLIST_ID

# Custom output directory
./downloader.sh -o ~/Videos https://youtube.com/watch?v=VIDEO_ID

# Update yt-dlp
./downloader.sh --update
```

## 📚 Documentation

- 📖 **[User Guide & Documentation](https://schwenck-e.github.io/u-downloader/)** - Complete interactive documentation
- 🔧 **[Troubleshooting Guide](https://github.com/schwenck-e/u-downloader/blob/develop/TROUBLESHOOTING.md)** - Common issues and solutions
- 📝 **[Changelog](https://github.com/schwenck-e/u-downloader/blob/develop/CHANGELOG.md)** - Version history

## 📄 What's Included

- `downloader.sh` - Main download script (334 lines)
- `install-dependencies.sh` - Automated dependency installer
- `convert-to-quicktime.sh` - QuickTime format converter for macOS
- `README.md` - Complete documentation
- `TROUBLESHOOTING.md` - Problem-solving guide
- `CHANGELOG.md` - Version history
- `LICENSE` - MIT License
- `docs/` - Professional GitHub Pages site

## 🌐 Supported Sites

This tool supports **1872+ sites** including:

YouTube, Vimeo, Instagram, TikTok, Facebook, Twitch, Twitter, Reddit, SoundCloud, Dailymotion, Bandcamp, and many more.

**Full list:** https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md

## 🎯 Command Options

| Option | Description |
|--------|-------------|
| `-q, --quality` | Video quality (best, 1080p, 720p, 480p) |
| `-o, --output` | Output directory (default: ~/Downloads) |
| `-p, --playlist` | Download entire playlist |
| `-a, --audio-only` | Extract audio only (MP3) |
| `-c, --cookies` | Use browser cookies (safari, chrome, firefox) |
| `-u, --update` | Update yt-dlp to latest version |
| `-v, --verbose` | Show detailed output |
| `-h, --help` | Show help message |

## 🛠️ Technical Details

- **Language:** Bash 3.2+ (POSIX-compliant)
- **Dependencies:** yt-dlp, ffmpeg, ffprobe
- **License:** MIT
- **Platforms:** Linux, macOS, BSD, WSL
- **Size:** ~12KB (downloader.sh)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## 📄 License

Released under the MIT License. See [LICENSE](https://github.com/schwenck-e/u-downloader/blob/develop/LICENSE) for details.

---

Visit our documentation site: https://schwenck-e.github.io/u-downloader/
