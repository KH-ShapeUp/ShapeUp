import React, { useEffect, useRef, useState } from "react";
import "../styles/SendGuideline.css";
import { appendInboxMessage } from "../../common/utils/messageUtils";
import {
  STADIUM_NOTIFICATION_STORAGE_KEY,
  STORAGE_EVENTS,
} from "../../common/utils/storageKeys";
import CustomSelect from "../../common/components/CustomSelect";

const loadNotifications = () => {
  try {
    const raw = localStorage.getItem(STADIUM_NOTIFICATION_STORAGE_KEY);
    if (!raw) return [];
    return JSON.parse(raw);
  } catch (err) {
    console.warn("Failed to parse notifications", err);
    return [];
  }
};

const persistNotifications = (records) => {
  localStorage.setItem(STADIUM_NOTIFICATION_STORAGE_KEY, JSON.stringify(records));
  window.dispatchEvent(new Event(STORAGE_EVENTS.STADIUM_NOTIFICATIONS));
};

const SendGuideline = () => {
  const [notifications, setNotifications] = useState(() => loadNotifications());
  const [form, setForm] = useState({ title: "", message: "", audience: "전체" });
  const [status, setStatus] = useState("");
  const [deleteModal, setDeleteModal] = useState({ open: false, status: "confirm", id: null });
  const statusTimerRef = useRef(null);
  const deleteTimerRef = useRef(null);

  useEffect(() => {
    const handler = () => setNotifications(loadNotifications());
    window.addEventListener("storage", handler);
    return () => {
      window.removeEventListener("storage", handler);
      if (statusTimerRef.current) clearTimeout(statusTimerRef.current);
      if (deleteTimerRef.current) clearTimeout(deleteTimerRef.current);
    };
  }, []);

  const showStatus = (message) => {
    setStatus(message);
    if (statusTimerRef.current) clearTimeout(statusTimerRef.current);
    statusTimerRef.current = setTimeout(() => {
      setStatus("");
      statusTimerRef.current = null;
    }, 1500);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!form.title.trim() || !form.message.trim()) {
      setStatus("제목과 내용을 입력하세요.");
      return;
    }
    const entry = {
      id: Date.now(),
      title: form.title.trim(),
      message: form.message.trim(),
      audience: form.audience,
      date: new Date().toLocaleString(),
    };
    const next = [entry, ...notifications];
    setNotifications(next);
    persistNotifications(next);
    appendInboxMessage({
      sender: "어드민 센터",
      subject: entry.title,
      preview: entry.message.slice(0, 80),
      body: entry.message,
      category: "운영 지침",
      metadata: { audience: entry.audience },
    });
    setForm({ title: "", message: "", audience: form.audience });
    showStatus("운영 지침이 전송되었습니다.");
  };

  const handleInput = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const openDeleteModal = (id) => {
    setDeleteModal({ open: true, status: "confirm", id });
  };

  const closeDeleteModal = () => {
    setDeleteModal({ open: false, status: "confirm", id: null });
  };

  const handleDeleteConfirm = () => {
    if (!deleteModal.id) return;
    const next = notifications.filter((item) => item.id !== deleteModal.id);
    setNotifications(next);
    persistNotifications(next);
    setDeleteModal((prev) => ({ ...prev, status: "done" }));
    deleteTimerRef.current = setTimeout(() => {
      closeDeleteModal();
    }, 1000);
  };

  return (
    <div className="guideline-page">
    <header className="title-header">
        <div>
          <h2>회원 관리</h2>
          <p>회원 정보를 조회하고 상태를 변경하거나 비밀번호를 초기화하세요.</p>
        </div>
      </header>

      <section className="guideline-card">
        <form className="guideline-form" onSubmit={handleSubmit}>
          <div className="form-row">
            <label htmlFor="titleInput">지침 제목</label>
            <input
              id="titleInput"
              type="text"
              name="title"
              value={form.title}
              onChange={handleInput}
              placeholder="예: 주말 운영 정책"
            />
          </div>

          <div className="form-row">
            <label>전달 대상</label>
            <CustomSelect
              value={form.audience}
              options={[
                { label: "전체", value: "전체" },
                { label: "시설 관리자", value: "시설 관리자" },
                { label: "트레이너", value: "트레이너" },
              ]}
              onChange={(val) => setForm((prev) => ({ ...prev, audience: val }))}
            />
          </div>

          <div className="form-row textarea-row">
            <label htmlFor="messageInput">내용</label>
            <textarea
              id="messageInput"
              name="message"
              value={form.message}
              onChange={handleInput}
              placeholder="지침 내용을 입력하세요"
            />
          </div>

          {status && <p className="guideline-status">{status}</p>}

          <button type="submit">운영 지침 전송</button>
        </form>
      </section>

      <section className="guideline-card">
        <h3>전송 내역 ({notifications.length}건)</h3>
        <ul className="guideline-list">
          {notifications.map((item) => (
            <li key={item.id}>
              <div className="guideline-item">
                <div>
                  <strong>{item.title}</strong>
                  <p>{item.message}</p>
                  <span>
                    대상: {item.audience} · {item.date}
                  </span>
                </div>
                <button
                  type="button"
                  className="guideline-delete"
                  onClick={() => openDeleteModal(item.id)}
                >
                  삭제
                </button>
              </div>
            </li>
          ))}
          {!notifications.length && <p className="empty">전송된 지침이 없습니다.</p>}
        </ul>
      </section>

      {deleteModal.open && (
        <div className="modal-overlay" role="dialog" aria-modal="true" onClick={closeDeleteModal}>
          <div className="modal delete" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h3>지침 삭제</h3>
              {deleteModal.status === "confirm" && (
                <button className="close" onClick={closeDeleteModal}>
                  ×
                </button>
              )}
            </div>
            <div className="modal-body">
              {deleteModal.status === "confirm" ? "삭제하시겠습니까?" : "삭제되었습니다."}
            </div>
            {deleteModal.status === "confirm" && (
              <div className="modal-footer">
                <button className="confirm-btn" onClick={handleDeleteConfirm}>
                  예
                </button>
                <button className="cancel-btn" onClick={closeDeleteModal}>
                  아니요
                </button>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
};

export default SendGuideline;
