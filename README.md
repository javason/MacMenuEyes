# MacMenuEyes

MacMenuEyes는 macOS의 상태 표시줄에서 눈 모양의 UI를 제공하는 애플리케이션입니다. 사용자의 마우스 움직임에 따라 눈의 위치와 색상이 변합니다.

## 기능

- 마우스 움직임에 따라 눈의 위치가 조정됩니다.
- 마우스 속도에 따라 눈의 색상이 변경됩니다.
  - 0.5초에서 1.0초 동안 빠르게 움직이면 눈이 분홍색으로 변합니다.
  - 1.0초 이상 빠르게 움직이면 눈이 붉은색으로 변합니다.
  - 마우스가 정지하면 눈이 흰색으로 돌아갑니다.

## 설치 방법

1. 이 저장소를 클론합니다:
   ```bash
   git clone https://github.com/yourusername/MacMenuEyes.git
   ```

2. Xcode에서 프로젝트를 열고 빌드합니다.

3. 애플리케이션을 실행합니다.

## 사용법

애플리케이션을 실행하면 상태 표시줄에 눈 모양의 아이콘이 나타납니다. 마우스를 움직이면 눈의 위치와 색상이 자동으로 변경됩니다.

## 빌드 버전 관리

### 현재 빌드 번호 확인

현재 설정된 빌드 번호를 확인하려면 터미널에서 다음 명령어를 실행합니다:

```bash
cd /Users/javason/workspace/dev_cursor/MacMenuEyes
agvtool what-version -terse
```

### 빌드 번호 증가

빌드 번호를 증가시키려면 다음 명령어를 실행합니다:

```bash
agvtool next-version -all
```

이 명령어는 `CFBundleVersion` 값을 1 증가시킵니다.

### 빌드파일위치
```bash
~/Library/Developer/Xcode/DerivedData/MacMenuEyes-<RandomString>/Build/Products/Debug/MacMenuEyes.app
```

## 기여

기여를 원하신다면, 이슈를 열거나 풀 리퀘스트를 제출해 주세요.

## 라이센스

이 프로젝트는 MIT 라이센스 하에 배포됩니다.
