#!/bin/bash

# Hugo Cal.com Chargily Booking Module - One-Click Installation
# This script sets up a complete Hugo site with the booking module and Chargily integration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
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

print_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

print_success() {
    echo -e "${PURPLE}[SUCCESS]${NC} $1"
}

print_header() {
    echo -e "${CYAN}=====================================${NC}"
    echo -e "${CYAN}Hugo Cal.com Chargily Booking${NC}"
    echo -e "${CYAN}One-Click Installation${NC}"
    echo -e "${CYAN}=====================================${NC}"
    echo ""
}

# Check prerequisites
check_prerequisites() {
    print_step "Checking prerequisites..."
    
    # Check Hugo
    if ! command -v hugo &> /dev/null; then
        print_error "Hugo is not installed. Please install Hugo first:"
        echo "  macOS: brew install hugo"
        echo "  Ubuntu/Debian: sudo apt-get install hugo"
        echo "  Windows: choco install hugo"
        echo "  Or visit: https://gohugo.io/installation/"
        exit 1
    else
        local hugo_version=$(hugo version | head -n1 | cut -d' ' -f3)
        print_success "Hugo $hugo_version found ✓"
    fi
    
    # Check Git
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed. Please install Git first."
        exit 1
    else
        print_success "Git found ✓"
    fi
    
    # Check internet connection
    if ! curl -s --head https://github.com > /dev/null; then
        print_error "No internet connection. Please check your network."
        exit 1
    else
        print_success "Internet connection available ✓"
    fi
}

# Parse command line arguments
SITE_NAME=""
MODULE_PATH="github.com/mohamedallam1991/hugo-cal-chargily-booking"
CAL_LINK=""
NAMESPACE=""
PORT="1313"
DEV_MODE=false

show_help() {
    echo "Hugo Cal.com Chargily Booking Module - Installation Script"
    echo ""
    echo "Usage: $0 [OPTIONS] <site-name>"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -c, --cal-link <link>   Set Cal.com booking link"
    echo "  -n, --namespace <name>   Set Cal.com namespace"
    echo "  -m, --module <path>     Use custom module path"
    echo "  -p, --port <port>       Set development port (default: 1313)"
    echo "  -d, --dev-mode          Enable development mode"
    echo ""
    echo "Examples:"
    echo "  $0 my-booking-site"
    echo "  $0 my-booking-site -c mohamedallam/discovery-call"
    echo "  $0 my-booking-site -d -p 1314"
    echo ""
    echo "This script will:"
    echo "  1. Create a complete Hugo site"
    echo "  2. Configure the booking module with Chargily integration"
    echo "  3. Create working templates"
    echo "  4. Set up example content"
    echo "  5. Start development server"
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
        -p|--port)
            PORT="$2"
            shift 2
            ;;
        -d|--dev-mode)
            DEV_MODE=true
            shift
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
    CAL_LINK="demo/demo-event"
fi

if [[ -z "$NAMESPACE" ]]; then
    NAMESPACE="demo"
fi

# Main installation
main() {
    print_header
    
    # Check prerequisites
    check_prerequisites
    
    print_step "Setting up Hugo Cal.com Chargily Booking Module for: $SITE_NAME"
    
    # Step 1: Create Hugo site
    if [[ -d "$SITE_NAME" ]]; then
        print_warning "Directory $SITE_NAME already exists."
        read -p "Do you want to overwrite it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_status "Installation cancelled."
            exit 0
        fi
        rm -rf "$SITE_NAME"
    fi
    
    print_step "Creating Hugo site..."
    hugo new site "$SITE_NAME" --format yaml
    cd "$SITE_NAME"
    print_success "Hugo site created ✓"
    
    # Step 2: Initialize Hugo modules
    print_step "Initializing Hugo modules..."
    hugo mod init github.com/user/$SITE_NAME
    print_success "Hugo modules initialized ✓"
    
    # Step 3: Add the booking module
    print_step "Adding Cal.com Chargily booking module..."
    hugo mod get $MODULE_PATH
    print_success "Booking module added ✓"
    
    # Step 4: Create configuration
    print_step "Creating configuration..."
    mkdir -p data
    
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
    print_success "Configuration created ✓"
    
    # Step 5: Update Hugo configuration
    print_step "Updating Hugo configuration..."
    cat >> hugo.yaml << EOF

# Hugo Cal.com Chargily Booking Module Configuration
module:
  imports:
    - path: $MODULE_PATH

# Site configuration
params:
  description: "A Hugo site with Cal.com booking and Chargily payment integration"
  dev_mode: $DEV_MODE
  features:
    - title: "Multiple Booking Methods"
      description: "Choose from embedded calendar, floating button, or custom button"
    - title: "Easy Configuration"
      description: "Simple YAML configuration for all settings"
    - title: "Responsive Design"
      description: "Works perfectly on all devices"
    - title: "Theme Compatible"
      description: "Works with any Hugo theme"
    - title: "Chargily Integration"
      description: "Algerian payment processing with CIB, Edahabia, and cards"
  cta:
    title: "Ready to get started?"
    description: "Try our booking system with Chargily payment integration."
    link: "/consult/"
    button_text: "Book Now"
  footer_links:
    - name: "Documentation"
      url: "https://github.com/mohamedallam1991/hugo-cal-chargily-booking"
    - name: "Cal.com"
      url: "https://cal.com"
    - name: "Chargily"
      url: "https://chargily.dz"
EOF
    print_success "Hugo configuration updated ✓"
    
    # Step 6: Create content
    print_step "Creating content pages..."
    mkdir -p content
    
    # Homepage
    cat > content/_index.md << EOF
---
title: "Welcome to Hugo Cal.com Chargily Booking"
---

# Hugo Cal.com Chargily Booking Module

A modular, configurable Cal.com booking system for Hugo static sites with Chargily payment integration for the Algerian market.

## Quick Demo

Try the booking system with payment integration below:

{{< cal-simple >}}

## Features

- 🎯 **Multiple Booking Methods**: Embedded calendar, floating button, custom button
- 🔧 **Configuration-Driven**: Easy customization via YAML config
- 📱 **Responsive**: Works on all screen sizes
- 🎨 **Theme-Agnostic**: Compatible with any Hugo theme
- 💳 **Chargily Integration**: Algerian payment processing

## Payment Methods Supported

- **Credit/Debit Cards** - Visa, Mastercard
- **Edahabia** - Algerian electronic wallet
- **CIB** - Algerian interbank system
- **Multi-currency** support

## Next Steps

1. Update \`data/cal_config.yaml\` with your Cal.com settings
2. Configure Chargily integration with your API keys
3. Test the booking and payment flow
4. Deploy to your hosting provider

## Documentation

See the [module documentation](https://github.com/mohamedallam1991/hugo-cal-chargily-booking) for more details and advanced usage.
EOF
    
    # Consultation page
    cat > content/consult.md << EOF
---
title: "Book a Consultation"
---

# Book a Consultation

Ready to take your project to the next level? Let's discuss how I can help you achieve your goals.

## What We'll Cover

During our **30-minute consultation**, we'll explore:

- **Your project vision** and current challenges
- **Technical requirements** and best approaches
- **Timeline and budget** considerations
- **How my expertise** can accelerate your success
- **Next steps** to move forward

## Why Book With Me?

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
    
    print_success "Content pages created ✓"
    
    # Step 7: Create health check page
    print_step "Creating health check page..."
    cat > content/health.md << EOF
---
title: "Health Check"
---

# Hugo Cal.com Chargily Booking Module - Health Check

This page helps verify that the booking module and Chargily integration are working correctly.

## System Status

{{ if .Site.Params.dev_mode }}
<div class="alert alert-info">
    <strong>Development Mode:</strong> Advanced debugging information available in browser console.
</div>
{{ end }}

## Module Components

✅ Hugo Module: Loaded  
✅ Configuration: \`data/cal_config.yaml\`  
✅ Shortcodes: \`cal-simple\` available  
✅ Partials: Booking methods ready  
✅ Chargily Integration: Framework available  

## Test Booking

{{< cal-simple >}}

## Chargily Integration

The Chargily payment framework is ready for configuration:

1. **API Key**: Set your Chargily API key
2. **Webhook Secret**: Configure webhook endpoint
3. **Currency**: Default set to DZD (Algerian Dinar)

## Troubleshooting

If you see booking options above, the module is working correctly!

**Common Issues:**
- No booking options: Check \`data/cal_config.yaml\` configuration
- Cal.com not loading: Verify your Cal.com link and account
- Chargily issues: Check API key and webhook configuration
- Page not found: Check Hugo build logs for errors

## Support

- 📧 [GitHub Issues](https://github.com/mohamedallam1991/hugo-cal-chargily-booking/issues)
- 📖 [Documentation](https://github.com/mohamedallam1991/hugo-cal-chargily-booking)
- 💬 [Discussions](https://github.com/mohamedallam1991/hugo-cal-chargily-booking/discussions)
EOF
    
    print_success "Health check page created ✓"
    
    # Step 8: Final setup
    print_step "Finalizing installation..."
    
    # Create a simple .gitignore
    cat > .gitignore << EOF
# Hugo
public/
resources/_gen/
.hugo_build.lock

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
*.swp
*.swo

# Logs
*.log

# Chargily (keep secret)
.env
chargily-config.*
EOF
    
    print_success "Installation completed! ✓"
    
    # Step 9: Start development server
    echo ""
    print_success "🎉 Installation completed successfully!"
    echo ""
    echo -e "${GREEN}Your Hugo site with Chargily integration is ready:${NC}"
    echo -e "  • Site directory: $(pwd)"
    echo -e "  • Development URL: ${BLUE}http://localhost:$PORT${NC}"
    echo -e "  • Booking page: ${BLUE}http://localhost:$PORT/consult/${NC}"
    echo -e "  • Health check: ${BLUE}http://localhost:$PORT/health/${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Update data/cal_config.yaml with your actual Cal.com settings"
    echo "  2. Configure Chargily API keys and webhook settings"
    echo "  3. Visit the site to test the booking functionality"
    echo "  4. Test the payment flow with Chargily sandbox"
    echo "  5. Customize styling and content as needed"
    echo ""
    echo -e "${CYAN}Starting development server...${NC}"
    echo -e "${YELLOW}Press Ctrl+C to stop the server${NC}"
    echo ""
    
    # Start Hugo server
    hugo server --port $PORT --bind 127.0.0.1
}

# Run main function
main
