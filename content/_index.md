---
title: "Hugo Cal.com Chargily Booking Module"
---

# Hugo Cal.com Chargily Booking Module

A modular, configurable Cal.com booking system for Hugo static sites with Chargily integration.

## Quick Test

Below is a test of the booking module:

{{< cal-simple >}}

## Features

- 🎯 **Multiple Booking Methods**: Embedded calendar, floating button, custom button
- 🔧 **Configuration-Driven**: Easy customization via YAML config
- 📱 **Responsive**: Works on all screen sizes
- 🎨 **Theme-Agnostic**: Compatible with any Hugo theme
- 💳 **Chargily Integration**: Payment processing capabilities

## Configuration

The module uses `data/cal-config.yaml` for configuration. You can customize:

- Booking methods
- Cal.com integration
- Chargily payment settings
- Visual styling

## Usage

Add this module to your Hugo site:

```toml
[module]
  [[module.imports]]
    path = "github.com/mohamedallam1991/hugo-cal-chargily-booking"
```

Then use the shortcode in your content:

```markdown
{{< cal-simple >}}
```
