#!/bin/bash

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 함수: 에러 메시지 출력
print_error() {
    echo -e "${RED}Error: $1${NC}"
    exit 1
}

# 함수: 성공 메시지 출력
print_success() {
    echo -e "${GREEN}$1${NC}"
}

# 함수: 경고 메시지 출력
print_warning() {
    echo -e "${YELLOW}$1${NC}"
}

# 함수: 정보 메시지 출력
print_info() {
    echo -e "${BLUE}$1${NC}"
}

# 함수: 사용자 입력 받기
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

# 함수: 배열 입력 받기
get_array_input() {
    local prompt=$1
    local array=()
    local input
    
    print_info "$prompt (빈 줄을 입력하면 종료)"
    while true; do
        read -p "> " input
        if [ -z "$input" ]; then
            break
        fi
        array+=("$input")
    done
    echo "${array[@]}"
}

# appInfo.json 업데이트 함수
update_app_info() {
    local app_name=$1
    local app_token=$2
    
    if [ -z "$app_name" ] || [ -z "$app_token" ]; then
        print_error "appName과 appToken은 필수입니다."
    fi
    
    # jq가 설치되어 있는지 확인
    if ! command -v jq &> /dev/null; then
        print_error "jq가 설치되어 있지 않습니다. 'brew install jq'로 설치해주세요."
    fi
    
    # appInfo.json 업데이트
    jq --arg name "$app_name" --arg token "$app_token" \
        '.appName = $name | .appToken = $token' \
        example/Resources/appInfo.json > temp.json && mv temp.json example/Resources/appInfo.json
    
    print_success "appInfo.json이 업데이트되었습니다."
}

# Info.plist URL 스키마 업데이트 함수
update_url_schemes() {
    local schemes=("$@")
    
    if [ ${#schemes[@]} -eq 0 ]; then
        print_warning "URL 스키마가 지정되지 않았습니다."
        return
    fi
    
    # plutil이 설치되어 있는지 확인
    if ! command -v plutil &> /dev/null; then
        print_error "plutil이 설치되어 있지 않습니다."
    fi
    
    # URL 스키마 배열 생성
    local scheme_array="["
    for scheme in "${schemes[@]}"; do
        scheme_array+="\"$scheme\","
    done
    scheme_array=${scheme_array%,}"]"
    
    # Info.plist 업데이트
    plutil -replace CFBundleURLTypes.0.CFBundleURLSchemes -json "$scheme_array" example/Info.plist
    
    print_success "Info.plist의 URL 스키마가 업데이트되었습니다."
}

# entitlements 도메인 업데이트 함수
update_entitlements_domains() {
    local domains=("$@")
    
    if [ ${#domains[@]} -eq 0 ]; then
        print_warning "도메인이 지정되지 않았습니다."
        return
    fi
    
    # 도메인 배열 생성
    local domain_array="["
    for domain in "${domains[@]}"; do
        domain_array+="\"webcredentials:$domain\","
    done
    domain_array=${domain_array%,}"]"
    
    # entitlements 업데이트
    plutil -replace com.apple.developer.associated-domains -json "$domain_array" example/example.entitlements
    
    print_success "entitlements의 도메인이 업데이트되었습니다."
}

# 사용법 출력 함수
print_usage() {
    echo "사용법:"
    echo "  $0 [옵션]"
    echo ""
    echo "옵션:"
    echo "  -n, --app-name <name>        앱 이름 설정"
    echo "  -t, --app-token <token>      앱 토큰 설정"
    echo "  -s, --schemes <scheme1> [scheme2] ..."
    echo "                              URL 스키마 설정 (여러 개 가능)"
    echo "  -d, --domains <domain1> [domain2] ..."
    echo "                              유니버설 링크 도메인 설정 (여러 개 가능)"
    echo ""
    echo "예시:"
    echo "  $0 -n MyApp -t my_token -s myapp myapp2 -d example.com test.com"
    exit 1
}

# 옵션 파싱
APP_NAME=""
APP_TOKEN=""
SCHEMES=()
DOMAINS=()

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

# 설정 업데이트
if [ -n "$APP_NAME" ] || [ -n "$APP_TOKEN" ]; then
    update_app_info "${APP_NAME:-$(jq -r '.appName' example/Resources/appInfo.json)}" \
                   "${APP_TOKEN:-$(jq -r '.appToken' example/Resources/appInfo.json)}"
    print_success "앱 정보가 업데이트되었습니다."
fi

if [ ${#SCHEMES[@]} -gt 0 ]; then
    update_url_schemes "${SCHEMES[@]}"
    print_success "URL 스키마가 업데이트되었습니다."
fi

if [ ${#DOMAINS[@]} -gt 0 ]; then
    update_entitlements_domains "${DOMAINS[@]}"
    print_success "도메인이 업데이트되었습니다."
fi 