# elice
elice platform의 화면 일부를 구현.

## 빌드 환경
- Minimum iOS Target: iOS 13
- XCode 15 (Image, Color등 리소스 참조 방식이 바뀌어서 15 필수)

## 빌드 방법
- SPM 설치 이외에 특별히 필요한 것 없습니다.

## 프로젝트 구조
프로젝트 구성은 아래 링크들의 Clean Architecture를 참고하였습니다.   
- [medium](https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3)   
- [github](https://github.com/kudoleh/iOS-Clean-Architecture-MVVM)   

|프로젝트 구조|구조도|
|-|-|
|![](/Resources/1.png)|![](/Resources/2.png)|

- Presentation Layer의 구현은 [ReactorKit](https://github.com/ReactorKit/ReactorKit)으로 도움을 받았습니다.
- [RxDataSource](https://github.com/RxSwiftCommunity/RxDataSources)의 도움을 받아 ScrollView와 Reactorkit의 binding을 구현하였습니다.
- 모든 Layer와 객체들의 종속성을 지켜주기 위해 전부 외부에서 Dependency Injection을 해주었습니다.
- Image Caching은 [Kingfisher](https://github.com/onevcat/Kingfisher)의 도움을 받았습니다.
- MarkdownView의 구현은 [MarkdownView](https://github.com/keitaoouchi/MarkdownView)의 도움을 받았습니다.

## 과제 진척도
|요구사항|처리|비고|
|-|-|-|
|서버에서 Course List를 가져오기|o|||
|화면1 상단 디자인 적용|o||
|과목 리스트를 Vertical Scroll로 구현|o|UITableView 사용|
|각 과목 리스트를 Horizontal Scroll로 구현|o|UICollectionView 사용|
|과목 리스트는 infinity scroll이 가능해야함(10개 단위)|o||
|수강한 과목 리스트를 출력|o||
|과목 카드는 touchable하며 화면 전환되어야함|o||
|과목 이미지 및 제목 설명에 요구한 디자인 적용 (2줄 제한 + 이미지 크기)|o||
|과목 태그 리스트를 디자인대로 구현 (2줄 제한)|x||
|화면2 상단 뒤로가기 버튼 구현|o||
|서버에서 Course 정보와 Lecture List를 가져옴|o||
|하단의 버튼은 scroll영역이 아니며 신청 여부를 통해 다르게 표현|o||
|수강 신청/ 취소 구현|o|CoreData 이용하여 id만 저장하고 나머지 정보는 서버에서 얻어옴|
|Title Area, Image File Area, Description Area, Lecture Area를 Scrollable하게 구현|ㅇ|UIScrollView + UIStackView로 구현|
|Usecase Test Code 및 UI Test Code 작성|x||

## [앱실행영상](https://drive.google.com/file/d/10b9cI5ouHT3T1g179tXhzWlXpqy_0DWZ/view?usp=sharing)