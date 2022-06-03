# 전국 학교 급식 알림 앱

### API
1. [학교 기본 정보](https://open.neis.go.kr/portal/data/service/selectServicePage.do?page=1&rows=10&sortColumn=&sortDirection=&infId=OPEN17020190531110010104913&infSeq=2)
    - 학교 코드, 교육청 코드, 학교명 등을 받아오기 위해 사용
2. [학교 급식 정보](https://open.neis.go.kr/portal/data/service/selectServicePage.do?page=1&rows=10&sortColumn=&sortDirection=&infId=OPEN17320190722180924242823&infSeq=2)
    - 학교 기본 정보를 이용해 해당 학교의 급식 정보를 받아오기 위해 사용
    
### Library
- SnapKit(UI-Codebase)
- Alamofire(HTTP Networking)
- Then(Syntax Sugar)
- Toast(Activity Indicator, Error Message)
- PanModal(Half Present ViewController)
- Floaty(Share)

### 기능
1. 학교를 검색을 할 수 있다.
2. 검색한 학교의 급식 정보를 볼 수 있다.
3. 날짜 이동을 통해 다른 날의 급식 정보도 볼 수 있다.
4. 알레르기 정보를 볼 수 있다.
5. 마이 스쿨을 등록하여 검색 화면에서 등록한 학교의 급식 정보를 바로 확인할 수 있다.
6. 좌우 스와이프를 통해 날짜를 이동할 수 있다.
