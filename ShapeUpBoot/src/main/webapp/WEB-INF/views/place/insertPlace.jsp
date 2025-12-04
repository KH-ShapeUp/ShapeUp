<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>시설 신규 등록</title>

    <script
      type="text/javascript"
      src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f7deb3a806ca7664155378171a6f8121&libraries=services&autoload=false"
    ></script>

    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/resources/css/place/insertPlace.css"
    />
    
    <style>
        .error-message {
            color: #dc3545; /* 빨간색 */
            font-size: 0.9em;
            font-weight: bold;
            margin-top: 3px;
            display: none; /* 초기에는 숨김 */
        }
    </style>
  </head>
  <body>
    <main class="container">
      <h1 class="page-title">시설 신규 등록</h1>

      <form
        id="placeRegistrationForm"
        class="registration-form"
        action="${pageContext.request.contextPath}/place/insert"
        method="POST"
        enctype="multipart/form-data"
      >
        <section class="form-section basic-info">
          <h2>기본 정보</h2>
          <div class="input-group">
            <label for="placeName"
              >시설 이름 <span class="required">*</span></label
            >
            <input
              type="text"
              id="placeName"
              name="placeName"
              maxlength="50"
              required
            />
          </div>
          <div class="input-row">
            <div class="input-group">
              <label for="placeType"
                >시설 분류 <span class="required">*</span></label
              >
              <select id="placeType" name="placeType" required>
                <option value="" disabled selected>분류 선택</option>
                <option value="헬스장">헬스장</option>
                <option value="수영장">수영장</option>
                <option value="풋살장">풋살장(축구장)</option>
                <option value="기타 스포츠">기타 스포츠</option>
              </select>
            </div>
          </div>
          <div class="input-group">
            <label for="phone">연락처 <span class="required">*</span></label>
            <input
              type="text"
              id="phone"
              name="phone"
              maxlength="20"
              placeholder="예: 010-1234-5678"
              required
            />
            <span id="phoneError" class="error-message"></span>
          </div>
        </section>

        <hr />
        <section class="form-section operation-info">
          <h2>운영 시간 및 휴무일</h2>
          <div class="input-row">
            <div class="input-group">
              <label for="openTime">여는 시간 (HH:MM)</label>
              <input
                type="text"
                id="openTime"
                name="openTime"
                placeholder="예: 09:00"
                maxlength="5"
              />
              <span id="openTimeError" class="error-message"></span>
            </div>
            <div class="input-group">
              <label for="closeTime">닫는 시간 (HH:MM)</label>
              <input
                type="text"
                id="closeTime"
                name="closeTime"
                placeholder="예: 22:00"
                maxlength="5"
              />
              <span id="closeTimeError" class="error-message"></span>
            </div>
          </div>
          <div class="input-group">
            <label for="holiday">휴무일 및 특이사항</label>
            <input
              type="text"
              id="holiday"
              name="holiday"
              maxlength="100"
              placeholder="예: 매주 일요일 정기 휴무, 설날/추석 연휴 휴무"
            />
          </div>
        </section>

        <hr />

        <section class="form-section detail-info">
          <h2>시설 상세 설명</h2>
          <div class="input-group">
            <label for="placeInfo">시설 소개 및 특징 (최대 1000자)</label>
            <textarea
              id="placeInfo"
              name="placeInfo"
              rows="5"
              maxlength="1000"
              placeholder="시설의 장점, 이용 방법 등을 상세하게 입력해주세요."
            ></textarea>
          </div>
        </section>

        <hr />

        <section class="form-section location-info">
          <h2>위치 정보 <span class="required">*</span></h2>
          <div class="address-input-group">
            <div class="input-group road-name-group">
              <label for="placeRoadName">도로명 주소</label>
              <input
                type="text"
                id="placeRoadName"
                name="placeRoadName"
                readonly
                placeholder="주소 검색을 통해 자동 입력"
              />
              <input type="hidden" id="latitude" name="latitude" />
              <input type="hidden" id="longitude" name="longitude" />
            </div>
            <button
              type="button"
              class="btn btn-search-address"
              onclick="execDaumPostcode()"
            >
              주소 검색
            </button>
          </div>
          <div class="input-group">
            <label for="placeLocalName">지번 주소/상세 주소</label>
            <input
              type="text"
              id="placeLocalName"
              name="placeLocalName"
              placeholder="지번 주소 또는 건물/층/호수 등 상세 주소를 입력하세요."
            />
          </div>
          <div
            id="mapContainer"
            style="width: 100%; height: 400px; margin-top: 10px"
          >
            주소 검색 후 지도 표시
          </div>
        </section>

        <hr />

        <section class="form-section image-upload">
          <h2>시설 이미지 첨부</h2>
          <p class="guide-text">
            최소 1개 이상의 시설 사진을 등록해야 합니다. (첫 번째 사진이 대표 이미지)
          </p>
          <input
            type="file"
            id="placeImages"
            name="placeImages"
            accept="image/*"
            multiple
            required
          />
          <div id="imagePreview" class="image-preview">
            업로드된 이미지 미리보기
          </div>
        </section>

        <hr />

        <div class="action-buttons">
          <button type="submit" class="btn btn-primary">시설 등록하기</button>
          <button
            type="button"
            class="btn btn-secondary"
            onclick="window.history.back()"
          >
            취소
          </button>
        </div>
      </form>
    </main>

    <script type="text/javascript">
      let map, marker, geocoder;
      let postcodePopup;

      // ------------------------------------------
      // 1️⃣ 카카오 지도 초기화 함수 (기존 로직 유지)
      // ------------------------------------------
      function initKakaoMap() {
        if (!window.kakao.maps.services) {
          console.error("Geocoding(services) 라이브러리가 로드되지 않았습니다.");
          return;
        }

        const container = document.getElementById("mapContainer");
        container.innerHTML = "";

        map = new kakao.maps.Map(container, {
          center: new kakao.maps.LatLng(37.566826, 126.9786567), // 서울 시청 중심
          level: 3,
        });

        geocoder = new kakao.maps.services.Geocoder();

        marker = new kakao.maps.Marker({
          position: map.getCenter(),
          map: map,
        });

        kakao.maps.event.addListener(map, "click", function (mouseEvent) {
          const latlng = mouseEvent.latLng;
          marker.setPosition(latlng);
          updateAddressFromCoords(latlng);
        });

        const roadName = document.getElementById("placeRoadName").value;
        if (roadName) {
          searchAddrToCoords(roadName);
        } else {
          const center = map.getCenter();
          document.getElementById("latitude").value = center.getLat();
          document.getElementById("longitude").value = center.getLng();
        }
      }

      // ------------------------------------------
      // 2️⃣ 주소 검색 팝업 (다음 우편번호 API 연동 - 기존 로직 유지)
      // ------------------------------------------
      function execDaumPostcode() {
        if (!window.kakao || !window.kakao.maps || !map) {
          alert("지도 API가 로드 중이거나 로드에 실패했습니다. 잠시 후 다시 시도해 주세요.");
          return;
        }

        postcodePopup = new daum.Postcode({
          oncomplete: function (data) {
            document.getElementById("placeRoadName").value = data.roadAddress;
            searchAddrToCoords(data.roadAddress);
            if (postcodePopup) postcodePopup.close();
          },
          onclose: function (state) {
            if (map && state === "COMPLETE_CLOSE") {
              map.relayout();
              marker.setPosition(map.getCenter());
            }
          },
        }).open();
      }

      // 3️⃣ 주소 → 좌표 → 지도 (Geocoding - 기존 로직 유지)
      function searchAddrToCoords(address) {
        if (!map || !geocoder) {
          console.error("오류: 지도 API가 준비되지 않았습니다.");
          return;
        }

        geocoder.addressSearch(address, function (result, status) {
          if (status === kakao.maps.services.Status.OK) {
            const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
            document.getElementById("latitude").value = result[0].y;
            document.getElementById("longitude").value = result[0].x;

            map.setCenter(coords);
            marker.setPosition(coords);
            map.relayout();
          } else {
            alert("주소를 좌표로 변환할 수 없습니다. (상태: " + status + ")");
          }
        });
      }

      // 4️⃣ 좌표 → 주소 역변환 (Reverse Geocoding - 기존 로직 유지)
      function updateAddressFromCoords(latlng) {
        if (!geocoder) {
          console.error("지오코더가 초기화되지 않았습니다.");
          return;
        }

        geocoder.coord2Address(
          latlng.getLng(),
          latlng.getLat(),
          function (result, status) {
            if (status === kakao.maps.services.Status.OK) {
              let roadAddress = result[0].road_address
                ? result[0].road_address.address_name
                : result[0].address.address_name;

              document.getElementById("placeRoadName").value = roadAddress;
              document.getElementById("latitude").value = latlng.getLat();
              document.getElementById("longitude").value = latlng.getLng();
            } else {
              document.getElementById("placeRoadName").value =
                "주소를 찾을 수 없는 위치입니다.";
            }
          }
        );
      }

      // ------------------------------------------
      // 6️⃣ 클라이언트 측 유효성 검사 (새로운 로직)
      // ------------------------------------------
      
      /**
       * 특정 필드의 유효성을 검사하고 오류 메시지를 표시/숨김 처리합니다.
       * @param {HTMLElement} element - 검사할 입력 필드 요소
       * @param {string} pattern - 정규식 패턴 문자열
       * @param {string} errorMessage - 유효성 검사 실패 시 표시할 메시지
       * @returns {boolean} - 유효성 통과 여부 (true/false)
       */
      function validateField(element, pattern, errorMessage) {
        const value = element.value.trim();
        
        // 필드 ID에 'Error'를 붙여 오류 메시지 요소를 찾습니다. (HTML에 span을 미리 추가함)
        const errorElement = document.getElementById(element.id + "Error"); 

        // 1. 필수 입력 항목 검사 (HTML의 required 속성에 의존하지만, JS에서도 체크)
        if (element.required && value === '') {
            errorElement.textContent = "필수 입력 항목입니다.";
            errorElement.style.display = 'block';
            return false;
        }

        // 2. 정규식 패턴 검사 (값이 있을 때만 패턴 검사 수행)
        if (value && pattern) {
            const regex = new RegExp(pattern);
            if (!regex.test(value)) {
                errorElement.textContent = errorMessage;
                errorElement.style.display = 'block';
                return false;
            }
        }
        
        // 모든 검사 통과 시
        errorElement.textContent = '';
        errorElement.style.display = 'none';
        return true;
      }


      window.addEventListener("load", () => {
        // 폼 재로드 시 잔여 값 초기화 (이전 단계에서 유효성 검사 실패 시 값 유지를 위해 주석 처리하거나 제거해야 합니다. 여기서는 초기 상태로 유지합니다.)
        // document.getElementById("latitude").value = "";
        // document.getElementById("longitude").value = "";

        // 카카오 맵 로드
        if (window.kakao && window.kakao.maps) {
          kakao.maps.load(initKakaoMap);
        } else {
          console.error("카카오 지도 SDK 객체(window.kakao)가 존재하지 않습니다.");
        }

        // -----------------------------------------------------
        // 실시간 유효성 검사 필드 정의 및 이벤트 리스너 등록
        // -----------------------------------------------------
        const validationFields = [
            { 
                id: 'openTime', 
                pattern: '^([01]\\d|2[0-3]):([0-5]\\d)$', 
                message: '올바른 시간 형식(HH:MM)이 아닙니다.' 
            },
            { 
                id: 'closeTime', 
                pattern: '^([01]\\d|2[0-3]):([0-5]\\d)$', 
                message: '올바른 시간 형식(HH:MM)이 아닙니다.' 
            },
            { 
                id: 'phone', 
                // 전화번호: 2~3자리 - 3~4자리 - 4자리 (예: 010-1234-5678)
                pattern: '^\\d{2,3}-\\d{3,4}-\\d{4}$', 
                message: '올바른 전화번호 형식(예: 010-1234-5678)이 아닙니다.' 
            }
        ];

        validationFields.forEach(field => {
            const element = document.getElementById(field.id);
            if (element) {
                // 필드에서 벗어났을 때 (blur) 검사 실행
                element.addEventListener('blur', () => {
                    validateField(element, field.pattern, field.message);
                });
            }
        });

        // 3. 폼 제출 시 전체 유효성 검사 및 서버 전송 차단
        const form = document.getElementById('placeRegistrationForm');
        if (form) {
            form.addEventListener('submit', function(event) {
                let isValid = true;
                
                // 모든 유효성 검사 필드에 대해 검사 실행
                validationFields.forEach(field => {
                    const element = document.getElementById(field.id);
                    // 하나라도 실패하면 isValid를 false로 설정
                    if (element && !validateField(element, field.pattern, field.message)) {
                        isValid = false;
                    }
                });

                // 이미지 첨부 검사 (required 속성에 의해 브라우저가 기본적으로 검사하지만 명시적으로 추가)
                const imageInput = document.getElementById('placeImages');
                if (imageInput.files.length === 0) {
                    isValid = false;
                    alert("최소 1개 이상의 시설 사진을 등록해야 합니다.");
                }

                // **위치 정보 필수 검사** (도로명 주소)
                const roadName = document.getElementById('placeRoadName').value.trim();
                if (roadName === "" || roadName === "주소를 찾을 수 없는 위치입니다.") {
                    isValid = false;
                    alert("위치 정보 (주소 검색)는 필수 입력 사항입니다.");
                }

                // 클라이언트 측 유효성 검사에 실패하면 서버 전송을 막습니다.
                if (!isValid) {
                    event.preventDefault();
                    // 첫 번째 오류 필드로 스크롤 이동 (UX 개선)
                    const firstInvalid = document.querySelector('.error-message[style*="display: block"]');
                    if (firstInvalid) {
                        firstInvalid.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    }
                }
            });
        }
      });
      // -----------------------
      // 이미지 미리보기 (기존 로직 유지)
      // -----------------------
      document
        .getElementById("placeImages")
        .addEventListener("change", function (event) {
          const previewContainer = document.getElementById("imagePreview"); 
          previewContainer.innerHTML = ""; 

          const noImageText = previewContainer.querySelector(".no-images-text");
          if (noImageText) {
            noImageText.style.display = "none";
          }

          const files = event.target.files;

          if (files.length == 0) {
            if (noImageText) {
              noImageText.style.display = "block";
            } else {
              previewContainer.innerHTML =
                '<span class="no-images-text">여기에 선택한 이미지가 미리보기로 표시됩니다.</span>';
            }
            return;
          }

          for (let i = 0; i < files.length; i++) {
            const file = files[i];

            if (!file.type.startsWith("image/")) {
              console.warn("선택한 파일 중 이미지 형식이 아닌 파일이 있습니다.");
              continue; 
            }

            const reader = new FileReader();

            reader.onload = (e) => {
              const imgWrapper = document.createElement("div");
              imgWrapper.classList.add("preview-item"); 

              const img = document.createElement("img");
              img.src = e.target.result; 
              img.alt = file.name;

              if (i === 0) {
                imgWrapper.innerHTML += '<span class="main-tag">대표</span>';
              }

              imgWrapper.appendChild(img);
              previewContainer.appendChild(imgWrapper);
            };

            reader.readAsDataURL(file);
          }
        });
    </script>
  </body>
</html>