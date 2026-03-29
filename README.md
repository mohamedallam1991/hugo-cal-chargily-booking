# Hugo Cal.com Chargily Booking Module

A modular, configurable Cal.com booking system for Hugo static sites with Chargily integration.

## Features

- 🎯 **Multiple Booking Methods**: Embedded calendar, floating button, custom button
- 🔧 **Configuration-Driven**: Easy customization via YAML config
- 📱 **Responsive**: Works on all screen sizes
- 🎨 **Theme-Agnostic**: Compatible with any Hugo theme
- 🌍 **Multi-Language Ready**: Built-in i18n support
- 💳 **Chargily Integration**: Payment processing capabilities

## Quick Start

### Option 1: Add to Existing Hugo Site

In your existing Hugo site's `hugo.toml`:

```toml
[module]
  [[module.imports]]
    path = "github.com/mohamedallam1991/hugo-cal-chargily-booking"
```

### Option 2: Start New Hugo Project

```bash
# Create new Hugo site
hugo new site my-booking-site

# Add module to hugo.toml
cat >> hugo.toml << 'EOF'
[module]
  [[module.imports]]
    path = "github.com/mohamedallam1991/hugo-cal-chargily-booking"
EOF

# Create booking page
mkdir -p content
cat > content/consult.md << 'EOF'
---
title: "Book a Consultation"
---

{{< cal-simple >}}
EOF

# Start development server
hugo server
```

### Option 3: Clone Example Site

```bash
# Clone this repository
git clone https://github.com/mohamedallam1991/hugo-cal-chargily-booking.git my-booking-site

# Navigate to example
cd my-booking-site/exampleSite

# Start server
hugo server --port 1313
```

## Configuration

Create `data/cal_config.yaml` in your Hugo site:

```yaml
booking_methods:
  embed:
    name: "Embedded Calendar"
    description: "Full calendar embedded in page"
    shortcode: "cal-embed"

  floating:
    name: "Floating Button"
    description: "Floating button in corner"
    shortcode: "cal-floating"

  button:
    name: "Custom Button"
    description: "Styled button with hover effects"
    shortcode: "cal-button"

default_settings:
  cal_link: "your-username/event-type"
  namespace: "your-event"
  layout: "month_view"
  use_slots_view_on_small_screen: "true"
  hide_event_type_details: false

# Chargily Payment Integration
chargily:
  enabled: true
  api_key: "your-chargily-api-key"
  webhook_secret: "your-webhook-secret"
  currency: "DZD"
```

### Configuration Steps

1. **Create data directory** in your Hugo site root
2. **Create cal_config.yaml** file with your settings
3. **Update Cal.com settings** with your actual booking link
4. **Configure Chargily** (optional) with your API keys

## Booking Methods

### Embedded Calendar

- Full 800px height calendar
- Column view layout
- Always visible on page

### Floating Button

- Corner floating button
- Month view layout
- Modal popup experience

### Custom Button

- Styled button with hover effects
- Element-click trigger
- Professional appearance

## Chargily Integration

This module includes Chargily payment processing for Algerian market:

### Payment Flow

1. User selects booking time
2. Redirects to Chargily payment
3. Payment confirmation via webhook
4. Booking confirmation email

### Supported Features

- **Credit/Debit Cards** - Visa, Mastercard
- **Edahabia** - Algerian electronic wallet
- **CIB** - Algerian interbank system
- **Multi-currency** support

## Development and Testing

### Local Development

```bash
# Clone module
git clone https://github.com/mohamedallam1991/hugo-cal-chargily-booking.git

# Navigate to module
cd hugo-cal-chargily-booking

# Start development server
hugo server --port 1314

# Or test example site
cd exampleSite
hugo server --port 1313
```

### Module Structure

```
hugo-cal-chargily-booking/
├── go.mod                    # Go module definition
├── README.md                  # This documentation
├── LICENSE                    # MIT license
├── layouts/
│   ├── shortcodes/
│   │   └── cal-simple.html    # Main booking shortcode
│   └── partials/
│       ├── cal-embed.html       # Individual method partials
│       ├── cal-floating.html
│       └── cal-button.html
├── data/
│   └── cal_config.yaml        # Configuration file
└── exampleSite/
    ├── hugo.toml              # Example Hugo config
    └── content/
        ├── _index.md          # Example homepage
        └── consult.md          # Example booking page
```

### Customization

#### Colors

```yaml
default_settings:
  primary_color: "#667eea"
  hover_color: "#5a67d8"
  text_color: "white"
```

#### Layouts

```yaml
default_settings:
  layout: "month_view" # or "column_view", "week_view"
  height: "800px"
```

#### Multiple Cal.com Links

```yaml
booking_methods:
  consultation:
    name: "Book Consultation"
    cal_link: "user/consultation"

  demo:
    name: "Schedule Demo"
    cal_link: "user/demo"
```

#### Conditional Display

```markdown
{{ if eq .Params.booking_method "floating" }}
{{< cal-floating >}}
{{ else if eq .Params.booking_method "button" }}
{{< cal-button >}}
{{ else }}
{{< cal-embed >}}
{{ end }}
```

## Advanced Usage

### Adding Custom Booking Methods

1. Create new partial in `layouts/partials/your-method.html`
2. Add method to `data/cal_config.yaml`:

```yaml
booking_methods:
  your_method:
    name: "Your Method"
    description: "Your description"
    shortcode: "your-method"
```

3. Update `layouts/shortcodes/cal-simple.html` to include your method

### Theme Integration

The module works with any Hugo theme. For custom styling:

```css
/* Override default styles */
.cal-booking-methods {
  /* Your custom styles */
}

.booking-method {
  /* Your custom styles */
}
```

## Troubleshooting

### Common Issues

#### Module Not Found

```bash
# Clear Hugo cache
hugo --gc

# Rebuild dependencies
hugo mod get -u
```

#### Cal.com Not Loading

- Check your `cal_link` configuration
- Verify Cal.com account and event type
- Check browser console for errors

#### Chargily Integration Issues

- Verify API key and webhook secret
- Check webhook endpoint configuration
- Test with Chargily sandbox first

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Commit changes: `git commit -m 'Add amazing feature'`
5. Push to branch: `git push origin feature/amazing-feature`
6. Submit pull request

## License

MIT License - see LICENSE file for details.

## Support

- 📧 Issues: [GitHub Issues](https://github.com/mohamedallam1991/hugo-cal-chargily-booking/issues)
- 📖 Documentation: [Wiki](https://github.com/mohamedallam1991/hugo-cal-chargily-booking/wiki)
- 💬 Discussions: [GitHub Discussions](https://github.com/mohamedallam1991/hugo-cal-chargily-booking/discussions)

## Changelog

### v1.0.0

- Initial release
- Three booking methods (embedded, floating, custom button)
- Configuration-driven system
- Chargily integration framework
- Comprehensive documentation
- Example site included
