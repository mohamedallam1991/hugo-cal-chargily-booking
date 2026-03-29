#!/bin/bash

# Hugo Cal.com Chargily Booking Module Setup Script
# This script helps you set up the module in a new Hugo project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if Hugo is installed
if ! command -v hugo &> /dev/null; then
    print_error "Hugo is not installed. Please install Hugo first:"
    echo "  macOS: brew install hugo"
    echo "  Ubuntu/Debian: sudo apt-get install hugo"
    echo "  Windows: choco install hugo"
    exit 1
fi

# Parse command line arguments
SITE_NAME=""
MODULE_PATH="github.com/mohamedallam1991/hugo-cal-chargily-booking"
CAL_LINK=""
NAMESPACE=""

show_help() {
    echo "Hugo Cal.com Chargily Booking Module Setup"
    echo ""
    echo "Usage: $0 [OPTIONS] <site-name>"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -c, --cal-link <link>   Set Cal.com booking link (default: your-username/event-type)"
    echo "  -n, --namespace <name>   Set Cal.com namespace (default: your-event)"
    echo "  -m, --module <path>     Use custom module path"
    echo ""
    echo "Examples:"
    echo "  $0 my-booking-site"
    echo "  $0 my-booking-site -c mohamedallam/discovery-call -n discovery-call"
    echo "  $0 my-booking-site -m github.com/yourname/your-module"
    echo ""
    echo "This script will:"
    echo "  1. Create a new Hugo site"
    echo "  2. Configure the module"
    echo "  3. Create booking page"
    echo "  4. Start development server"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -c|--cal-link)
            CAL_LINK="$2"
            shift 2
            ;;
        -n|--namespace)
            NAMESPACE="$2"
            shift 2
            ;;
        -m|--module)
            MODULE_PATH="$2"
            shift 2
            ;;
        -*)
            print_error "Unknown option $1"
            show_help
            exit 1
            ;;
        *)
            SITE_NAME="$1"
            ;;
    esac
    shift
done

# Check if site name is provided
if [[ -z "$SITE_NAME" ]]; then
    print_error "Site name is required. Use -h for help."
    exit 1
fi

# Set defaults
if [[ -z "$CAL_LINK" ]]; then
    CAL_LINK="your-username/event-type"
fi

if [[ -z "$NAMESPACE" ]]; then
    NAMESPACE="your-event"
fi

print_status "Setting up Hugo Cal.com Chargily Booking Module for: $SITE_NAME"

# Step 1: Create Hugo site
if [[ -d "$SITE_NAME" ]]; then
    print_warning "Directory $SITE_NAME already exists. Skipping site creation."
    cd "$SITE_NAME"
else
    print_status "Creating Hugo site: $SITE_NAME"
    hugo new site "$SITE_NAME"
    cd "$SITE_NAME"
fi

# Step 2: Create data directory and config
print_status "Creating configuration files"
mkdir -p data

# Create cal_config.yaml
cat > data/cal_config.yaml << EOF
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
  cal_link: "$CAL_LINK"
  namespace: "$NAMESPACE"
  layout: "month_view"
  use_slots_view_on_small_screen: "true"
  hide_event_type_details: false

# Chargily Payment Integration
chargily:
  enabled: true
  api_key: "your-chargily-api-key"
  webhook_secret: "your-webhook-secret"
  currency: "DZD"
EOF

# Step 3: Configure Hugo with module
print_status "Configuring Hugo module"
cat >> hugo.toml << EOF

[module]
  [[module.imports]]
    path = "$MODULE_PATH"
EOF

# Step 4: Create booking page
print_status "Creating booking page"
mkdir -p content

cat > content/consult.md << EOF
---
title: "Book a Consultation"
---

# Book a Consultation

Ready to take your project to the next level? Let's discuss how I can help you achieve your goals.

## What We'll Cover in Our Discovery Call

During our **30-minute consultation**, we'll explore:

- **Your project vision** and current challenges
- **Technical requirements** and best approaches
- **Timeline and budget** considerations
- **How my expertise** can accelerate your success
- **Next steps** to move forward

## Why Book a Consultation?

✅ **No-obligation discussion** - Explore possibilities without commitment  
✅ **Expert insights** - Get professional perspective on your project  
✅ **Clear roadmap** - Understand what it takes to succeed  
✅ **Direct access** - Work with me personally on your vision  

I specialize in helping businesses and individuals transform their ideas into reality through strategic planning and technical execution. Whether you're starting a new project or optimizing an existing one, I'm here to guide you every step of the way.

---

{{< cal-simple >}}

---

_If you have any questions before booking, feel free to [contact me](mailto:your-email@example.com)._
EOF

# Step 5: Create index page
print_status "Creating homepage"
cat > content/_index.md << EOF
---
title: "Welcome to Hugo Cal.com Chargily Booking Module"
---

# Hugo Cal.com Chargily Booking Module

A modular, configurable Cal.com booking system for Hugo static sites with Chargily integration.

## Features

- 🎯 **Multiple Booking Methods**: Embedded calendar, floating button, custom button
- 🔧 **Configuration-Driven**: Easy customization via YAML config
- 📱 **Responsive**: Works on all screen sizes
- 🎨 **Theme-Agnostic**: Compatible with any Hugo theme
- 💳 **Chargily Integration**: Payment processing capabilities

## Quick Test

Try the booking system:

{{< cal-simple >}}

## Configuration

Edit \`data/cal_config.yaml\` to customize your booking settings and Chargily integration.

## Documentation

See the [module documentation](https://github.com/mohamedallam1991/hugo-cal-chargily-booking) for more details.
EOF

# Step 6: Start development server
print_status "Starting development server"
print_status "Site will be available at: http://localhost:1313"
print_status "Booking page will be at: http://localhost:1313/consult/"
print_status ""
print_status "Next steps:"
print_status "1. Update data/cal_config.yaml with your Cal.com settings"
print_status "2. Configure Chargily integration with your API keys"
print_status "3. Customize styling as needed"
print_status "4. Test booking functionality"
print_status ""
print_status "Press Ctrl+C to stop the server"

hugo server --port 1313 --bind 127.0.0.1
