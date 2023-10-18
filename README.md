# 🅿️ Parking Center

- 프로젝트 기간: 2023년 10월 9일 ~ 10월 17일
- 프로젝트 팀원: [Mary🐿️](https://github.com/MaryJo-github)

---

## 📖 목차
🍀 [소개](#소개) <br>

💻 [실행 화면](#실행_화면) <br>

🧨 [트러블 슈팅](#트러블_슈팅) <br>

📚 [참고 링크](#참고_링크) <br>

👩‍👧‍👧 [about ME](#about_ME) <br>

</br>

## 🍀 소개<a id="소개"></a>
지도 및 리스트 모드로 서울시 시영주차장 정보를 표시합니다.
- 🎯 핵심 경험 : `MapKit`, `CoreLocation`, `URLCache`, `URLSession`
</br>

## 💻 실행 화면<a id="실행_화면"></a>

| 상세정보 확인 (지도) | 상세정보 확인 (리스트) |
| :--------: | :--------: |
| <img width="200" src="https://github.com/MaryJo-github/ios-parking-center/assets/42026766/d1c6c38a-8d77-4aea-a775-e6d25394d356"> | <img width="200" src="https://github.com/MaryJo-github/ios-parking-center/assets/42026766/152f6fdd-c868-4d16-8f9d-bbc6b4ab9532"> |

| 다른 지역 이동 (지도) | 다른 지역 이동 (리스트) |
| :--------: | :--------: |
| <img width="200" src="https://github.com/MaryJo-github/ios-parking-center/assets/42026766/31719095-30a2-4c2d-a912-58a68230fff8"> | <img width="200" src="https://github.com/MaryJo-github/ios-parking-center/assets/42026766/8e304a88-6317-430a-b9c4-fe7b8062ff7b"> |

</br>

## 🧨 트러블 슈팅<a id="트러블_슈팅"></a>

### 1️⃣ API response data 분석
🚨 **문제점** <br>
- 서울시 시영주차장 데이터는 총 17,000개가 넘고, 한 번에 요청할 수 있는 데이터는 1,000개로 제한되어있습니다.
- 사용자의 현재 위치를 기반으로 가까운 주차장을 제일 먼저 화면에 보여주어야하므로 [API 명세서](https://data.seoul.go.kr/dataList/OA-21709/S/1/datasetView.do)에 정의되어있는 `ADDR` 요청인자에 현재 위치의 자치구를 넣어서 요청하기로 하였습니다.
- 하지만 전체 자치구의 데이터를 모두 합쳐도 17,000개가 되지 않았고, 특정 자치구의 데이터들의 수와 mapView에 표시된 핀 개수가 맞지 않는 것 같았습니다. <br>
  <img width="300" src="https://github.com/MaryJo-github/ios-parking-center/assets/42026766/e6ae8b76-fe3b-4b92-b824-1d19f977f56e">

💡 **해결방법** <br>
- 데이터를 직접 확인해보며 다음과 같은 사실을 확인하였습니다.
    1. **자치구를 특정하지 않고 요청한** 데이터에는 불필요한 `이륜차 전용 주차장` 데이터가 포함되어있었습니다. <br>
      <img width="300" src="https://github.com/MaryJo-github/ios-parking-center/assets/42026766/3564b127-f48b-46a5-9d78-4295672a9971">

    2. **자치구를 특정하고 요청한** 데이터에는 주차장 이름 및 기타 정보는 같으나 위도, 경도만 조금씩 다른 데이터가 다수 존재하였습니다. <br>
      <img width="150" src="https://github.com/MaryJo-github/ios-parking-center/assets/42026766/62092d23-df0b-4210-8c29-4873c90fd7da">

🌼 **활용** <br>
- 2번에서 확인한 데이터들을 주차장 리스트에 각각의 셀로 보여주게 된다면 중복된 셀이 여러개가 되어 사용자 경험이 많이 떨어질 것이라 생각했습니다. 따라서 리스트에서는 **이름으로 그룹화**하여 중복항목 표기를 줄이고, 대신 지도에서는 여러 개의 핀을 그대로 표시하도록 구현하였습니다.

### 2️⃣ 데이터 캐싱
🚨 **문제점** <br>
- 지도 또는 리스트를 통해 자치구를 변경했다가 다시 원위치로 돌아오면, 기존 자치구의 데이터를 다시 받아와야하기 때문에 URLCache를 이용하여 중복 요청을 피하도록 구현하였습니다.
- 하지만 이렇게 구현하니 앱을 껐다가 켜지 않는 이상 실시간 주차장 정보를 받을 수 없었습니다.
- 추가 확인된 문제점: MapKit에서 캐싱을 지원하나...요...? 캐싱을 안해도 URLCache에 캐싱이 되어있습니다...?

💡 **해결방법** <br>
- 미해결

### 3️⃣ Location Simulator Error
🚨 **문제점** <br>
- Simulator에서 테스트 진행시, 위치 권한을 설정해주었음에도 불구하고 [CLError.Code.locationUnknown](https://developer.apple.com/documentation/corelocation/clerror/code/locationunknown) 오류가 발생하였습니다.

💡 **해결방법** <br>
- Simulator에서 GPS를 지원하지 않아 생겼던 문제였습니다. 
- Simulator 설정에서 Custom Location을 지정해주었더니 해결되었습니다.

  <img width="200" src="https://github.com/MaryJo-github/ios-parking-center/assets/42026766/93da76bb-1dda-4f4d-9aad-c4992b0252db">

### 4️⃣ HTTP 특정 도메인 허용
🚨 **문제점** <br>
- 주차장 API의 도메인이 HTTP로 설정되어있어 데이터를 불러올 수 없었습니다.

💡 **해결방법** <br>
- HTTP로 시작하는 모든 도메인을 허용하도록 설정할 수도 있으나, 주차장 API의 도메인을 제외한 나머지 도메인들로부터의 안전한 연결을 보장하기 위해 해당 도메인에 대해서만 예외처리를 진행하였습니다.

  <img width="400" src="https://github.com/MaryJo-github/ios-parking-center/assets/42026766/2f45ff11-d2f7-4284-bc69-693fa2f7e33a">

</br>

## 📚 참고 링크<a id="참고_링크"></a>

- [🍎 Apple Docs: MapKit for AppKit and UIKit](https://developer.apple.com/documentation/mapkit/mapkit_for_appkit_and_uikit)
- [🍎 Apple Docs: MKMapViewDelegate](https://developer.apple.com/documentation/mapkit/mkmapviewdelegate)
- [🍎 Apple Docs: MapKit annotations](https://developer.apple.com/documentation/mapkit/mapkit_for_appkit_and_uikit/mapkit_annotations)
- [🍎 Apple Docs: Core Location](https://developer.apple.com/documentation/corelocation)
- [🍎 Apple Docs: Preventing Insecure Network Connections](https://developer.apple.com/documentation/security/preventing_insecure_network_connections)
- [🍎 Apple Docs: URLCache](https://developer.apple.com/documentation/foundation/urlcache)
- [🌐 서울시 시영주차장 실시간 주차대수 정보](https://data.seoul.go.kr/dataList/OA-21709/S/1/datasetView.do)


<br>

---

## 👩‍👧‍👧 about ME<a id="about_ME"></a>

| <Img src = "https://hackmd.io/_uploads/r1rHg7JC3.jpg" width="100"> | **🐿️Mary🐿️** | **https://github.com/MaryJo-github** |
| :--------: | :--------: | :--------: |
