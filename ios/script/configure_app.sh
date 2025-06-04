#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_error() {
    echo -e "${RED}Error: $1${NC}"
    exit 1
}

print_success() {
    echo -e "${GREEN}$1${NC}"
}

print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

print_info() {
    echo -e "${BLUE}$1${NC}"
}

get_input() {
    local prompt=$1
    local default=$2
    local input
    
    if [ -n "$default" ]; then
        read -p "$prompt [$default]: " input
        echo "${input:-$default}"
    else
        read -p "$prompt: " input
        echo "$input"
    fi
}

get_array_input() {
    local prompt=$1
    local array=()
    local input
    
    print_info "$prompt (Exit by entering a blank line)"
    while true; do
        read -p "> " input
        if [ -z "$input" ]; then
            break
        fi
        array+=("$input")
    done
    echo "${array[@]}"
}

# update appInfo.json
update_app_info() {
    local app_name=$1
    local app_token=$2
    
    if [ -z "$app_name" ] || [ -z "$app_token" ]; then
        print_error "appName and appToken are required."
    fi
    
    if ! command -v jq &> /dev/null; then
        print_error "jq is not installed. Please install jq."
    fi
    
    jq --arg name "$app_name" --arg token "$app_token" \
        '.appName = $name | .appToken = $token' \
        example/Resources/appInfo.json > temp.json && mv temp.json example/Resources/appInfo.json
    
    print_success "appInfo.json has been updated."
}

update_url_schemes() {
    local schemes=("$@")
    
    if [ ${#schemes[@]} -eq 0 ]; then
        print_warning "URL scheme was not specified."
        return
    fi
    
    if ! command -v plutil &> /dev/null; then
        print_error "plutil is not installed."
    fi
    
    local scheme_array="["
    for scheme in "${schemes[@]}"; do
        scheme_array+="\"$scheme\","
    done
    scheme_array=${scheme_array%,}"]"
    
    plutil -replace CFBundleURLTypes.0.CFBundleURLSchemes -json "$scheme_array" example/Info.plist
    
    print_success "The URL scheme in Info.plist has been updated."
}

update_entitlements_domains() {
    local domains=("$@")
    
    if [ ${#domains[@]} -eq 0 ]; then
        print_warning "Domain is not specified."
        return
    fi
    
    local domain_array="["
    for domain in "${domains[@]}"; do
        domain_array+="\"webcredentials:$domain\","
    done
    domain_array=${domain_array%,}"]"
    
    plutil -replace com.apple.developer.associated-domains -json "$domain_array" example/example.entitlements
    
    print_success "The domain for entitlements has been updated."
}

print_usage() {
    echo "Usage:"
    echo "  $0 [Option]"
    echo ""
    echo "Option:"
    echo "  -n, --app-name <name>    appName"
    echo "  -t, --app-token <token>  appToken"
    echo "  -s, --schemes <scheme1> [scheme2] ..."
    echo "                           URL scheme configuration (multiple allowed)"
    echo "  -d, --domains <domain1> [domain2] ..."
    echo "                           Universal link domain configuration (multiple allowed)"
    echo ""
    echo "Usage example:"
    echo "  $0 -n MyApp -t my_token -s myapp myapp2 -d example.com test.com"
    exit 1
}

APP_NAME=""
APP_TOKEN=""
SCHEMES=()
DOMAINS=()

if [[ $# -eq 0 ]]; then
    print_usage
    exit 1
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
        -n|--app-name)
            APP_NAME="$2"
            shift 2
            ;;
        -t|--app-token)
            APP_TOKEN="$2"
            shift 2
            ;;
        -s|--schemes)
            shift
            while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
                SCHEMES+=("$1")
                shift
            done
            ;;
        -d|--domains)
            shift
            while [[ $# -gt 0 && ! "$1" =~ ^- ]]; do
                DOMAINS+=("$1")
                shift
            done
            ;;
        *)
            print_usage
            ;;
    esac
done

if [ -n "$APP_NAME" ] || [ -n "$APP_TOKEN" ]; then
    update_app_info "${APP_NAME:-$(jq -r '.appName' example/Resources/appInfo.json)}" \
                   "${APP_TOKEN:-$(jq -r '.appToken' example/Resources/appInfo.json)}"
    print_success "App information has been updated."
fi

if [ ${#SCHEMES[@]} -gt 0 ]; then
    update_url_schemes "${SCHEMES[@]}"
    print_success "The URL scheme has been updated."
fi

if [ ${#DOMAINS[@]} -gt 0 ]; then
    update_entitlements_domains "${DOMAINS[@]}"
    print_success "The domain has been updated."
fi 