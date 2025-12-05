<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>고객센터</title>
  <jsp:include page="/WEB-INF/views/include/head.jsp" />
  <link rel="stylesheet" href="/resources/css/contact/contact.css">
</head>
<body>
<%
  String loginUserNickname = (String) session.getAttribute("userNickname");
  if (loginUserNickname == null) {
%>
  <script>
    alert('로그인이 필요합니다.');
    window.location.href = '/user/login';
  </script>
<%
    return;
  }
%>

  <div class="contact-wrap">
    <jsp:include page="/WEB-INF/views/include/header.jsp" />

    <main class="contact-main">
      <section class="contact-header">
        <h1>고객센터</h1>
        <p class="subtitle">고객센터 문의 현황</p>
      </section>

      <section class="contact-card">
        <div class="contact-tabs" role="tablist">
          <button type="button" class="tab-btn" data-target="#write">문의 작성</button>
          <button type="button" class="tab-btn active" data-target="#status">문의 현황</button>
        </div>

        <!-- 문의 현황 -->
        <div id="status" class="tab-panel active" role="tabpanel">
          <div class="summary">
            <span>총 <strong id="totalCnt">0</strong>개의 문의가 있습니다.</span>
            <label class="page-size-label">
              표시 개수
              <select id="pageSizeSelect">
                <option value="5">5개</option>
                <option value="10">10개</option>
                <option value="30">30개</option>
                <option value="50">50개</option>
              </select>
            </label>
          </div>

          <h3 class="section-title">대기 목록</h3>
          <div class="inquiry-list" id="inquiryList"></div>
          <div class="pagination" id="pagination"></div>

          <h3 class="section-title">완료된 문의 목록</h3>
          <div class="inquiry-list" id="doneList"></div>
        </div>

        <!-- 문의 작성 -->
        <div id="write" class="tab-panel" role="tabpanel">
          <form class="inquiry-form" action="#" method="post">
            <div class="form-row form-row-title">
              <div class="form-field">
                <label class="form-label">제목</label>
                <input type="text" name="title" placeholder="문의 제목을 입력하세요" />
              </div>
              <div class="form-field narrow">
                <label class="form-label">유형</label>
              <select name="category">
                <option value="">선택해주세요</option>
                <option value="질문">질문</option>
                <option value="버그">버그</option>
                <option value="건의">건의</option>
              </select>
            </div>
            </div>
            <div class="form-row column">
              <label class="form-label">본문</label>
              <textarea name="content" placeholder="문의 내용을 입력하세요"></textarea>
            </div>
            <div class="form-actions">
              <button type="submit" class="btn primary">제출</button>
            </div>
          </form>
        </div>
      </section>
    </main>

    <jsp:include page="/WEB-INF/views/include/footer.jsp" />
  </div>

<script>
  const loginUserNo = Number("${sessionScope.userNo}") || 0;
  let inquiries = [];
  let total = 0;
  let currentPage = 1;
  let pageSize = 5;

  const listEl = document.getElementById("inquiryList");
  const doneListEl = document.getElementById("doneList");
  const totalEl = document.getElementById("totalCnt");
  const paginationEl = document.getElementById("pagination");
  const pageSizeSelect = document.getElementById("pageSizeSelect");

  const formatDate = (v) => {
    if (!v) return "";
    const num = Number(v);
    if (!Number.isNaN(num)) {
      const d = new Date(num);
      if (!Number.isNaN(d.getTime())) {
        return d.toISOString().replace("T", " ").slice(0, 19);
      }
    }
    return v.toString().replace("T", " ").slice(0, 19);
  };

  const renderList = () => {
    listEl.innerHTML = "";
    doneListEl.innerHTML = "";

    const waiting = inquiries.filter((q) => q.status !== "완료");
    const done = inquiries.filter((q) => q.status === "완료");

    waiting.forEach((q) => {
      const idVal = q.contactNo ?? q.contact_no ?? q.contactNO;
      if (!idVal) {
        console.warn("contactNo missing on render", q);
        return;
      }
      const link = document.createElement("a");
      // 템플릿 리터럴 사용 시 JSP EL과 충돌하므로 문자열 결합 사용
      link.href = "/contact/detail?contactNo=" + encodeURIComponent(idVal);
      link.className = "inquiry-card";
      link.dataset.id = idVal;
      link.dataset.contactNo = idVal;
      const badge = document.createElement("span");
      badge.className = "badge " + (q.status === "완료" ? "badge-done" : "badge-wait");
      badge.textContent = q.status === "완료" ? "답변 완료" : "대기";

      const cat = document.createElement("span");
      cat.className = "badge badge-cat " + (q.category === "버그" ? "badge-bug" : q.category === "건의" ? "badge-suggest" : "badge-question");
      cat.textContent = q.category || "질문";
      const title = document.createElement("div");
      title.className = "inquiry-title";
      title.textContent = q.title;
      const time = document.createElement("time");
      time.className = "inquiry-date";
      time.textContent = formatDate(q.createdAt);
      link.append(badge, cat, title, time);
      link.addEventListener("click", (e) => {
        const idVal = Number(e.currentTarget.dataset.contactNo || q.contactNo);
        if (!idVal || Number.isNaN(idVal)) {
          e.preventDefault();
          console.error("contactNo가 없습니다.", q);
        }
      });
      listEl.appendChild(link);
    });

    // 페이징
    paginationEl.innerHTML = "";
    const totalPages = Math.max(1, Math.ceil(total / pageSize));
    for (let i = 1; i <= totalPages; i += 1) {
      const btn = document.createElement("button");
      btn.type = "button";
      btn.className = "page-btn" + (i === currentPage ? " active" : "");
      btn.textContent = String(i);
      btn.addEventListener("click", () => {
        currentPage = i;
        loadList();
      });
      paginationEl.appendChild(btn);
    }

    // 완료된 문의 목록
    done.forEach((q) => {
      const idVal = q.contactNo ?? q.contact_no ?? q.contactNO;
      if (!idVal) return;
      const link = document.createElement("a");
      link.href = "/contact/detail?contactNo=" + encodeURIComponent(idVal);
      link.className = "inquiry-card";
      const badge = document.createElement("span");
      badge.className = "badge badge-done";
      badge.textContent = "완료";
      const cat = document.createElement("span");
      cat.className = "badge badge-cat badge-done";
      cat.textContent = q.category || "문의";
      const title = document.createElement("div");
      title.className = "inquiry-title";
      title.textContent = q.title;
      const time = document.createElement("time");
      time.className = "inquiry-date";
      time.textContent = formatDate(q.createdAt);
      link.append(badge, cat, title, time);
      doneListEl.appendChild(link);
    });
  };

  const openDetail = (contactNo) => {
    const id = Number(contactNo);
    if (!id || Number.isNaN(id)) {
      console.error("contactNo가 없습니다.", contactNo);
      return;
    }
    window.location.href = `/contact/detail?contactNo=${id}`;
  };

  const loadList = async () => {
    try {
      const res = await fetch(`/contact/api/list?page=${currentPage}&size=${pageSize}`, { credentials: "include" });
      if (!res.ok) throw new Error("failed");
      const data = await res.json();
      console.log("raw list data:", data);
      inquiries = Array.isArray(data.items)
        ? data.items
            .map((d) => {
              const get = (k) => {
                const snake = k?.replace(/[A-Z]/g, (m) => "_" + m.toLowerCase());
                const snakeUpper = snake?.toUpperCase();
                return (
                  d[k] ??
                  d[k?.toLowerCase()] ??
                  d[snake] ??
                  d[snakeUpper] ??
                  d[k?.toUpperCase()]
                );
              };
              const parseId = (v) => {
                if (v === undefined || v === null) return null;
                const num = Number(String(v).trim());
                return Number.isNaN(num) ? null : num;
              };
              const idVal = parseId(get("contactNo")) ?? parseId(get("contact_no"));
              if (idVal === null) {
                console.warn("contactNo 누락", d);
                return null;
              }
              return {
                contactNo: idVal,
                userNo: get("userNo"),
                category: get("category"),
                status: get("status"),
                title: get("contactTitle"),
                content: get("contactContent"),
                createdAt: get("createdAt"),
                answerContent: get("answerContent"),
                answerAt: get("answerAt") ? get("answerAt").toString().replace("T"," ").slice(0,19) : ""
              };
            })
            .filter(Boolean)
        : [];
      console.log("inquiries mapped:", inquiries);
      total = data.total || 0;
      totalEl.textContent = total;
      renderList();
    } catch (e) {
      console.error(e);
      alert("문의 목록을 불러오지 못했습니다.");
    }
  };

  loadList();

  if (pageSizeSelect) {
    pageSizeSelect.addEventListener("change", (e) => {
      pageSize = Number(e.target.value) || 5;
      currentPage = 1;
      loadList();
    });
  }

  // 작성 폼 제출
  const formEl = document.querySelector(".inquiry-form");
  formEl.addEventListener("submit", async (e) => {
    e.preventDefault();
    const formData = new FormData(formEl);
    const payload = {
      title: formData.get("title"),
      content: formData.get("content"),
      category: formData.get("category")
    };
    try {
      const res = await fetch("/contact/api/write", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        credentials: "include",
        body: JSON.stringify(payload)
      });
      if (!res.ok) {
        const msg = await res.text();
        console.error(msg || "등록에 실패했습니다.");
        return;
      }
      alert("등록되었습니다.");
      formEl.reset();
      // 탭 전환: 문의 현황
      tabButtons.forEach((b) => b.classList.remove("active"));
      panels.forEach((p) => p.classList.remove("active"));
      document.querySelector('[data-target="#status"]').classList.add("active");
      document.querySelector("#status").classList.add("active");
      currentPage = 1;
      await loadList();
    } catch (err) {
      console.error("등록 중 오류가 발생했습니다.", err);
    }
  });

  const tabButtons = document.querySelectorAll(".tab-btn");
  const panels = document.querySelectorAll(".tab-panel");

  tabButtons.forEach((btn) => {
    btn.addEventListener("click", () => {
      tabButtons.forEach((b) => b.classList.remove("active"));
      panels.forEach((p) => p.classList.remove("active"));
      btn.classList.add("active");
      const target = document.querySelector(btn.dataset.target);
      if (target) target.classList.add("active");
    });
  });
</script>
</body>
</html>
