<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/WEB-INF/views/include/head.jsp" />
<link rel="stylesheet"
   href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />
<link rel="stylesheet" href="../../resources/css/index.css">
</head>
<body>
   <div class="container">
      <jsp:include page="/WEB-INF/views/include/header.jsp" />
      <div class="main">
         <!-- 광고 div -->
         <div class="ad-wrapper">
            <div class="swiper mySwiper">
               <div class="swiper-wrapper">
                  <!-- 동적 배너 슬라이드가 주입됩니다 -->
               </div>
               <div class="swiper-button-next"></div>
               <div class="swiper-button-prev"></div>
               <div class="swiper-pagination"></div>
            </div>
         </div>
         <!-- 광고 div 끝 -->

         <!-- 식단, 환영 div -->
         <div class="diet-wrapper">
            <div class="diet-wrapper-title">
               <h2>오늘의 칼로리</h2>
               <span>오늘의 식단을 관리하세요.</span>
            </div>
            <div
               class="diet-content${empty sessionScope.userNo ? ' locked' : ''}">
               <!-- 로그인 안했을 때 식단 표시-->
               <c:if test="${empty sessionScope.userNo}">
                  <div class="diet-lock-overlay">
                     <span class="material-symbols-outlined">lock_person</span>
                     <p>칼로리를 입력하려면 로그인이 필요합니다.</p>
                     <a href="/user/login"><button class="btn-login" type="button">로그인</button></a>
                  </div>
               </c:if>
               <!-- 로그인 안했을 때 식단 표시 끝 -->
               <!-- 아침 -->
               <div class="user-diet-record"
                  style="border-top: 4px solid #F2B84B;" data-diet-type="아침">
                  <a href="/diet">
                     <div class="title">
                        <img src="/resources/img/diet-img/brackfast.gif" alt="아침" class="diet-icon diet-icon--breakfast" />
                        <div class="title-info">
                           <h3>아침</h3>
                           <p>07:30 AM</p>
                        </div>
                     </div>
                     <div class="info">
                        <div class="cal">섭취칼로리</div>
                        <h2 class="cal-num" id="home-cal-breakfast">0</h2>
                     </div>
                     <div class="progress" id="progressWrapper-m">
                        <div class="progress-out" id="progressOut-m">
                           <div class="progress-in" id="progressIn-m"></div>
                        </div>
                     </div>
                     <div class="meta">목표 : 500 Kcal</div>
                  </a>
               </div>

               <!-- 점심 -->
               <div class="user-diet-record"
                  style="border-top: 4px solid #2E8CFF;" data-diet-type="점심">
                  <a href="/diet">
                     <div class="title">
                        <img src="/resources/img/diet-img/lunch.gif" alt="점심" class="diet-icon diet-icon--lunch" />
                        <div class="title-info">
                           <h3>점심</h3>
                           <p>13:30 PM</p>
                        </div>
                     </div>
                     <div class="info">
                        <div class="cal">섭취칼로리</div>
                        <h2 class="cal-num" id="home-cal-lunch">0</h2>
                     </div>
                     <div class="progress" id="progressWrapper-l">
                        <div class="progress-out" id="progressOut-l">
                           <div class="progress-in" id="progressIn-l"></div>
                        </div>
                     </div>
                     <div class="meta">목표 : 680 Kcal</div>
                  </a>
               </div>

               <!-- 저녁 -->
               <div class="user-diet-record"
                  style="border-top: 4px solid #F25C5C;" data-diet-type="저녁">
                  <a href="/diet">
                     <div class="title">
                        <img src="/resources/img/diet-img/dinner.gif" alt="저녁" class="diet-icon diet-icon--dinner" />
                        <div class="title-info">
                           <h3>저녁</h3>
                           <p>18:30 PM</p>
                        </div>
                     </div>
                     <div class="info">
                        <div class="cal">섭취칼로리</div>
                        <h2 class="cal-num" id="home-cal-dinner">0</h2>
                     </div>
                     <div class="progress" id="progressWrapper-d">
                        <div class="progress-out" id="progressOut-d">
                           <div class="progress-in" id="progressIn-d"></div>
                        </div>
                     </div>
                     <div class="meta">목표 : 550 Kcal</div>
                  </a>
               </div>

               <!-- 기타 -->
               <div class="user-diet-record"
                  style="border-top: 4px solid #C58C5D;" data-diet-type="기타">
                  <a href="/diet">
                     <div class="title">
                        <img src="/resources/img/diet-img/others.gif" alt="간식" class="diet-icon diet-icon--other" />
                        <div class="title-info">
                           <h3>기타</h3>
                           <p>간식 / 음료</p>
                        </div>
                     </div>
                     <div class="info">
                        <div class="cal">섭취칼로리</div>
                        <h2 class="cal-num" id="home-cal-etc">0</h2>
                     </div>
                     <div class="progress" id="progressWrapper-o">
                        <div class="progress-out" id="progressOut-o">
                           <div class="progress-in" id="progressIn-o"></div>
                        </div>
                     </div>
                     <div class="meta">목표 : 500 Kcal</div>
                  </a>
               </div>
            </div>
         </div>
         <!-- 식단 div 끝 -->

         <!-- 최근 올라온 매칭 -->
         <div class="recent-matching-wrapper">
            <div class="matching">
               <div class="match">
                  <h2>최근에 올라온 매칭</h2>
                  <span>회원님과 맞는 매칭을 찾아보세요.</span>
               </div>
               <div class="matching-all-btn">
                  <a href="/matching/board" class="all-page-btn"
                     id="matching-all-list-btn">더보기 <i
                     class="fa-solid fa-arrow-right"></i>
                  </a>
               </div>
            </div>
            <div class="matching-content">
               <c:forEach var="mList" items="${mList}">
                  <div class="matching-card">
                     <div class="matching-user">
                        <div class="user-profile">
                           <img src="../../resources/img/person.png" width="50">
                        </div>
                        <div class="user-profile-info">
                           <div class="user-profile-top">
                              <div class="user-info">
                                 <span class="nick-name">${mList.userNickName}</span>
                              </div>
                              <c:choose>
                                 <c:when test="${mList.matchingStatus == '마감'}">
                                    <div class="card-state-finish">${mList.matchingStatus }</div>
                                 </c:when>
                                 <c:when test="${mList.matchingStatus == '마감임박'}">
                                    <div class="card-state-imminent">${mList.matchingStatus }</div>
                                 </c:when>
                                 <c:otherwise>
                                    <div class="card-state-ing">${mList.matchingStatus }</div>
                                 </c:otherwise>
                              </c:choose>
                           </div>
                           <div class="category-wrapper">
                              <span class="workout-category">${mList.activityName }</span>
                              <c:choose>
                                 <c:when test="${mList.matchingLevel == 1 }">
                                    <span class="user-level"># 초급</span>
                                 </c:when>
                                 <c:when test="${mList.matchingLevel == 2 }">
                                    <span class="user-level middleClass"># 중급</span>
                                 </c:when>
                                 <c:otherwise>
                                    <span class="user-level advanced"># 고급</span>
                                 </c:otherwise>
                              </c:choose>
                           </div>
                        </div>
                     </div>
                     <div class="matching-title">
                        <span class="card-title">${mList.matchingTitle }</span> <span
                           class="card-content">${mList.partnerType}</span>
                     </div>
                     <div class="matching-info">
                        <div class="matching-icon">
                           <div class="matching-location">
                              <i class="fa-solid fa-location-dot"></i> <span>${mList.matchingLocation }</span>
                           </div>
                           <div class="matching-time">
                              <i class="fa-solid fa-clock"></i> <span>${mList.matchingTime }</span>
                           </div>
                           <div class="matching-day">
                              <i class="fa-solid fa-calendar-days"></i> <span>${mList.matchingDate }</span>
                           </div>
                           <div class="matching-money">
                              <i class="fa-solid fa-wallet"></i> <span>${mList.matchingPrice }</span>
                           </div>
                           <div class="matching-user-icon">
                              <i class="fa-solid fa-users"></i> <span>${mList.applicationCount}
                                 / ${mList.matchingUserCount} 명</span>
                           </div>
                        </div>
                        <div class="matching-btn-wrapper">
                           <input type="hidden" name="sessionLogin" id="">
                           <c:choose>
                              <c:when
                                 test="${mList.applicationCount >= mList.matchingUserCount or mList.matchingStatus == '마감'}">
                                 <button class="matching-btn finish":disabled">마감</button>
                              </c:when>
                              <c:otherwise>
                                 <button class="matching-btn"
                                    onclick="macthingApplyBtn('${mList.matchingNo}', '${mList.userNo}');">신청하기</button>
                              </c:otherwise>
                           </c:choose>

                        </div>
                     </div>
                  </div>
               </c:forEach>
            </div>
         </div>
         <!-- 최근 올라온 매칭 끝 -->

         <!-- 성공 후기 div -->
         <div class="goal-wrapper">
            <div class="goal-left-content">
               <div class="goal-top">
                  <div class="goal">
                     <h2>성공 후기</h2>
                     <span>다른 회원들의 성공 스토리를 확인하세요.</span>
                  </div>
                  <div class="goal-all">
                     <a href="/success" class="all-page-btn" id="goal-all-list-btn">더보기 
                        <i class="fa-solid fa-arrow-right"></i>
                     </a>
                  </div>
               </div>

               <div class="goal-content">
                  <c:forEach var="sList" items="${sList }">                  
                     <a href="/community/detail?boardNo=${sList.communityNo}">
                        <div class="goal-card">
                           <div class="goal-card-top">
                              <div class="goal-profile-img">
                                 <img src="../../resources/img/person.png" alt="">
                              </div>
                              <div class="goal-profile-info">
                                 <span>${sList.userNickName }</span> 
                                 <span>${sList.timeAgo }</span>
                              </div>
                           </div>
   
                           <div class="goal-main">
                              <div class="goal-title">
                                 <h4>${sList.communityTitle }</h4>
                                 <div class="goal-icon">
                                    <div class="goal-view">
                                       <i class="fa-regular fa-eye"></i> <span>${sList.viewCount }</span>
                                    </div>
                                    <div class="goal-good">
                                       <i class="fa-regular fa-thumbs-up"></i> <span>${sList.likeCount }</span>
                                    </div>
                                    <div class="goal-comment">
                                       <i class="fa-regular fa-comment"></i>
                                       <span>${sList.commentCount }</span>
                                    </div>
                                 </div>
                              </div>
                              <div class="goal-middle">
                                 <div class="goal-content">${sList.communityContent }</div>                              
                              </div>
                           </div>
                        </div>
                     </a>
                  </c:forEach>
               </div>
            </div>

            <div class="goal-right">
               <!-- 공지 사항 -->
               <div class="post-left-notice">
                  <div class="goal-wrapper-title">
                     <span>공지사항 & 이벤트</span> <a href="/notice/list" class="all-page-btn"
                        id="notice-all-list-btn">더보기 <i
                        class="fa-solid fa-arrow-right"></i>
                     </a>
                  </div>
                  <div class="notice-content">
                     <c:forEach var="nList" items="${nList }">
                        <a href="/notice/detail?noticeNo=${nList.noticeNo }" class="notice-ahref">
                                 <div class="notice-card">
                                       <div class="notice-top">
                                          <c:choose>
                                    <c:when test="${nList.noticeCategory eq '이벤트' }">
                                       <span class="notice-category-e pill">${nList.noticeCategory }</span>                                     
                                    </c:when>
                                    <c:when test="${nList.noticeCategory eq '제휴' }">
                                       <span class="notice-category-c pill">${nList.noticeCategory }</span>
                                    </c:when>
                                    <c:when test="${nList.noticeCategory eq '징계'}">
                                       <span class="notice-category-d pill">${nList.noticeCategory }</span>
                                    </c:when>
                                    <c:otherwise>
                                       <span class="notice-category-n pill">${nList.noticeCategory }</span>
                                    </c:otherwise>
                                 </c:choose>
                                          <span class="notice-writeDate">${nList.createdDay }</span>
                                       </div>
                                       <div class="notice-main">
                                 <div class="notice-middle">
                                    <h4>
                                    ${nList.noticeTitle }
                                    </h4>
                                 </div>
                                 <div class="notice-icon">
                                    <div>
                                       <i class="fa-regular fa-eye"></i> <span>${nList.viewCount }</span>
                                    </div>                                         
                                 </div>
                                       </div>
                                 </div>
                        </a>                     
                     </c:forEach>
                  </div>
               </div>

               <!-- 자유게시판 -->
               <div class="post-right-free">
                  <div class="post-wrapper-title">
                     <span>커뮤니티</span> 
                     <a href="/matching/board" class="all-page-btn"
                        id="free-board-list-btn">더보기 
                        <i class="fa-solid fa-arrow-right"></i>
                     </a>
                  </div>
                  <div class="post-content">
                     <c:forEach var="cList" items="${cList }">
                        <a href="/community/detail?boardNo=${cList.communityNo }" class="post-ahref">
                           <div class="post-card">
                              <div class="post-header">
                                 <div class="post-header-left">
                                    <c:choose>
                                                    <c:when test="${cList.communityType eq '운동질문' }">
                                                        <span class="post-category-question">${cList.communityType }</span>
                                                    </c:when>
                                                    <c:when test="${cList.communityType eq '운동꿀팁' }">
                                                        <span class="post-category-tip">${cList.communityType }</span>
                                                    </c:when>
                                                    <c:when test="${cList.communityType eq '식단/영양' }">
                                                        <span class="post-category-food">${cList.communityType }</span>
                                                    </c:when>
                                                    <c:when test="${cList.communityType eq '운동인증' }">
                                                        <span class="post-category-certification">${cList.communityType }</span>
                                                    </c:when>
                                                    <c:when test="${cList.communityType eq '일상/소통' }">
                                                        <span class="post-category">${cList.communityType }</span>
                                                    </c:when>
                                                </c:choose>         
                                    <span class="post-nickName">${cList.userNickName }</span> 
                                    <span class="post-writeDate">${cList.timeAgo }</span>
                                 </div>
                                 <div class="post-icon">
                                    <div>
                                       <i class="fa-regular fa-eye"></i><span>${cList.viewCount }</span>
                                    </div>
                                    <div>
                                       <i class="fa-regular fa-thumbs-up"></i><span>${cList.likeCount }</span>
                                    </div>
                                 </div>
                              </div>
                              <div class="post-middle">
                                 <span class="post-title">${cList.communityTitle }</span> 
                                 <span class="post-comment">(${cList.commentCount })</span>
                              </div>
                           </div>
                        </a>
                     </c:forEach>                     
                  </div>
               </div>
            </div>
         </div>
         <!-- 성공 후기 div 끝 -->
      </div>
      <jsp:include page="/WEB-INF/views/include/footer.jsp" />
   </div>
   <script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
   <script
      src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
   <script>
      const isHomeDietLoggedIn = ${empty sessionScope.userNo ? 'false' : 'true'};
      const HOME_MEAL_GOALS = { '아침': 500, '점심': 680, '저녁': 550, '기타': 500 };

      function pad2(n) { return (n < 10 ? '0' : '') + n; }
      function getTodayIso() {
         const d = new Date();
         return d.getFullYear() + '-' + pad2(d.getMonth() + 1) + '-' + pad2(d.getDate());
      }

      async function loadHomeDietSummary() {
         const typeMap = {
            '아침': { calEl: document.getElementById('home-cal-breakfast'), progressEl: document.getElementById('progressIn-m') },
            '점심': { calEl: document.getElementById('home-cal-lunch'), progressEl: document.getElementById('progressIn-l') },
            '저녁': { calEl: document.getElementById('home-cal-dinner'), progressEl: document.getElementById('progressIn-d') },
            '기타': { calEl: document.getElementById('home-cal-etc'), progressEl: document.getElementById('progressIn-o') },
         };

         const resetAll = () => {
            Object.values(typeMap).forEach(({ calEl, progressEl }) => {
               if (calEl) calEl.textContent = '0';
               if (progressEl) progressEl.style.width = '0%';
            });
         };

         if (!isHomeDietLoggedIn) {
            resetAll();
            return;
         }

         const safeDate = getTodayIso();
         resetAll();

         try {
            const res = await fetch('/diet/summary?date=' + encodeURIComponent(safeDate));
            if (!res.ok) throw new Error('summary failed');
            const json = await res.json();
            const data = json.data || {};
            const totals = json.totals || {};
            const totalKcal = Number(totals.kcal || totals.totalKcal) || Object.values(data).reduce((acc, cur) => acc + (Number(cur) || 0), 0);

            Object.entries(data).forEach(([rawType, val]) => {
               const type = (rawType || '').trim();
               const target = typeMap[type];
               if (!target) return;
               const kcal = Number(val) || 0;
               if (target.calEl) target.calEl.textContent = kcal.toString();
               if (target.progressEl) {
                  const goal = HOME_MEAL_GOALS[type];
                  let pct = 0;
                  if (goal && goal > 0) {
                     pct = Math.min(100, Math.round((kcal / goal) * 100));
                  } else if (totalKcal > 0) {
                     pct = Math.min(100, Math.round((kcal / totalKcal) * 100));
                  } else if (kcal > 0) {
                     pct = 100;
                  }
                  target.progressEl.style.width = pct + '%';
               }
            });
         } catch (err) {
            console.error('home diet summary load failed', err);
            resetAll();
         }
      }

      function formatDate(ts) {
         if (!ts) return '';
         try {
            const d = new Date(ts);
            if (!Number.isNaN(d.getTime())) {
               return d.getFullYear() + '.' + pad2(d.getMonth() + 1) + '.' + pad2(d.getDate());
            }
            return String(ts).split('T')[0] || '';
         } catch {
            return '';
         }
      }

      async function loadHomeNotice() {
         const wrap = document.getElementById('home-notice-list');
         if (!wrap) return;
         wrap.innerHTML = '';
         try {
            const res = await fetch('/api/notices/latest?limit=5');
            if (!res.ok) throw new Error('latest notice fail');
            const json = await res.json();
            const items = Array.isArray(json.items) ? json.items : [];
            if (!items.length) {
               wrap.innerHTML = '<p class="empty">등록된 공지가 없습니다.</p>';
               return;
            }
            items.forEach((n) => {
               const a = document.createElement('a');
               a.className = 'notice-ahref';
               a.href = '/notice/detail?noticeNo=' + n.noticeNo;
               const card = document.createElement('div');
               card.className = 'notice-card';
               const top = document.createElement('div');
               top.className = 'notice-top';
               const catSpan = document.createElement('span');
               const cat = n.noticeCategory || '공지';
               catSpan.className = 'pill pill-' + cat;
               catSpan.textContent = cat;
               const dateSpan = document.createElement('span');
               dateSpan.className = 'notice-writeDate';
               dateSpan.textContent = formatDate(n.createdAt) || '';
               top.appendChild(catSpan);
               top.appendChild(dateSpan);

               const main = document.createElement('div');
               main.className = 'notice-main';
               const mid = document.createElement('div');
               mid.className = 'notice-middle';
               const h4 = document.createElement('h4');
               const viewCount = n.viewCount != null ? n.viewCount : 0;
               h4.textContent = n.noticeTitle || '제목 없음';
               mid.appendChild(h4);

               const icon = document.createElement('div');
               icon.className = 'notice-icon';
               const views = document.createElement('div');
               views.innerHTML = '<i class="fa-solid fa-eye"></i> <span>' + viewCount + '</span>';
               icon.appendChild(views);

               main.appendChild(mid);
               main.appendChild(icon);

               card.appendChild(top);
               card.appendChild(main);
               a.appendChild(card);
               wrap.appendChild(a);
            });
         } catch (err) {
            console.error(err);
            wrap.innerHTML = '<p class="empty">공지 로드에 실패했습니다.</p>';
         }
      }

      function macthingApplyBtn(matchingNo, userNo) {
         Swal.fire({
            title: '해당 매칭을 신청하시겠습니까?',
            showCancelButton: true,
            cancelButtonText: "취소하기",
            confirmButtonText: "신청하기",
            customClass: {
               popup: 'success-popup',
               title: 'success-title',
               confirmButton: 'success-button',
               cancelButton: 'cancel-button'
            }
         }).then((result) => {
            if(result.isConfirmed) {
               fetch('/home', {
                  method: "post",
                  headers: {"Content-Type":"application/json"},
                  body: JSON.stringify({ 
                     matchingNo: matchingNo,
                     userNo: userNo
                  })
               })
               .then(res => res.json())
               .then(result => {
                  console.log(result);
                  if(result > 0) {
                     Swal.fire({
                        icon: 'success',
                        title: '매칭 신청완료!',
                        text: '승인전까지 기다려주세요!',
                        confirmButtonText: '확인',
                        customClass: {
                           popup: 'success-popup',
                           title: 'success-title',
                           confirmButton: 'success-button',
                        }
                     }).then(() => {
                        // 새로고침
                        location.reload();
                     });
                  } else if (result == -1) {
                     Swal.fire({
                        icon:'warning',
                        title: '자기가 쓴 매칭을 \n 신청할 수 없습니다..ㅠ',
                        text: '다른 매칭을 신청해주세요.',
                        confirmButtonText: '확인',
                        customClass: {
                           popup: 'error-popup',
                           title: 'error-title',
                           text: 'error-text',
                           confirmButton: 'error-button'
                        }
                     });
                  } else if (result == -2) {
                     Swal.fire({
                        icon:'warning',
                        title: '이미 신청한 매칭입니다.',
                        text: '다른 매칭을 신청해주세요.',
                        confirmButtonText: '확인',
                        customClass: {
                           popup: 'error-popup',
                           title: 'error-title',
                           text: 'error-text',
                           confirmButton: 'error-button'
                        }
                     }); 
                  } else if (result == -10) {
                     Swal.fire({
                        icon:'warning',
                        title: '로그인이 필요한 서비스입니다.',
                        text: '로그인 후 이용해주세요.',
                        confirmButtonText: '로그인 하러가기',
                        customClass: {
                           popup: 'error-popup',
                           title: 'error-title',
                           text: 'error-text',
                           confirmButton: 'error-button'
                        }, 
                        didClose: () => {
                           location.href="/user/login";
                        }
                     });
                  } else {
                     Swal.fire({
                        icon:'error',
                        title: '매칭 신청 실패..ㅠ',
                        text: '다시 시도 해주세요.',
                        confirmButtonText: '확인',
                        customClass: {
                           popup: 'error-popup',
                           title: 'error-title',
                           text: 'error-text',
                           confirmButton: 'error-button'
                        }
                     });
                  }
               })
               .catch(err => {
                  console.error(err);
                  Swal.fire({
                     icon:'error',
                     title: '매칭 신청 실패..ㅠ',
                     text: '다시 시도 해주세요.',
                     confirmButtonText: '확인',
                     customClass: {
                        popup: 'error-popup',
                        title: 'error-title',
                        text: 'error-text',
                        confirmButton: 'error-button'
                     }
                  });
               });
            }
         });
      }

        document.addEventListener('DOMContentLoaded', function() {
            const wrapper = document.querySelector('.mySwiper .swiper-wrapper');
            let swiperInstance = null;

            const origin = window.location.origin || '';
            const createSlides = (items) => {
              if (!wrapper) return 0;
              wrapper.innerHTML = '';
              const resolveSrc = (path) => {
                if (!path || path === 'false') return '';
                if (typeof path !== 'string') return '';
                if (path.startsWith('http')) return path;
                const normalized = path.startsWith('/') ? path : '/' + path;
                return origin + normalized;
              };
              const data = Array.isArray(items) ? items : [];
              let added = 0;
              data.forEach((b) => {
                let src = resolveSrc(b.imgPath);
                const title = (!b.bannerTitle || String(b.bannerTitle).toLowerCase() === 'false') ? '배너' : b.bannerTitle;
                if (!src) {
                  src = origin + '/resources/img/ad-img1.gif';
                }
                const noticeStr = (b.noticeNo ?? '').toString().trim();
                const hasNotice = noticeStr !== '' && noticeStr.toLowerCase() !== 'false';
                const link = hasNotice ? origin + "/notice/detail?noticeNo=" + encodeURIComponent(noticeStr) : '#';
                const slide = document.createElement('div');
                slide.className = 'swiper-slide';
                const anchor = document.createElement('a');
                anchor.href = link;
                anchor.setAttribute('data-notice', hasNotice ? noticeStr : '');
                if (!hasNotice) {
                  anchor.addEventListener('click', (e) => e.preventDefault());
                } else {
                  anchor.addEventListener('click', function(e) {
                    const n = this.getAttribute('data-notice');
                    if (!n) {
                      e.preventDefault();
                      return;
                    }
                    this.href = origin + "/notice/detail?noticeNo=" + encodeURIComponent(n);
                  });
                }
                const img = document.createElement('img');
                img.className = 'ad-img';
                img.setAttribute('data-src', src);
                img.alt = title;
                img.src = src;
                img.addEventListener('error', function() {
                  console.error('banner img load fail', this.getAttribute('data-src'), '-> fallback');
                  this.onerror = null;
                  this.src = origin + '/resources/img/ad-img1.gif';
                });
                anchor.appendChild(img);
                slide.appendChild(anchor);
                wrapper.appendChild(slide);
                console.log('slide add', { noticeNo: b.noticeNo, noticeStr, link: anchor.href, src: img.src, title });
                added += 1;
              });
              if (added === 0) {
                const defaults = [
                  { src: origin + '/resources/img/ad-img1.gif', link: '#' },
                  { src: origin + '/resources/img/ad-img2.jpg', link: '#' },
                  { src: origin + '/resources/img/ad-img3.jpg', link: '#' },
                  { src: origin + '/resources/img/ad-img4.jpg', link: '#' },
                  { src: origin + '/resources/img/ad-img5.jpg', link: '#' },
                  { src: origin + '/resources/img/main_banner.png', link: origin + '/intro' },
                ];
                console.log('using default slides', defaults);
                defaults.forEach(({ src, link }) => {
                  const slide = document.createElement('div');
                  slide.className = 'swiper-slide';
                  const a = document.createElement('a');
                  a.href = link || '#';
                  const img = document.createElement('img');
                  img.className = 'ad-img';
                  img.src = src;
                  img.alt = '배너';
                  a.appendChild(img);
                  slide.appendChild(a);
                  wrapper.appendChild(slide);
                });
                added = defaults.length;
              }
              if (wrapper.children.length === 1) {
                wrapper.appendChild(wrapper.children[0].cloneNode(true));
              }
              console.log('total slides after create', wrapper.children.length);
              return wrapper.children.length;
            };

            const initSwiper = () => {
              if (swiperInstance) return swiperInstance;
              swiperInstance = new Swiper(".mySwiper", {
                  direction: "horizontal",
                  loop: true,
                  autoplay: {
                      delay: 1000,
                      disableOnInteraction: false,
                  },
                  pagination: {
                      el: ".swiper-pagination",
                      clickable: true,
                  },
                  navigation: {
                      nextEl: ".swiper-button-next",
                      prevEl: ".swiper-button-prev",
                  },
              });
              const sliderEl = document.querySelector('.mySwiper');
              sliderEl.addEventListener('mouseenter', () => swiperInstance.autoplay.stop());
              sliderEl.addEventListener('mouseleave', () => swiperInstance.autoplay.start());
              return swiperInstance;
            };

            // 배너 불러오기 후 슬라이드 생성 -> Swiper 초기화
            const apiBase = window.location.origin || '';
            fetch(apiBase + '/api/banners/active')
              .then(res => res.ok ? res.json() : [])
              .then(banners => {
                console.log('active banners', banners);
                createSlides(banners);
                initSwiper().update();
              })
              .catch(() => {
                console.warn('banner fetch failed, using defaults');
                createSlides([]);
                initSwiper().update();
              });

            loadHomeDietSummary();
            loadHomeNotice();
        });
   </script>
</body>
</html>
