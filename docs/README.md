# u-downloader Documentation Site

This is the source code for the u-downloader GitHub Pages documentation website.

## Structure

```
docs/
├── index.html      # Main landing page
├── styles.css      # Stylesheet
├── script.js       # Interactive functionality
└── README.md       # This file
```

## Features

- **Modern Design**: Clean, professional interface with dark theme
- **Responsive**: Works perfectly on desktop, tablet, and mobile
- **Interactive**: Tab switching, copy-to-clipboard, smooth scrolling
- **Fast**: No build step required, vanilla HTML/CSS/JS
- **Accessible**: Semantic HTML and ARIA labels

## Local Development

To preview the site locally:

```bash
cd docs
python3 -m http.server 8000
```

Then open http://localhost:8000 in your browser.

## Deployment

The site is automatically deployed to GitHub Pages from the `docs/` folder in the `develop` branch.

Visit: https://schwenck-e.github.io/u-downloader/

## Technologies

- HTML5
- CSS3 (with CSS Grid and Flexbox)
- Vanilla JavaScript (ES6+)
- Google Fonts (Inter)

## License

MIT License - see LICENSE file in repository root.
