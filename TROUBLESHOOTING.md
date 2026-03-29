# Hugo Cal.com Booking Module - Troubleshooting Guide

This guide helps you resolve common issues when setting up and using the Hugo Cal.com Booking Module.

## Quick Diagnosis

### Health Check
Visit `/health/` on your site to see a diagnostic page.

### Development Mode
Enable development mode in your `hugo.yaml`:
```yaml
params:
  dev_mode: true
```
Then check the browser console for detailed debugging information.

## Common Issues

### 1. "Page Not Found" Errors

**Problem**: Hugo shows 404 errors despite successful build reports.

**Causes & Solutions:**

#### Missing Base Templates
**Symptoms**: Pages build but show 404 when accessed
```bash
# Check if templates exist
ls layouts/_default/baseof.html
```

**Solution**: The module now includes complete fallback templates. If you're still getting 404s:

```bash
# Clear Hugo cache
hugo --gc

# Rebuild dependencies
hugo mod get -u

# Check template paths
hugo config | grep -i template
```

#### Incorrect Module Configuration
**Symptoms**: Module not loading, templates missing
```yaml
# Check your hugo.yaml
module:
  imports:
    - path: github.com/mohamedallam1991/hugo-cal-booking
```

**Solution**: Ensure the module is properly imported:
```bash
# Re-initialize modules
hugo mod clean
hugo mod get github.com/mohamedallam1991/hugo-cal-booking
```

### 2. Cal.com Not Loading

**Problem**: Booking methods show but Cal.com calendar doesn't load.

**Causes & Solutions:**

#### Incorrect Cal.com Link
**Symptoms**: Booking buttons appear but no calendar loads
```yaml
# Check your data/cal_config.yaml
default_settings:
  cal_link: "your-username/event-type"  # ← This needs to be real
```

**Solution**: Update with your actual Cal.com details:
1. Go to [Cal.com](https://cal.com) and get your event link
2. Update `data/cal_config.yaml`:
```yaml
default_settings:
  cal_link: "your-username/your-event-type"
  namespace: "your-event"
```

#### JavaScript Errors
**Symptoms**: Console shows JavaScript errors
```bash
# Check browser console for errors
# Common error: "Cal is not defined"
```

**Solution**: Ensure Cal.com script loads correctly:
1. Check internet connection
2. Verify Cal.com event exists
3. Check for ad blockers blocking the script

#### CORS Issues
**Symptoms**: Network errors in browser console
```bash
# Error: "CORS policy" or "Network error"
```

**Solution**: Cal.com handles CORS automatically. If you get CORS errors:
1. Check if Cal.com is accessible in your region
2. Try a different browser
3. Disable VPN if using one

### 3. Module Import Issues

**Problem**: Hugo can't find or import the module.

**Causes & Solutions:**

#### Module Not Found
**Symptoms**: Build error "module not found"
```bash
Error: module "github.com/mohamedallam1991/hugo-cal-booking" not found
```

**Solution**: Check internet connection and module path:
```bash
# Test internet connection
curl -I https://github.com/mohamedallam1991/hugo-cal-booking

# Clear module cache
hugo mod clean

# Re-download module
hugo mod get github.com/mohamedallam1991/hugo-cal-booking
```

#### Go Modules Issues
**Symptoms**: Go-related errors during Hugo build
```bash
Error: go mod download failed
```

**Solution**: Update Go and clear Go module cache:
```bash
# Update Go modules
go clean -modcache
go mod download

# Rebuild Hugo dependencies
hugo mod get -u ./...
```

### 4. Template Rendering Issues

**Problem**: Templates don't render correctly or show raw shortcode.

**Causes & Solutions:**

#### Shortcode Not Recognized
**Symptoms**: Shows `{{< cal-simple >}}` as text
```markdown
# Instead of booking form, you see:
{{< cal-simple >}}
```

**Solution**: Check shortcode availability:
```bash
# List available shortcodes
hugo list shortcodes

# Check if cal-simple is in the list
hugo list shortcodes | grep cal-simple
```

If not found, reimport the module:
```bash
hugo mod get github.com/mohamedallam1991/hugo-cal-booking
```

#### Configuration Not Loaded
**Symptoms**: Booking methods show but are empty
```yaml
# Check if data file exists
ls data/cal_config.yaml
```

**Solution**: Ensure configuration file exists and is valid:
```bash
# Validate YAML syntax
python -c "import yaml; yaml.safe_load(open('data/cal_config.yaml'))"

# Recreate if needed
mkdir -p data
cat > data/cal_config.yaml << 'EOF'
booking_methods:
  embed:
    name: "Embedded Calendar"
    description: "Full calendar embedded in page"
    shortcode: "cal-embed"

default_settings:
  cal_link: "demo/demo-event"
  namespace: "demo"
  layout: "month_view"
  use_slots_view_on_small_screen: "true"
  hide_event_type_details: false
EOF
```

### 5. Styling Issues

**Problem**: Booking forms don't look right or have no styling.

**Causes & Solutions:**

#### Missing CSS
**Symptoms**: Booking methods look unstyled
```css
/* Add custom CSS to your site */
.cal-booking-methods {
  display: grid;
  gap: 1rem;
}

.booking-method {
  border: 1px solid #e2e8f0;
  padding: 1.5rem;
  border-radius: 8px;
}
```

#### Theme Conflicts
**Symptoms**: Styling is broken or overridden by theme
```bash
# Check for CSS conflicts
# Use browser dev tools to inspect elements
```

**Solution**: Add more specific CSS or use !important:
```css
.cal-booking-methods {
  display: grid !important;
  gap: 1rem !important;
}
```

## Advanced Troubleshooting

### Debug Mode

Enable detailed debugging in your `hugo.yaml`:
```yaml
params:
  dev_mode: true
  debug:
    log_level: "debug"
    show_template_info: true
```

Then check browser console for detailed information.

### Template Debugging

Check which templates are being used:
```bash
# Build with verbose output
hugo --verbose

# Check template paths
hugo config | grep -A 10 "dirs"
```

### Module Debugging

Check module status:
```bash
# List all modules
hugo mod list

# Show module graph
hugo mod graph

# Check vendor directory
ls -la hugo_modules/
```

## Performance Issues

### Slow Loading

**Problem**: Booking forms load slowly.

**Solutions:**
1. **Lazy Load Cal.com Script**:
```javascript
// Add to your site's JavaScript
window.addEventListener('load', function() {
  // Cal.com script loads automatically
});
```

2. **Optimize Images**: Use WebP format
3. **Minify CSS/JS**: Enable Hugo's minification
```yaml
# In hugo.yaml
minify:
  minifyOutput: true
```

### Memory Issues

**Problem**: Hugo build uses too much memory.

**Solutions:**
```bash
# Limit memory usage
hugo --memoryLimit 256MiB

# Use fewer workers
hugo --workers 1
```

## Environment-Specific Issues

### Windows

**Common Issues:**
- Path separators (use `/` not `\`)
- Line endings (use LF not CRLF)
- Permissions issues

**Solutions:**
```bash
# Use Git Bash or WSL
# Ensure line endings are LF
git config --global core.autocrlf false
```

### macOS

**Common Issues:**
- SIP blocking file access
- Xcode command line tools needed

**Solutions:**
```bash
# Install Xcode tools
xcode-select --install

# Check permissions
ls -la data/cal_config.yaml
```

### Linux

**Common Issues:**
- Package manager versions
- Permission denied errors

**Solutions:**
```bash
# Use package manager for Hugo
sudo apt-get install hugo  # Ubuntu/Debian
sudo dnf install hugo      # Fedora

# Check file permissions
chmod 644 data/cal_config.yaml
```

## Getting Help

### Before Asking for Help

1. **Check the health page**: Visit `/health/` on your site
2. **Enable debug mode**: Set `dev_mode: true` in config
3. **Check browser console**: Look for JavaScript errors
4. **Verify configuration**: Check `data/cal_config.yaml`
5. **Test with default config**: Use demo settings first

### Where to Get Help

1. **GitHub Issues**: [Create an issue](https://github.com/mohamedallam1991/hugo-cal-booking/issues)
2. **GitHub Discussions**: [Ask a question](https://github.com/mohamedallam1991/hugo-cal-booking/discussions)
3. **Documentation**: [Read the docs](https://github.com/mohamedallam1991/hugo-cal-booking)

### What to Include in Support Requests

When asking for help, include:

1. **Hugo version**: `hugo version`
2. **Operating system**: `uname -a`
3. **Configuration**: `data/cal_config.yaml` (remove sensitive data)
4. **Error messages**: Full error output
5. **Browser console**: Any JavaScript errors
6. **Health check**: Screenshot of `/health/` page

### Quick Fix Checklist

Before asking for help, try this checklist:

```bash
# 1. Update everything
hugo mod get -u
go clean -modcache

# 2. Clear caches
hugo --gc
rm -rf public/
rm -rf resources/

# 3. Rebuild
hugo

# 4. Test with minimal config
# Use demo settings in data/cal_config.yaml

# 5. Check health page
# Visit http://localhost:1313/health/
```

## Prevention Tips

### Best Practices

1. **Use the installation script**: `./install.sh my-site`
2. **Test with demo config first**: Use default settings
3. **Enable debug mode during development**: `dev_mode: true`
4. **Regular updates**: Keep Hugo and modules updated
5. **Backup configuration**: Keep a copy of working `data/cal_config.yaml`

### Monitoring

Set up monitoring for production sites:
```yaml
# In hugo.yaml
params:
  monitoring:
    health_check: true
    error_reporting: true
```

---

**Remember**: Most issues are related to configuration or network connectivity. Start with the health check page and work through this guide systematically.
