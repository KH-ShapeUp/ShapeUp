<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>고객센터 상세</title>
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
      <div class="contact-tabs single-tab">
        <button type="button" class="tab-btn active">문의 상세</button>
      </div>

      <div class="tab-panel active" id="detailPanel">
        <div class="detail-view">
          <div class="detail-header">
            <span id="detailStatus" class="badge badge-wait">대기</span>
            <div class="detail-title" id="detailTitle">-</div>
            <time class="inquiry-date" id="detailDate"></time>
          </div>
          <div class="detail-body">
            <p class="detail-content" id="detailContent">-</p>
          </div>
          <div class="detail-answer">
            <div class="answer-header">
              <strong>답변</strong>
              <time class="inquiry-date" id="answerDate"></time>
            </div>
            <div class="answer-content" id="answerContent">
              답변이 아직 등록되지 않았습니다.
            </div>
          </div>
          <div class="detail-actions">
            <button type="button" class="btn ghost" onclick="window.history.back()">목록</button>
          </div>
        </div>
      </div>
    </section>
  </main>

  <jsp:include page="/WEB-INF/views/include/footer.jsp" />
</div>

<script>
  const contactNoFromServer = "${param.contactNo}";
  const params = new URLSearchParams(window.location.search);
  const contactNoRaw = contactNoFromServer && contactNoFromServer !== "null" ? contactNoFromServer : params.get("contactNo");
  const contactNo = (contactNoRaw || "").trim();
  console.log("contactNo param =", contactNo, "search:", window.location.search);
  if (!contactNo) {
    alert("잘못된 접근입니다.");
    window.location.href = "/contact/list";
  }

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

  const loadDetail = async () => {
    try {
      const detailUrl = "/contact/api/detail?contactNo=" + encodeURIComponent(contactNo);
      console.log("fetch detail url =", detailUrl);
      const res = await fetch(detailUrl, { credentials: "include" });
      if (!res.ok) throw new Error();
      const d = await res.json();
      const get = (k) => d[k] ?? d[k?.toLowerCase()] ?? d[k?.replace(/[A-Z]/g, m => "_" + m.toLowerCase())];
      document.getElementById("detailTitle").textContent = get("contactTitle") || "-";
      document.getElementById("detailContent").textContent = get("contactContent") || "-";
      document.getElementById("detailDate").textContent = formatDate(get("createdAt"));
      const status = get("status");
      document.getElementById("detailStatus").textContent = status === "완료" ? "완료" : "대기";
      document.getElementById("detailStatus").className = "badge " + (status === "완료" ? "badge-done" : "badge-wait");
      document.getElementById("answerDate").textContent = formatDate(get("answerAt") || get("createdAt"));
      document.getElementById("answerContent").textContent = get("answerContent") || "답변이 아직 등록되지 않았습니다.";
    } catch (e) {
      alert("문의 상세를 불러오지 못했습니다.");
      window.location.href = "/contact/list";
    }
  };

  loadDetail();
</script>
</body>
</html>
