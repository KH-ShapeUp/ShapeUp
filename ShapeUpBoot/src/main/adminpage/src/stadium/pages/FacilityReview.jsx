import React, { useEffect, useMemo, useRef, useState } from "react";
import "../../common/styles/CommonLayout.css";
import "../styles/FacilityReview.css";
import { useFacilityData } from "../context/FacilityDataContext";
import {
  FACILITY_REVIEW_STORAGE_KEY,
  STORAGE_EVENTS,
  TRAINER_REPORT_STORAGE_KEY,
} from "../../common/utils/storageKeys";
import { appendInboxMessage } from "../../common/utils/messageUtils";
import CustomSelect from "../../common/components/CustomSelect";

const baseReviews = [
  {
    id: 1,
    facility: "시설 1",
    member: "runner_kim",
    date: "2025.12.10",
    rating: 4.5,
    title: "러닝머신 상태가 좋아요",
    content: "최근에 러닝머신을 교체해 주셔서 사용감이 훨씬 좋아졌습니다.",
    status: "대기",
    mailNotified: false,
  },
  {
    id: 2,
    facility: "시설 1",
    member: "lee_cardio",
    date: "2025.12.11",
    rating: 2,
    title: "트레이너 언행이 거슬렸어요",
    content: "PT 진행 중 트레이너가 반말을 해서 불쾌했습니다.",
    status: "대기",
    mailNotified: false,
  },
  {
    id: 3,
    facility: "시설 2",
    member: "swim_jy",
    date: "2025.12.11",
    rating: 5,
    title: "수영장 수질 최고",
    content: "물 온도와 수질 관리가 뛰어나요.",
    status: "대기",
    mailNotified: false,
  },
  {
    id: 4,
    facility: "시설 2",
    member: "chloe_fit",
    date: "2025.12.12",
    rating: 1.5,
    title: "락커룸 위생 문제",
    content: "청소가 제대로 되지 않아 냄새가 심합니다.",
    status: "대기",
    mailNotified: false,
  },
  {
    id: 5,
    facility: "시설 3",
    member: "park_gym",
    date: "2025.12.13",
    rating: 3,
    title: "예약 시스템 오류",
    content: "모바일에서 예약이 자꾸 끊깁니다.",
    status: "대기",
    mailNotified: false,
  },
];

const facilityTabs = ["전체", "시설 1", "시설 2", "시설 3"];

const statusFilterOptions = [
  { label: "전체", value: "전체" },
  { label: "대기", value: "대기" },
  { label: "신고 완료", value: "신고 완료" },
  { label: "반려", value: "반려" },
];

const pageSizeOptions = [
  { label: "5개", value: 5 },
  { label: "10개", value: 10 },
  { label: "20개", value: 20 },
];

const isBrowser = typeof window !== "undefined";

const readStorageArray = (key, fallback = []) => {
  if (!isBrowser) return fallback;
  try {
    const raw = window.localStorage.getItem(key);
    if (!raw) return fallback;
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : fallback;
  } catch (err) {
    console.warn(`Failed to read storage for ${key}`, err);
    return fallback;
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
    console.warn(`Failed to write storage for ${key}`, err);
  }
};

const loadInitialReviews = () => {
  const stored = readStorageArray(FACILITY_REVIEW_STORAGE_KEY, null);
  if (stored && stored.length) return stored;
  if (stored && !stored.length) return stored;
  writeStorageArray(FACILITY_REVIEW_STORAGE_KEY, baseReviews);
  return baseReviews;
};

const FacilityReview = () => {
  const { facilities } = useFacilityData();
  const [reviews, setReviews] = useState(() => loadInitialReviews());
  const [selectedFacility, setSelectedFacility] = useState("전체");
  const [selectedId, setSelectedId] = useState(baseReviews[0]?.id ?? null);
  const [reportModal, setReportModal] = useState({
    open: false,
    review: null,
    reason: "",
    message: "",
  });
  const [statusFilter, setStatusFilter] = useState("전체");
  const [pageSize, setPageSize] = useState(10);
  const [page, setPage] = useState(1);
  const timerRef = useRef(null);

  useEffect(() => {
    return () => {
      if (timerRef.current) clearTimeout(timerRef.current);
    };
  }, []);

  useEffect(() => {
    if (!isBrowser) return;
    writeStorageArray(FACILITY_REVIEW_STORAGE_KEY, reviews);
  }, [reviews]);

  useEffect(() => {
    if (!isBrowser) return;
    const sync = () => {
      setReviews(readStorageArray(FACILITY_REVIEW_STORAGE_KEY, baseReviews));
    };
    const storageHandler = (event) => {
      if (event.key && event.key !== FACILITY_REVIEW_STORAGE_KEY) return;
      sync();
    };
    window.addEventListener("storage", storageHandler);
    window.addEventListener(STORAGE_EVENTS.FACILITY_REVIEWS, sync);
    return () => {
      window.removeEventListener("storage", storageHandler);
      window.removeEventListener(STORAGE_EVENTS.FACILITY_REVIEWS, sync);
    };
  }, []);

  useEffect(() => {
    let needUpdate = false;
    const nextReviews = reviews.map((review) => {
      if (!review.mailNotified) {
        appendInboxMessage({
          sender: "회원 리뷰",
          subject: `[리뷰] ${review.facility} - ${review.title}`,
          preview: `${review.member} · ${review.facility}`,
          body: review.content,
          category: "리뷰",
          metadata: { facility: review.facility, reviewer: review.member },
        });
        needUpdate = true;
        return { ...review, mailNotified: true };
      }
      return review;
    });
    if (needUpdate) {
      setReviews(nextReviews);
    }
  }, [reviews, setReviews]);

  const facilityFilters = useMemo(() => {
    const all = new Set([...facilityTabs, ...facilities]);
    return Array.from(all);
  }, [facilities]);

  const filteredReviews = useMemo(() => {
    return reviews
      .filter((review) => selectedFacility === "전체" || review.facility === selectedFacility)
      .filter((review) => (statusFilter === "전체" ? true : review.status === statusFilter));
  }, [reviews, selectedFacility, statusFilter]);

  const totalPages = Math.max(1, Math.ceil(filteredReviews.length / pageSize));
  const currentPage = Math.min(page, totalPages);
  const pageStart = (currentPage - 1) * pageSize;
  const paginatedReviews = filteredReviews.slice(pageStart, pageStart + pageSize);

  useEffect(() => {
    if (!filteredReviews.some((item) => item.id === selectedId)) {
      setSelectedId(filteredReviews[0]?.id ?? null);
    }
  }, [filteredReviews, selectedId]);

  useEffect(() => {
    setPage(1);
  }, [selectedFacility, statusFilter, pageSize]);

  const selectedReview = reviews.find((review) => review.id === selectedId) ?? null;

  const openReportModal = (review) =>
    setReportModal({ open: true, review, reason: "", message: "" });

  const closeReportModal = () => {
    setReportModal({ open: false, review: null, reason: "", message: "" });
    if (timerRef.current) {
      clearTimeout(timerRef.current);
      timerRef.current = null;
    }
  };

  const appendTrainerReport = (review, reason) => {
    if (!isBrowser) return;
    const existing = readStorageArray(TRAINER_REPORT_STORAGE_KEY, []);
    const alreadyPending = existing.some(
      (entry) => entry.reviewId === review.id && entry.status === "대기"
    );
    if (alreadyPending) return;
    const payload = {
      id: Date.now(),
      reviewId: review.id,
      facility: review.facility,
      reviewer: review.member,
      title: review.title,
      content: review.content,
      rating: review.rating,
      reportReason: reason,
      status: "대기",
      reportedAt: new Date().toISOString(),
    };
    writeStorageArray(
      TRAINER_REPORT_STORAGE_KEY,
      [payload, ...existing],
      STORAGE_EVENTS.TRAINER_REPORTS
    );
  };

  const handleReportSubmit = () => {
    if (!reportModal.reason.trim()) {
      setReportModal((prev) => ({ ...prev, message: "신고 사유를 입력하세요." }));
      return;
    }

    setReviews((prev) =>
      prev.map((review) =>
        review.id === reportModal.review.id
          ? { ...review, status: "신고 완료", reportReason: reportModal.reason }
          : review
      )
    );
    appendTrainerReport(reportModal.review, reportModal.reason);

    setReportModal((prev) => ({ ...prev, message: "신고되었습니다." }));

    timerRef.current = setTimeout(() => {
      closeReportModal();
    }, 1000);
  };

  return (
    <div className="review-container">
      <div className="review-header">
        <div>
          <h3>시설 리뷰 관리</h3>
          <p>시설별 리뷰를 확인하고 필요한 경우 본사에 신고하세요.</p>
        </div>
        <div className="review-header-controls">
          <div className="facility-filter-group">
            {facilityFilters.map((label) => (
              <button
                key={label}
                type="button"
                className={selectedFacility === label ? "active" : ""}
                onClick={() => setSelectedFacility(label)}
              >
                {label}
              </button>
            ))}
          </div>
          <div className="review-controls">
            <CustomSelect
              value={statusFilter}
              options={statusFilterOptions}
              onChange={setStatusFilter}
              size="sm"
            />
            <CustomSelect
              value={String(pageSize)}
              options={pageSizeOptions}
              onChange={(val) => setPageSize(Number(val))}
              size="sm"
            />
          </div>
        </div>
      </div>

      <div className="review-content">
        <div className="review-list">
          <table className="review-table">
            <thead>
              <tr>
                <th>번호</th>
                <th>시설</th>
                <th>회원</th>
                <th>평점</th>
                <th>제목</th>
                <th>상태</th>
                <th>신고</th>
              </tr>
            </thead>
            <tbody>
              {paginatedReviews.map((review) => (
                <tr
                  key={review.id}
                  className={review.id === selectedId ? "active" : ""}
                  onClick={() => setSelectedId(review.id)}
                >
                  <td>{review.id}</td>
                  <td>{review.facility}</td>
                  <td>{review.member}</td>
                  <td>{review.rating.toFixed(1)}</td>
                  <td className="title-cell">{review.title}</td>
                  <td>
                    <span
                      className={`status-chip ${
                        review.status === "신고 완료"
                          ? "status-chip--reported"
                          : review.status === "반려"
                          ? "status-chip--warn"
                          : ""
                      }`}
                    >
                      {review.status}
                    </span>
                  </td>
                  <td>
                    <button
                      type="button"
                      className="report-btn"
                      onClick={(e) => {
                        e.stopPropagation();
                        openReportModal(review);
                      }}
                      disabled={review.status !== "대기"}
                    >
                      {review.status === "신고 완료" ? "신고됨" : review.status === "반려" ? "반려됨" : "신고"}
                    </button>
                  </td>
                </tr>
              ))}
              {!filteredReviews.length && (
                <tr>
                  <td colSpan={7} className="empty-row">
                    선택한 시설에 등록된 리뷰가 없습니다.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
          <div className="review-pagination">
            <button
              type="button"
              onClick={() => setPage((prev) => Math.max(1, prev - 1))}
              disabled={currentPage === 1}
            >
              이전
            </button>
            <span>
              {currentPage} / {totalPages}
            </span>
            <button
              type="button"
              onClick={() => setPage((prev) => Math.min(totalPages, prev + 1))}
              disabled={currentPage === totalPages}
            >
              다음
            </button>
          </div>
        </div>

        <div className="review-detail">
          {selectedReview ? (
            <>
              <div className="detail-header">
                <div>
                  <h4>{selectedReview.title}</h4>
                  <p>
                    {selectedReview.facility} · {selectedReview.member} · {selectedReview.date}
                  </p>
                </div>
                <div className="detail-rating">
                  <strong>{selectedReview.rating.toFixed(1)}</strong>
                  <span>/ 5.0</span>
                </div>
              </div>

              <div className="detail-body">
                <p>{selectedReview.content}</p>
                {selectedReview.reportReason && (
                  <div className="reported-note">
                    <strong>신고 사유</strong>
                    <p>{selectedReview.reportReason}</p>
                  </div>
                )}
                {selectedReview.rejectReason && (
                  <div className="reject-note">
                    <strong>반려 사유</strong>
                    <p>{selectedReview.rejectReason}</p>
                  </div>
                )}
              </div>

              <div className="detail-actions">
                <button
                  type="button"
                  onClick={() => openReportModal(selectedReview)}
                  disabled={selectedReview.status !== "대기"}
                >
                  {selectedReview.status === "신고 완료"
                    ? "신고 완료"
                    : selectedReview.status === "반려"
                    ? "반려됨"
                    : "관리자에게 신고"}
                </button>
              </div>
            </>
          ) : (
            <p className="empty-state">리뷰를 선택하면 상세 내용이 표시됩니다.</p>
          )}
        </div>
      </div>

      {reportModal.open && reportModal.review && (
        <div className="modal-overlay" role="dialog" aria-modal="true" onClick={closeReportModal}>
          <div className="modal-content" onClick={(e) => e.stopPropagation()}>
            <button className="close-btn" onClick={closeReportModal} aria-label="닫기">
              ×
            </button>
            <h3>리뷰 신고</h3>
            <p>
              대상 리뷰: <strong>{reportModal.review.title}</strong>
            </p>
            <textarea
              placeholder="신고 사유를 입력하세요."
              value={reportModal.reason}
              onChange={(e) =>
                setReportModal((prev) => ({ ...prev, reason: e.target.value, message: "" }))
              }
              disabled={Boolean(reportModal.message)}
            />
            {reportModal.message && <p className="modal-feedback">{reportModal.message}</p>}
            {!reportModal.message && (
              <button className="submit-btn" onClick={handleReportSubmit}>
                신고 보내기
              </button>
            )}
          </div>
        </div>
      )}
    </div>
  );
};

export default FacilityReview;
