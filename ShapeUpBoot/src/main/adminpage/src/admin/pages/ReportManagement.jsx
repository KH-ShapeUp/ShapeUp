// src/admin/pages/ReportManagement.jsx
import React, { useEffect, useMemo, useState } from "react";
import "../styles/ReportManagement.css";

const initialReports = [
  {
    id: 1,
    reporter: "user01",
    category: "댓글",
    author: "user02",
    reason: "비속어 사용",
    title: "강도 높은 루틴 후기",
    date: "2025-12-12",
    status: "대기",
    content: "댓글에 과도한 비속어가 포함되어 있어 다른 이용자에게 불편을 주고 있습니다.",
    link: "/mock/reported-post.jsp",
  },
  {
    id: 2,
    reporter: "user03",
    category: "게시글",
    author: "user04",
    reason: "허위 정보",
    title: "운동 효과 과장 사례 공유",
    date: "2025-12-12",
    status: "반려",
    content: "과장된 다이어트 후기를 올려 다른 회원들이 혼란을 겪고 있습니다.",
    link: "/mock/reported-post.jsp",
  },
  {
    id: 3,
    reporter: "trainer07",
    category: "게시글",
    author: "user10",
    reason: "홍보성 스팸",
    title: "헬스 제품 광고 모음",
    date: "2025-12-10",
    status: "대기",
    content: "외부 제품 링크만 반복적으로 첨부된 스팸성 게시글입니다.",
    link: "/mock/reported-post.jsp",
  },
];

const ReportManagement = () => {
  const [reports, setReports] = useState(initialReports);
  const [selectedReportId, setSelectedReportId] = useState(initialReports[0]?.id ?? null);
  const [categoryFilter, setCategoryFilter] = useState("전체");
  const [searchTerm, setSearchTerm] = useState("");
  const [requestSort, setRequestSort] = useState({ key: "id", dir: "asc" });
  const [logSort, setLogSort] = useState({ key: "id", dir: "asc" });
  const [logStatusFilter, setLogStatusFilter] = useState("전체");
  const [showActionModal, setShowActionModal] = useState(false);
  const [showRejectModal, setShowRejectModal] = useState(false);
  const [penaltyDays, setPenaltyDays] = useState(3);
  const [penaltyType, setPenaltyType] = useState("로그인 차단");
  const [rejectReason, setRejectReason] = useState("");
  const [actionSuccess, setActionSuccess] = useState(false);

  const closeRejectModal = () => {
    setRejectReason("");
    setShowRejectModal(false);
  };

  const filteredReports = useMemo(() => {
    const term = searchTerm.trim().toLowerCase();
    return reports.filter((report) => {
      const matchCategory =
        categoryFilter === "전체" ? true : report.category === categoryFilter;

      const matchSearch = term
        ? [
            report.reporter,
            report.author,
            report.title,
            report.reason,
            report.status,
            report.category,
          ]
            .filter(Boolean)
            .some((field) => field.toLowerCase().includes(term))
        : true;

      return matchCategory && matchSearch;
    });
  }, [reports, categoryFilter, searchTerm]);

  const sortReports = (list, sort) => {
    const collator = new Intl.Collator("ko");
    const getVal = (report) => {
      switch (sort.key) {
        case "id":
          return report.id;
        case "reporter":
          return report.reporter;
        case "category":
          return report.category;
        case "author":
          return report.author;
        case "reason":
          return report.reason;
        case "title":
          return report.title;
        case "date":
          return report.date;
        case "status":
          return report.status;
        default:
          return report.id;
      }
    };

    return [...list].sort((a, b) => {
      const va = getVal(a);
      const vb = getVal(b);
      let cmp = 0;
      if (sort.key === "id") cmp = va - vb;
      else if (sort.key === "date") cmp = new Date(va).getTime() - new Date(vb).getTime();
      else cmp = collator.compare(String(va ?? ""), String(vb ?? ""));
      return sort.dir === "asc" ? cmp : -cmp;
    });
  };

  const pendingReports = useMemo(() => {
    const pending = filteredReports.filter((report) => report.status === "대기");
    return sortReports(pending, requestSort);
  }, [filteredReports, requestSort]);

  const processedReports = useMemo(() => {
    const processed = filteredReports.filter((report) => report.status !== "대기");
    const statusFiltered =
      logStatusFilter === "전체"
        ? processed
        : processed.filter((report) => report.status === logStatusFilter);
    return sortReports(statusFiltered, logSort);
  }, [filteredReports, logStatusFilter, logSort]);

  useEffect(() => {
    const hit =
      pendingReports.find((r) => r.id === selectedReportId) ||
      processedReports.find((r) => r.id === selectedReportId);
    if (!hit) {
      setSelectedReportId(pendingReports[0]?.id ?? processedReports[0]?.id ?? null);
    }
  }, [pendingReports, processedReports, selectedReportId]);

  const selectedReport = reports.find((report) => report.id === selectedReportId) || null;

  const handleActionConfirm = () => {
    if (!selectedReport) return;
    setReports((prev) =>
      prev.map((report) =>
        report.id === selectedReport.id
          ? {
              ...report,
              status: "처리 완료",
              actionNote: `${penaltyType} ${penaltyDays}일`,
            }
          : report
      )
    );
    setActionSuccess(true);
    setTimeout(() => {
      setShowActionModal(false);
      setActionSuccess(false);
    }, 1000);
  };

  const handleRejectConfirm = () => {
    if (!selectedReport) return;
    setReports((prev) =>
      prev.map((report) =>
        report.id === selectedReport.id
          ? {
              ...report,
              status: "반려",
              rejectNote: rejectReason || "사유 미입력",
            }
          : report
      )
    );
    closeRejectModal();
  };

  const toggleSort = (setter) => (key) => {
    setter((prev) =>
      prev.key === key ? { key, dir: prev.dir === "asc" ? "desc" : "asc" } : { key, dir: "asc" }
    );
  };

  const sortArrow = (sortState, key) =>
    sortState.key === key ? (sortState.dir === "asc" ? " ▲" : " ▼") : "";

  const toggleRequestSort = toggleSort(setRequestSort);
  const toggleLogSort = toggleSort(setLogSort);

  return (
    <div className="report-container">
      <div className="report-tables">
        {/* 신고 요청 리스트 */}
        <div className="report-section">
          <div className="section-title">
            <h3>신고 요청 리스트 (대기)</h3>
            <div className="search-bar">
              <select value={categoryFilter} onChange={(e) => setCategoryFilter(e.target.value)}>
                <option value="전체">전체</option>
                <option value="게시글">게시글</option>
                <option value="댓글">댓글</option>
              </select>
              <input
                type="text"
                placeholder="검색어 입력"
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
              />
            </div>
          </div>

          <table className="report-table">
            <thead>
              <tr>
                <th onClick={() => toggleRequestSort("id")}>번호{sortArrow(requestSort, "id")}</th>
                <th onClick={() => toggleRequestSort("reporter")}>
                  신고자{sortArrow(requestSort, "reporter")}
                </th>
                <th onClick={() => toggleRequestSort("category")}>
                  카테고리{sortArrow(requestSort, "category")}
                </th>
                <th onClick={() => toggleRequestSort("author")}>
                  작성자{sortArrow(requestSort, "author")}
                </th>
                <th onClick={() => toggleRequestSort("reason")}>
                  사유{sortArrow(requestSort, "reason")}
                </th>
                <th onClick={() => toggleRequestSort("title")}>
                  게시글 제목{sortArrow(requestSort, "title")}
                </th>
                <th onClick={() => toggleRequestSort("date")}>
                  요청일{sortArrow(requestSort, "date")}
                </th>
              </tr>
            </thead>
            <tbody>
              {pendingReports.map((report) => (
                <tr
                  key={report.id}
                  className={report.id === selectedReportId ? "active" : ""}
                  onClick={() => setSelectedReportId(report.id)}
                >
                  <td>{report.id}</td>
                  <td>{report.reporter}</td>
                  <td>{report.category}</td>
                  <td>{report.author}</td>
                  <td>{report.reason}</td>
                  <td>{report.title}</td>
                  <td>{report.date}</td>
                </tr>
              ))}
              {pendingReports.length === 0 && (
                <tr>
                  <td colSpan={7} className="empty-row">
                    대기 중인 신고가 없습니다.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>

        {/* 신고 처리 기록 */}
        <div className="report-section">
          <div className="section-title">
            <h3>신고 처리 기록</h3>
            <div className="search-bar">
              <select value={logStatusFilter} onChange={(e) => setLogStatusFilter(e.target.value)}>
                <option value="전체">전체</option>
                <option value="처리 완료">처리 완료</option>
                <option value="반려">반려</option>
              </select>
            </div>
          </div>

          <table className="report-table">
            <thead>
              <tr>
                <th onClick={() => toggleLogSort("id")}>번호{sortArrow(logSort, "id")}</th>
                <th onClick={() => toggleLogSort("reporter")}>
                  신고자{sortArrow(logSort, "reporter")}
                </th>
                <th onClick={() => toggleLogSort("category")}>
                  카테고리{sortArrow(logSort, "category")}
                </th>
                <th onClick={() => toggleLogSort("author")}>
                  작성자{sortArrow(logSort, "author")}
                </th>
                <th onClick={() => toggleLogSort("reason")}>
                  사유{sortArrow(logSort, "reason")}
                </th>
                <th onClick={() => toggleLogSort("title")}>
                  게시글 제목{sortArrow(logSort, "title")}
                </th>
                <th onClick={() => toggleLogSort("date")}>
                  요청일{sortArrow(logSort, "date")}
                </th>
                <th onClick={() => toggleLogSort("status")}>
                  상태{sortArrow(logSort, "status")}
                </th>
              </tr>
            </thead>
            <tbody>
              {processedReports.map((report) => (
                <tr
                  key={report.id}
                  className={report.id === selectedReportId ? "active" : ""}
                  onClick={() => setSelectedReportId(report.id)}
                >
                  <td>{report.id}</td>
                  <td>{report.reporter}</td>
                  <td>{report.category}</td>
                  <td>{report.author}</td>
                  <td>{report.reason}</td>
                  <td>{report.title}</td>
                  <td>{report.date}</td>
                  <td>
                    <span className={`status-pill status-${report.status.replace(/\s/g, "")}`}>
                      {report.status}
                    </span>
                  </td>
                </tr>
              ))}
              {processedReports.length === 0 && (
                <tr>
                  <td colSpan={8} className="empty-row">
                    처리된 신고가 없습니다.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* 우측 신고 검토 */}
      <div className="report-review">
        <h3>신고 검토</h3>
        {selectedReport ? (
          <>
            <div className="preview-header">
              <div>
                <div className="preview-title">{selectedReport.title}</div>
                <div className="preview-meta">
                  작성자 {selectedReport.author} · 신고자 {selectedReport.reporter} ·{" "}
                  {selectedReport.date}
                </div>
                {selectedReport.actionNote && (
                  <div className="preview-note">최근 조치: {selectedReport.actionNote}</div>
                )}
                {selectedReport.rejectNote && (
                  <div className="preview-note reject">반려 사유: {selectedReport.rejectNote}</div>
                )}
              </div>
              <span className={`status-pill status-${selectedReport.status.replace(/\s/g, "")}`}>
                {selectedReport.status}
              </span>
            </div>
            <div className="review-content">
              <textarea readOnly value={selectedReport.content} />
            </div>
            <div className="review-footer">
              <a
                className="preview-link"
                href={selectedReport.link}
                target="_blank"
                rel="noreferrer"
              >
                신고된 게시글 열람 (JSP)
              </a>
              {selectedReport.status === "반려" ? (
                <div className="reject-banner">반려된 신고입니다.</div>
              ) : selectedReport.status === "처리 완료" ? (
                <div className="processed-banner">
                  처리된 신고입니다.
                  {selectedReport.actionNote && (
                    <span className="processed-note">{selectedReport.actionNote}</span>
                  )}
                </div>
              ) : (
                <div className="action-buttons">
                  <button
                    className="action-btn"
                    onClick={() => setShowActionModal(true)}
                  >
                    처리
                  </button>
                  <button
                    className="reject-btn"
                    onClick={() => setShowRejectModal(true)}
                  >
                    반려
                  </button>
                </div>
              )}
            </div>
          </>
        ) : (
          <p className="empty-preview">선택된 신고가 없습니다.</p>
        )}
      </div>

      {/* 처리 팝업 */}
      {showActionModal && selectedReport && (
        <div className="modal-overlay">
          <div className="modal">
            <div className="modal-header">
              <h3>신고 처리</h3>
              <button className="close" onClick={() => setShowActionModal(false)}>
                ×
              </button>
            </div>
            <div className="modal-body">
              <p>작성자: {selectedReport.author}</p>
              <div className="punish-row">
                <label>징계:</label>
                <input
                  type="number"
                  min="1"
                  value={penaltyDays}
                  onChange={(e) => setPenaltyDays(Math.max(1, Number(e.target.value)))}
                />
                <span>일 동안</span>
                <select value={penaltyType} onChange={(e) => setPenaltyType(e.target.value)}>
                  <option value="로그인 차단">로그인 차단</option>
                  <option value="게시글 작성 제한">게시글 작성 제한</option>
                  <option value="댓글 작성 제한">댓글 작성 제한</option>
                </select>
              </div>
            </div>
            <div className="modal-footer">
              <button
                className="confirm-btn"
                onClick={handleActionConfirm}
                disabled={actionSuccess}
              >
                {actionSuccess ? "처벌처리 완료" : "승인"}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* 반려 팝업 */}
      {showRejectModal && selectedReport && (
        <div className="modal-overlay">
          <div className="modal reject">
            <div className="modal-header">
              <h3>반려 사유 입력</h3>
              <button className="close" onClick={closeRejectModal}>
                ×
              </button>
            </div>
            <div className="modal-body">
              <textarea
                placeholder="반려 사유를 입력하세요."
                value={rejectReason}
                onChange={(e) => setRejectReason(e.target.value)}
              />
            </div>
            <div className="modal-footer">
              <button className="confirm-btn" onClick={handleRejectConfirm}>
                확인
              </button>
              <button className="cancel-btn" onClick={closeRejectModal}>
                취소
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ReportManagement;
