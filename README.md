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

### 1. Add to your Hugo site

In your `hugo.toml`:

```toml
[module]
  [[module.imports]]
    path = "github.com/mohamedallam1991/hugo-cal-chargily-booking"
```

### 2. Use in your content

```markdown
---
title: "Book a Consultation"
---

{{< cal-simple >}}
```

## Configuration

Create `data/cal-config.yaml` in your Hugo site:

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

## Customization

### Colors

```yaml
default_settings:
  primary_color: "#667eea"
  hover_color: "#5a67d8"
  text_color: "white"
```

### Layouts

```yaml
default_settings:
  layout: "month_view" # or "column_view", "week_view"
  height: "800px"
```

## Advanced Usage

### Multiple Cal.com Links

```yaml
booking_methods:
  consultation:
    name: "Book Consultation"
    cal_link: "user/consultation"

  demo:
    name: "Schedule Demo"
    cal_link: "user/demo"
```

### Conditional Display

```markdown
{{ if eq .Params.booking_method "floating" }}
{{< cal-floating >}}
{{ else if eq .Params.booking_method "button" }}
{{< cal-button >}}
{{ else }}
{{< cal-embed >}}
{{ end }}
```

## Development

### Local Development

```bash
git clone https://github.com/mohamedallam1991/hugo-cal-chargily-booking
cd hugo-cal-chargily-booking
hugo server -s exampleSite
```

### Contributing

1. Fork the repository
2. Create feature branch
3. Make your changes
4. Submit pull request

## License

MIT License - see LICENSE file for details.

## Support

- 📧 Issues: [GitHub Issues](https://github.com/mohamedallam1991/hugo-cal-chargily-booking/issues)
- 📖 Documentation: [Wiki](https://github.com/mohamedallam1991/hugo-cal-chargily-booking/wiki)
- 💬 Discussions: [GitHub Discussions](https://github.com/mohamedallam1991/hugo-cal-chargily-booking/discussions)
