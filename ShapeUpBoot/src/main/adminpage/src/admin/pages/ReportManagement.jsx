// src/admin/pages/ReportManagement.jsx
import React, { useEffect, useMemo, useState } from "react";
import "../styles/ReportManagement.css";
import CustomSelect from "../../common/components/CustomSelect";

const categoryOptions = ["전체", "게시글", "댓글"];
const logStatusOptions = ["전체", "처리 완료", "반려"];
const ReportManagement = () => {
  const [reports, setReports] = useState([]);
  const [selectedReportId, setSelectedReportId] = useState(null);
  const [categoryFilter, setCategoryFilter] = useState("전체");
  const [pendingSearchTerm, setPendingSearchTerm] = useState("");
  const [processedSearchTerm, setProcessedSearchTerm] = useState("");
  const [requestSort, setRequestSort] = useState({ key: "id", dir: "asc" });
  const [logSort, setLogSort] = useState({ key: "id", dir: "asc" });
  const [logStatusFilter, setLogStatusFilter] = useState("전체");
  const [showActionModal, setShowActionModal] = useState(false);
  const [showRejectModal, setShowRejectModal] = useState(false);
  const [penaltyDays, setPenaltyDays] = useState(3);
  const [rejectReason, setRejectReason] = useState("");
  const [actionSuccess, setActionSuccess] = useState(false);

  useEffect(() => {
    const fetchReports = async () => {
      try {
        const res = await fetch("/api/admin/reports");
        const json = await res.json();
        const items = Array.isArray(json.items) ? json.items : [];
        const mapStatus = (s) => {
          switch (s) {
            case "Y":
              return "승인";
            case "X":
              return "반려";
            default:
              return "대기";
          }
        };
        const mapped = items.map((r) => ({
          id: r.id,
          reporter: r.reporter || "",
          category: r.category || "",
          author: r.author || "",
          reason: r.reason || "",
          title: "-",
          date: r.date ? (r.date.length > 10 ? r.date.substring(0, 10) : r.date) : "",
          status: mapStatus(r.status),
          content: r.commentContent || "신고된 게시글 열람을 이용해주세요.",
          link: r.link || "#",
          communityNo: r.communityNo,
          commentNo: r.commentNo,
        }));
        setReports(mapped);
        setSelectedReportId(mapped[0]?.id ?? null);
      } catch (err) {
        console.error("신고 목록 로드 실패", err);
      }
    };
    fetchReports();
  }, []);

  const closeRejectModal = () => {
    setRejectReason("");
    setShowRejectModal(false);
  };

  const matchesSearch = (report, term) => {
    const t = term.trim().toLowerCase();
    if (!t) return true;
    return [report.reporter, report.author, report.title, report.reason, report.status, report.category]
      .filter(Boolean)
      .some((field) => field.toLowerCase().includes(t));
  };

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
    const pending = reports.filter((report) => report.status === "대기");
    const filtered = pending.filter(
      (r) =>
        (categoryFilter === "전체" || r.category === categoryFilter) &&
        matchesSearch(r, pendingSearchTerm)
    );
    return sortReports(filtered, requestSort);
  }, [reports, categoryFilter, pendingSearchTerm, requestSort]);

  const processedReports = useMemo(() => {
    const processed = reports.filter((report) => report.status !== "대기");
    const statusFiltered =
      logStatusFilter === "전체"
        ? processed
        : processed.filter((report) => report.status === logStatusFilter);
    const filtered = statusFiltered.filter(
      (r) =>
        (categoryFilter === "전체" || r.category === categoryFilter) &&
        matchesSearch(r, processedSearchTerm)
    );
    return sortReports(filtered, logSort);
  }, [reports, categoryFilter, processedSearchTerm, logStatusFilter, logSort]);

  // pagination settings (pending)
  const [pendingPage, setPendingPage] = useState(1);
  const [pendingSize, setPendingSize] = useState(10);
  const [pendingPageInput, setPendingPageInput] = useState("");
  const pendingTotalPages = Math.max(1, Math.ceil(pendingReports.length / pendingSize));
  const pendingPageItems = useMemo(() => {
    const start = (pendingPage - 1) * pendingSize;
    return pendingReports.slice(start, start + pendingSize);
  }, [pendingReports, pendingPage, pendingSize]);

  // pagination settings (processed)
  const [procPage, setProcPage] = useState(1);
  const [procSize, setProcSize] = useState(10);
  const [procPageInput, setProcPageInput] = useState("");
  const procTotalPages = Math.max(1, Math.ceil(processedReports.length / procSize));
  const processedPageItems = useMemo(() => {
    const start = (procPage - 1) * procSize;
    return processedReports.slice(start, start + procSize);
  }, [processedReports, procPage, procSize]);

  useEffect(() => {
    setPendingPage(1);
  }, [pendingSearchTerm, categoryFilter]);

  useEffect(() => {
    setProcPage(1);
  }, [processedSearchTerm, categoryFilter, logStatusFilter]);

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
    const qs = new URLSearchParams({
      banDays: String(penaltyDays),
      userStatus: "정지",
    }).toString();
    fetch(`/api/admin/reports/${selectedReport.id}/approve?${qs}`, { method: "POST" })
      .then(() => {
        setReports((prev) =>
          prev.map((report) =>
            report.id === selectedReport.id
              ? { ...report, status: "승인", actionNote: `로그인 차단 ${penaltyDays}일` }
              : report
          )
        );
        setActionSuccess(true);
        setTimeout(() => {
          setShowActionModal(false);
          setActionSuccess(false);
        }, 1000);
      })
      .catch(console.error);
  };

  const handleRejectConfirm = () => {
    if (!selectedReport) return;
    fetch(`/api/admin/reports/${selectedReport.id}/reject`, { method: "POST" })
      .then(() => {
        setReports((prev) =>
          prev.map((report) =>
            report.id === selectedReport.id
              ? { ...report, status: "반려", rejectNote: rejectReason || "사유 미입력" }
              : report
          )
        );
        closeRejectModal();
      })
      .catch(console.error);
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
          <header className="title-header">
        <div>
          <h2>회원 신고 관리</h2>
          <p>회원들의 신고를 확인하고 조치하세요.</p>
        </div>
      </header>
      <div className="report-tables">
        {/* 신고 요청 리스트 */}
        <div className="report-section">
          <div className="section-title">
            <h3>신고 요청 리스트 (대기)</h3>
            <div className="search-bar">
              <CustomSelect
                value={categoryFilter}
                options={categoryOptions}
                onChange={setCategoryFilter}
              />
              <input
                type="text"
                placeholder="검색어 입력"
                value={pendingSearchTerm}
                onChange={(e) => setPendingSearchTerm(e.target.value)}
              />
              <CustomSelect
                value={String(pendingSize)}
                options={[5, 10, 20, 50].map((sz) => ({ label: `${sz}개`, value: String(sz) }))}
                onChange={(val) => { setPendingSize(Number(val)); setPendingPage(1); }}
                size="sm"
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
              {pendingPageItems.map((report) => (
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
          <div className="pagination-controls">
            <button
              type="button"
              onClick={() => setPendingPage((p) => Math.max(1, p - 1))}
              disabled={pendingPage === 1}
            >
              이전
            </button>
            <span className="pagination-status">{pendingPage} / {pendingTotalPages}</span>
            <input
              type="number"
              min="1"
              max={pendingTotalPages}
              className="pagination-input"
              value={pendingPageInput}
              placeholder="페이지 입력"
              onChange={(e) => setPendingPageInput(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter") {
                  const v = Number(e.currentTarget.value);
                  if (!Number.isNaN(v) && v >= 1 && v <= pendingTotalPages) {
                    setPendingPage(v);
                    setPendingPageInput("");
                  }
                }
              }}
            />
            <button
              type="button"
              onClick={() => setPendingPage((p) => Math.min(pendingTotalPages, p + 1))}
              disabled={pendingPage === pendingTotalPages}
            >
              다음
            </button>
          </div>
        </div>

        {/* 신고 처리 기록 */}
        <div className="report-section">
          <div className="section-title">
            <h3>신고 처리 기록</h3>
            <div className="search-bar">
              <CustomSelect
                value={logStatusFilter}
                options={logStatusOptions}
                onChange={setLogStatusFilter}
              />
                <input
                  type="text"
                  placeholder="검색어 입력"
                  value={processedSearchTerm}
                  onChange={(e) => setProcessedSearchTerm(e.target.value)}
                />
              <CustomSelect
                value={String(procSize)}
                options={[5, 10, 20, 50].map((sz) => ({ label: `${sz}개`, value: String(sz) }))}
                onChange={(val) => { setProcSize(Number(val)); setProcPage(1); }}
                size="sm"
              />
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
              {processedPageItems.map((report) => (
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
          <div className="pagination-controls">
            <button
              type="button"
              onClick={() => setProcPage((p) => Math.max(1, p - 1))}
              disabled={procPage === 1}
            >
              이전
            </button>
            <span className="pagination-status">{procPage} / {procTotalPages}</span>
            <input
              type="number"
              min="1"
              max={procTotalPages}
              className="pagination-input"
              value={procPageInput}
              placeholder="페이지 입력"
              onChange={(e) => setProcPageInput(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter") {
                  const v = Number(e.currentTarget.value);
                  if (!Number.isNaN(v) && v >= 1 && v <= procTotalPages) {
                    setProcPage(v);
                    setProcPageInput("");
                  }
                }
              }}
            />
            <button
              type="button"
              onClick={() => setProcPage((p) => Math.min(procTotalPages, p + 1))}
              disabled={procPage === procTotalPages}
            >
              다음
            </button>
          </div>
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
              ) : selectedReport.status === "승인" ? (
                <div className="processed-banner" style={{ background: "#e6f9ea", color: "#1d5c3a" }}>
                  승인되었습니다.
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
                <span className="penalty-label">로그인 차단</span>
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
