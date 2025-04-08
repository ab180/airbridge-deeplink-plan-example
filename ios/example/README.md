# 커스텀 앱 빌드 시스템

이 프로젝트는 외부에서 입력된 값을 기반으로 iOS 앱을 자동으로 빌드하고 배포하는 시스템입니다. 슬랙 인터페이스를 통해 필요한 파라미터를 입력받고, GitHub Actions를 통해 앱을 빌드한 후 S3에 업로드하여 사용자에게 다운로드 링크를 제공합니다.

## 시스템 구성 요소

1. **슬랙 앱 (Scripts/slack-app/)**
   - 사용자로부터 앱 빌드에 필요한 정보를 입력받는 인터페이스 제공
   - 입력 정보: Associated Domain, Scheme URL, App Name, App Token
   - GitHub Actions 워크플로우 트리거

2. **GitHub Workflow (.github/workflows/custom-build.yml)**
   - 슬랙에서 전달된 파라미터로 앱 빌드
   - 빌드된 앱 S3에 업로드 및 다운로드 링크 생성
   - 슬랙을 통해 결과 알림

3. **빌드 스크립트 (Scripts/custom-build.sh)**
   - 앱 빌드 프로세스 자동화
   - 입력된 값을 앱에 적용 (Associated Domain, Scheme URL 등)
   - APP Name과 App Token은 JSON 파일로 저장

## 설정 방법

### 1. GitHub Repository 설정

1. GitHub Secrets 설정:
   - `AWS_ROLE_TO_ASSUME`: AWS 역할 ARN
   - `CERTIFICATE_DEVELOPMENT_PRIVATE_KEY`: 개발용 인증서 (Base64 인코딩)
   - `CERTIFICATE_DEVELOPMENT_PRIVATE_KEY_PASSWORD`: 인증서 비밀번호
   - `SLACK_WEBHOOK_URL`: 슬랙 알림을 위한 웹훅 URL

2. GitHub Variables 설정:
   - `INTERNAL_BUCKET`: S3 버킷 이름
   - `INTERNAL_DISTRIBUTION`: CloudFront 배포 ID

### 2. 슬랙 앱 설정

[슬랙 앱 설정 가이드](Scripts/slack-app/README.md)를 참조하세요.

### 3. AWS 설정

1. S3 버킷 생성
2. CloudFront 배포 설정
3. IAM 역할 설정 (GitHub Actions에서 사용)

## 사용 방법

1. 슬랙에서 `/custom-build` 명령어 실행
2. 필요한 정보 입력:
   - Associated Domain: Universal Links를 위한 도메인 (예: applinks:yourdomain.com)
   - Scheme URL: 커스텀 URL 스킴 (예: yourapp)
   - App Name: 앱 표시 이름
   - App Token: 앱에서 사용할 인증 토큰

3. 빌드 요청 제출 후 빌드 진행 상황 확인
4. 빌드 완료 시 슬랙으로 다운로드 링크 수신

## 커스텀 앱 구조

빌드된 앱은 다음과 같은 구조로 설정됩니다:

1. **Associated Domain**: Entitlements 파일에 설정되어 Universal Links 지원
2. **Scheme URL**: Info.plist에 설정되어 커스텀 URL 스킴 지원
3. **App Name 및 App Token**: 앱 내부에 JSON 파일로 저장되어 앱 실행 시 사용

## 유지 관리 및 문제 해결

- 빌드 실패 시 GitHub Actions 로그 확인
- 인증서 만료 시 새 인증서로 업데이트 필요
- Xcode 버전 업데이트 시 빌드 스크립트 호환성 확인 필요 