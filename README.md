# 영어학원 앱 (가칭) 📱

## 프로젝트 소개 🚀

영어학원 관리 및 학습 지원을 위한 모바일 애플리케이션입니다.

## 주요 기능 ✨

- 회원 관리
- 수업 일정 관리
- 학습 자료 제공
- 진도 관리
- 알림 서비스

## 기술 스택 🛠️

- **상태 관리**: Riverpod
- **라우팅**: Go_Router
- **로컬 저장소**: Hive
- **백엔드/클라우드**: Supabase ⚡
    - Auth (인증)
    - PostgreSQL 데이터베이스



## Dart, Flutter 스타일 규칙 ⚠️

### 헬퍼 메소드 지양

- 기능적인 로직을 단순 메소드로 빼는 것을 지양합니다.
  - **최대한 위젯 단위로 분리**하여 재사용성과 가독성을 높입니다.

### const Lint 적용

- const lint 적용으로 메모리 성능 최적화



## 아키텍처 🏗️

MVI + MVVM, Clean Architecture 패턴을 사용합니다.

```
lib/
├── core/
│   ├── routing/
│   ├── ui/
│   └── util/
├── auth/
│   └── login/
│       ├── data/
│       ├── domain/
│       └── presentation/
```

### Dart 클래스 작성 순서

- **필드** → **게터/세터** → **생성자** → **오버라이드 메소드** 순으로 작성합니다.



### Presentation 폴더 구조

`$NAME$Screen.dart`

- 각 화면별 UI 컴포넌트를 정의하는 폴더입니다.

$NAME$`ScreenRoot.dart`

-  화면 진입 지점을 정의하는 폴더입니다.

`Controller/`

- 각 화면과 연결되는 로직을 관리하는 폴더입니다.
- 내부 구성:
  -  $NAME$`ViewModel` : 화면 상태 관리 및 비즈니스 로직 처리
  -  $NAME$`State` : ViewModel이 관리하는 상태 정의
  - $NAME$`Action` : 화면에서 발생하는 사용자 액션 정의
  - $NAME$`Event` : 외부에서 발생하여 ViewModel이 수신하는 이벤트 정의



## 개발 프로세스 🔄

1. GitHub Issue 생성
2. 해당 이슈에 맞는 브랜치 생성
3. 작업 수행 및 커밋
4. PR 생성 및 이슈 연결
5. 코드 리뷰
6. Merge

## 브랜치 전략 🌿

- Git Flow 사용
- 브랜치 네이밍 규칙:
    - `feature/` - 새로운 기능 개발
    - `fix/` - 버그 수정
    - `hotfix/` - 긴급 버그 수정
    - `chore/` - 빌드 스크립트, 설정 등 기타 작업
    - `docs/` - 문서 수정
    - `style/` - 코드 스타일 변경

## Pull Request 규칙 📝

- 리뷰 최소 1명 이상 승인 필요
- Issue와 반드시 연결 (PR 등록 후 연결)
- `feature` - PR - issue는 1:1:1 관계 유지

## 프로젝트 보드 활용 📊

- 이슈는 반드시 프로젝트 보드에 등록
- 칸반 보드 형식으로 관리 (Todo, In Progress, Review, Done)


### MVI 패턴 구성요소

- **State**: 화면 상태 정의 (불변 객체)
- **Action**: 사용자 액션 정의 (sealed class)
- **Event**: 일회성 이벤트 정의 (스낵바, 다이얼로그 등)
- **ViewModel**: 상태 관리 및 비즈니스 로직 처리
- **Screen**: UI 구성 요소 및 레이아웃
- **ScreenRoot**: 화면 진입점, ViewModel 연결 및 이벤트 처리

## 더 자세한 정보 📚

프로젝트 개발에 관한 더 자세한 정보는 [Wiki](https://github.com/GitFlow-Exercise/Flutter-Memo-App/wiki)를 참조해주세요.