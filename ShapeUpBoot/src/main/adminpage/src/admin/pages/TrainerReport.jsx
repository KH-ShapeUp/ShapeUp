import React, { useEffect, useMemo, useState } from "react";
import "../styles/TrainerReport.css";
import {
  FACILITY_REVIEW_STORAGE_KEY,
  STORAGE_EVENTS,
  TRAINER_REPORT_STORAGE_KEY,
} from "../../common/utils/storageKeys";
import { appendInboxMessage } from "../../common/utils/messageUtils";
import CustomSelect from "../../common/components/CustomSelect";

const isBrowser = typeof window !== "undefined";

const readStorageArray = (key) => {
  if (!isBrowser) return [];
  try {
    const raw = window.localStorage.getItem(key);
    if (!raw) return [];
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [];
  } catch (err) {
    console.warn(`Failed to read ${key}`, err);
    return [];
  }
};

const writeStorageArray = (key, data, eventName) => {
  if (!isBrowser) return;
  try {
    window.localStorage.setItem(key, JSON.stringify(data));
    if (eventName) {
      window.dispatchEvent(new Event(eventName));
    }
  } catch (err) {
    console.warn(`Failed to write ${key}`, err);
  }
};

const formatDate = (iso) => {
  if (!iso) return "-";
  const date = new Date(iso);
  if (Number.isNaN(date.getTime())) return "-";
  return date.toLocaleString("ko-KR", {
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  });
};

const logFilterOptions = [
  { label: "전체", value: "전체" },
  { label: "삭제 완료", value: "삭제 완료" },
  { label: "반려", value: "반려" },
];

const TrainerReport = () => {
  const [reports, setReports] = useState(() => readStorageArray(TRAINER_REPORT_STORAGE_KEY));
  const [selectedId, setSelectedId] = useState(null);
  const [pendingSearchTerm, setPendingSearchTerm] = useState("");
  const [processedSearchTerm, setProcessedSearchTerm] = useState("");
  const [logFilter, setLogFilter] = useState("전체");
  const [rejectModal, setRejectModal] = useState({ open: false, reason: "", message: "" });
  const [deleteModal, setDeleteModal] = useState({ open: false, message: "" });
  const [feedback, setFeedback] = useState("");
  // pagination
  const [pendingPage, setPendingPage] = useState(1);
  const [pendingSize, setPendingSize] = useState(10);
  const [pendingPageInput, setPendingPageInput] = useState("");
  const [procPage, setProcPage] = useState(1);
  const [procSize, setProcSize] = useState(10);
  const [procPageInput, setProcPageInput] = useState("");

  const updateReports = (updater) => {
    setReports((prev) => {
      const next = updater(prev);
      writeStorageArray(TRAINER_REPORT_STORAGE_KEY, next, STORAGE_EVENTS.TRAINER_REPORTS);
      return next;
    });
  };

  useEffect(() => {
    if (!isBrowser) return;
    const sync = () => setReports(readStorageArray(TRAINER_REPORT_STORAGE_KEY));

    const storageHandler = (event) => {
      if (event.key && event.key !== TRAINER_REPORT_STORAGE_KEY) return;
      sync();
    };

    sync();
    window.addEventListener("storage", storageHandler);
    window.addEventListener(STORAGE_EVENTS.TRAINER_REPORTS, sync);
    return () => {
      window.removeEventListener("storage", storageHandler);
      window.removeEventListener(STORAGE_EVENTS.TRAINER_REPORTS, sync);
    };
  }, []);

  useEffect(() => {
    if (reports.length === 0) {
      setSelectedId(null);
      return;
    }
    if (selectedId && reports.some((report) => report.id === selectedId)) return;
    const pending = reports.find((report) => report.status === "대기");
    setSelectedId(pending?.id ?? reports[0].id);
  }, [reports, selectedId]);

  useEffect(() => {
    if (!feedback) return;
    const timer = setTimeout(() => setFeedback(""), 1500);
    return () => clearTimeout(timer);
  }, [feedback]);

  const matchesSearch = (report, term) => {
    const t = term.trim().toLowerCase();
    if (!t) return true;
    return [report.title, report.facility, report.reviewer, report.reportReason]
      .filter(Boolean)
      .some((field) => field.toLowerCase().includes(t));
  };

  const matchesPendingSearch = (report) => {
    const term = pendingSearchTerm.trim().toLowerCase();
    if (!term) return true;
    return [report.title, report.facility, report.reviewer, report.reportReason]
      .filter(Boolean)
      .some((field) => field.toLowerCase().includes(term));
  };

  const pendingReports = useMemo(() => {
    return reports
      .filter((report) => report.status === "대기" && matchesPendingSearch(report))
      .sort((a, b) => new Date(b.reportedAt).getTime() - new Date(a.reportedAt).getTime());
  }, [reports, pendingSearchTerm]);
  const pendingTotalPages = Math.max(1, Math.ceil(pendingReports.length / pendingSize));
  const pendingPageItems = useMemo(() => {
    const start = (pendingPage - 1) * pendingSize;
    return pendingReports.slice(start, start + pendingSize);
  }, [pendingReports, pendingPage, pendingSize]);

  const processedReports = useMemo(() => {
    return reports
      .filter((report) => report.status !== "대기" && matchesSearch(report, processedSearchTerm))
      .filter((report) => (logFilter === "전체" ? true : report.status === logFilter))
      .sort((a, b) => new Date(b.resolvedAt || b.reportedAt).getTime() - new Date(a.resolvedAt || a.reportedAt).getTime());
  }, [reports, processedSearchTerm, logFilter]);
  const procTotalPages = Math.max(1, Math.ceil(processedReports.length / procSize));
  const processedPageItems = useMemo(() => {
    const start = (procPage - 1) * procSize;
    return processedReports.slice(start, start + procSize);
  }, [processedReports, procPage, procSize]);

  useEffect(() => {
    setPendingPage(1);
  }, [pendingSearchTerm]);
  useEffect(() => {
    setProcPage(1);
  }, [processedSearchTerm, logFilter]);
  useEffect(() => {
    setPendingPage((p) => Math.min(p, pendingTotalPages));
  }, [pendingTotalPages]);
  useEffect(() => {
    setProcPage((p) => Math.min(p, procTotalPages));
  }, [procTotalPages]);

  const selectedReport = reports.find((report) => report.id === selectedId) ?? null;

  const removeReviewFromStorage = (reviewId) => {
    if (!isBrowser) return;
    const nextReviews = readStorageArray(FACILITY_REVIEW_STORAGE_KEY).filter(
      (item) => item.id !== reviewId
    );
    writeStorageArray(FACILITY_REVIEW_STORAGE_KEY, nextReviews, STORAGE_EVENTS.FACILITY_REVIEWS);
  };

  const updateReviewStatusInStorage = (reviewId, status, extra = {}) => {
    if (!isBrowser) return;
    const nextReviews = readStorageArray(FACILITY_REVIEW_STORAGE_KEY).map((item) =>
      item.id === reviewId ? { ...item, status, ...extra } : item
    );
    writeStorageArray(FACILITY_REVIEW_STORAGE_KEY, nextReviews, STORAGE_EVENTS.FACILITY_REVIEWS);
  };

  const handleDeleteConfirm = () => {
    if (!selectedReport) return;
    removeReviewFromStorage(selectedReport.reviewId);
    updateReviewStatusInStorage(selectedReport.reviewId, "삭제 완료");
    updateReports((prev) =>
      prev.map((report) =>
        report.id === selectedReport.id
          ? { ...report, status: "삭제 완료", resolvedAt: new Date().toISOString() }
          : report
      )
    );
    setDeleteModal({ open: false, message: "" });
    setFeedback("리뷰를 삭제했습니다.");
  };

  const handleRejectConfirm = () => {
    if (!rejectModal.reason.trim()) {
      setRejectModal((prev) => ({ ...prev, message: "반려 사유를 입력하세요." }));
      return;
    }
    if (!selectedReport) return;
    const reason = rejectModal.reason.trim();
    updateReports((prev) =>
      prev.map((report) =>
        report.id === selectedReport.id
          ? {
              ...report,
              status: "반려",
              rejectReason: reason,
              resolvedAt: new Date().toISOString(),
            }
          : report
      )
    );
    appendInboxMessage({
      sender: "어드민 센터",
      subject: `[반려] ${selectedReport.facility} 리뷰 신고`,
      preview: `${selectedReport.facility} 리뷰 반려 안내`,
      body: `시설 ${selectedReport.facility}의 리뷰가 반려되었습니다.\n\n[사유]\n${reason}\n\n리뷰 제목 : ${selectedReport.title}\n리뷰 내용 : ${selectedReport.content}`,
      category: "반려",
      metadata: { facility: selectedReport.facility, reviewer: selectedReport.reviewer },
    });
    updateReviewStatusInStorage(selectedReport.reviewId, "반려", { rejectReason: reason });
    setRejectModal({ open: false, reason: "", message: "" });
    setFeedback("신고를 반려했습니다.");
  };

  return (
    <div className="trainer-report-page">
      <header className="trainer-report-header">
        <div>
          <h2>트레이너 신고 관리</h2>
          <p>시설 관리자 리뷰 신고를 확인하고 조치하세요.</p>
        </div>
        <div className="report-search">
          <input
            type="text"
            placeholder="시설 / 리뷰 제목 / 회원 검색"
            value={pendingSearchTerm}
            onChange={(e) => setPendingSearchTerm(e.target.value)}
          />
        </div>
      </header>

      <section className="trainer-report-grid">
        <article className="trainer-card">
          <div className="card-header">
            <h3>대기 중 신고</h3>
            <span>{pendingReports.length}건</span>
          </div>
          <table className="trainer-table">
            <thead>
              <tr>
                <th>시설</th>
                <th>제목</th>
                <th>회원</th>
                <th>신고 사유</th>
              </tr>
            </thead>
            <tbody>
              {pendingPageItems.map((report) => (
                <tr
                  key={report.id}
                  className={report.id === selectedId ? "active" : ""}
                  onClick={() => setSelectedId(report.id)}
                >
                  <td>{report.facility}</td>
                  <td>{report.title}</td>
                  <td>{report.reviewer}</td>
                  <td>{report.reportReason}</td>
                </tr>
              ))}
              {!pendingReports.length && (
                <tr>
                  <td colSpan={4} className="empty-row">
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
            <span className="pagination-status">{pendingPage}/{pendingTotalPages}</span>
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
        </article>

        <article className="trainer-card">
          <div className="card-header">
            <h3>신고 처리 기록</h3>
            <div className="status-filter">
              <label htmlFor="logFilter">상태</label>
              <CustomSelect
                id="logFilter"
                value={logFilter}
                options={logFilterOptions}
                onChange={setLogFilter}
                size="sm"
              />
            </div>
          </div>
          <table className="trainer-table">
            <thead>
              <tr>
                <th>시설</th>
                <th>제목</th>
                <th>상태</th>
                <th>처리일</th>
              </tr>
            </thead>
            <tbody>
              {processedPageItems.map((report) => (
                (() => {
                  const statusClass = report.status.replace(/\s+/g, "-");
                  return (
                    <tr
                      key={report.id}
                      className={report.id === selectedId ? "active" : ""}
                      onClick={() => setSelectedId(report.id)}
                    >
                      <td>{report.facility}</td>
                      <td>{report.title}</td>
                      <td>
                        <span className={`status-chip status-chip--${statusClass}`}>
                          {report.status}
                        </span>
                      </td>
                      <td>{formatDate(report.resolvedAt)}</td>
                    </tr>
                  );
                })()
              ))}
              {!processedReports.length && (
                <tr>
                  <td colSpan={4} className="empty-row">
                    처리 기록이 없습니다.
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
            <span className="pagination-status">{procPage}/{procTotalPages}</span>
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
        </article>
      </section>

      <section className="trainer-detail-card">
        {selectedReport ? (
          <>
            <header>
              <h3>{selectedReport.title}</h3>
              <p>
                {selectedReport.facility} · {selectedReport.reviewer}
              </p>
            </header>
            <div className="detail-grid">
              <div className="detail-pair">
                <label>평점</label>
                <p>{selectedReport.rating?.toFixed(1)}</p>
              </div>
              <div className="detail-pair">
                <label>신고 사유</label>
                <p>{selectedReport.reportReason}</p>
              </div>
              <div className="detail-pair">
                <label>상태</label>
                <p>{selectedReport.status}</p>
              </div>
              <div className="detail-pair">
                <label>신고일</label>
                <p>{formatDate(selectedReport.reportedAt)}</p>
              </div>
            </div>
            <label>리뷰 내용</label>
            <div className="detail-body">{selectedReport.content}</div>
            {selectedReport.rejectReason && (
              <>
                <label>반려 사유</label>
                <div className="detail-body warn">{selectedReport.rejectReason}</div>
              </>
            )}
            <div className="detail-actions">
              <button
                type="button"
                className="danger"
                disabled={selectedReport.status !== "대기"}
                onClick={() => setDeleteModal({ open: true, message: "" })}
              >
                리뷰 삭제
              </button>
              <button
                type="button"
                className="secondary"
                disabled={selectedReport.status !== "대기"}
                onClick={() => setRejectModal({ open: true, reason: "", message: "" })}
              >
                반려
              </button>
            </div>
            {feedback && <p className="action-feedback">{feedback}</p>}
          </>
        ) : (
          <p className="empty-row">선택된 신고가 없습니다.</p>
        )}
      </section>

      {rejectModal.open && (
        <div className="modal-overlay" role="dialog" aria-modal="true" onClick={() => setRejectModal({ open: false, reason: "", message: "" })}>
          <div className="modal-content" onClick={(e) => e.stopPropagation()}>
            <button
              className="close-btn"
              aria-label="닫기"
              onClick={() => setRejectModal({ open: false, reason: "", message: "" })}
            >
              ×
            </button>
            <h3>신고 반려</h3>
            <textarea
              placeholder="반려 사유를 입력하세요."
              value={rejectModal.reason}
              onChange={(e) =>
                setRejectModal({ open: true, reason: e.target.value, message: "" })
              }
            />
            {rejectModal.message && <p className="modal-feedback">{rejectModal.message}</p>}
            <div className="modal-actions">
              <button className="approve" onClick={handleRejectConfirm}>
                반려 처리
              </button>
              <button
                className="reject"
                onClick={() => setRejectModal({ open: false, reason: "", message: "" })}
              >
                취소
              </button>
            </div>
          </div>
        </div>
      )}

      {deleteModal.open && (
        <div className="modal-overlay" role="dialog" aria-modal="true" onClick={() => setDeleteModal({ open: false, message: "" })}>
          <div className="modal-content" onClick={(e) => e.stopPropagation()}>
            <button
              className="close-btn"
              aria-label="닫기"
              onClick={() => setDeleteModal({ open: false, message: "" })}
            >
              ×
            </button>
            <h3>리뷰 삭제</h3>
            <p>해당 리뷰를 삭제하시겠습니까?</p>
            <div className="modal-actions">
              <button className="approve" onClick={handleDeleteConfirm}>
                삭제
              </button>
              <button className="reject" onClick={() => setDeleteModal({ open: false, message: "" })}>
                취소
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default TrainerReport;
