import React, { useEffect, useMemo, useRef, useState } from "react";
import "../styles/StadiumMail.css";
import { appendInboxMessage, readInboxMessages, deleteInboxMessage, clearInboxMessages } from "../../common/utils/messageUtils";
import {
  STORAGE_EVENTS,
  STADIUM_MAINTENANCE_STORAGE_KEY,
} from "../../common/utils/storageKeys";

const isBrowser = typeof window !== "undefined";

const processMaintenanceMessages = () => {
  if (!isBrowser) return;
  try {
    const raw = window.localStorage.getItem(STADIUM_MAINTENANCE_STORAGE_KEY);
    if (!raw) return;
    const tasks = JSON.parse(raw);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    let updated = false;
    const next = tasks.map((task) => {
      if (task.mailNotified || task.status === "완료") return task;
      if (!task.due) return task;
      const cleaned = task.due.replace(/[^\d.]/g, ".");
      const parts = cleaned.split(".").filter(Boolean);
      if (parts.length < 2) return task;
      const year = parts.length === 3 ? Number(parts[0]) : today.getFullYear();
      const month = Number(parts[parts.length - 2]);
      const day = Number(parts[parts.length - 1]);
      const dueDate = new Date(year, month - 1, day);
      if (Number.isNaN(dueDate.getTime())) return task;
      const diff = Math.floor((dueDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));
      if (diff >= 0 && diff <= 3) {
        appendInboxMessage({
          sender: "시스템",
          subject: `[점검 예정] ${task.title}`,
          preview: `${task.facility} · ${task.due} 예정`,
          body: `${task.facility} 시설 점검 일정이 ${diff}일 남았습니다.`,
          category: "시설 점검",
          metadata: { facility: task.facility, due: task.due },
        });
        updated = true;
        return { ...task, mailNotified: true };
      }
      return task;
    });
    if (updated) {
      window.localStorage.setItem(STADIUM_MAINTENANCE_STORAGE_KEY, JSON.stringify(next));
    }
  } catch (err) {
    console.warn("Failed to process maintenance mails", err);
  }
};

const StadiumMail = () => {
  const [messages, setMessages] = useState(() => readInboxMessages());
  const [selectedId, setSelectedId] = useState(() => {
    const initialList = readInboxMessages();
    return initialList[0]?.id ?? null;
  });
  const [filter, setFilter] = useState("전체");
  const [deleteModal, setDeleteModal] = useState({ open: false, status: "confirm", id: null });
  const deleteTimerRef = useRef(null);
  const filterOptions = ["전체", "리뷰", "시스템", "반려"];

  useEffect(() => {
    processMaintenanceMessages();
  }, []);

  useEffect(() => {
    const sync = () => {
      const list = readInboxMessages();
      setMessages(list);
      if (!list.some((item) => item.id === selectedId)) {
        setSelectedId(list[0]?.id ?? null);
      }
    };
    window.addEventListener(STORAGE_EVENTS.STADIUM_MESSAGES, sync);
    return () => {
      window.removeEventListener(STORAGE_EVENTS.STADIUM_MESSAGES, sync);
      if (deleteTimerRef.current) clearTimeout(deleteTimerRef.current);
    };
  }, [selectedId]);

  const filteredMessages = useMemo(() => {
    return messages.filter((msg) => {
      switch (filter) {
        case "리뷰":
          return msg.category === "리뷰";
        case "시스템":
          return msg.sender === "시스템" || msg.category === "시설 점검" || msg.category === "운영 지침";
        case "반려":
          return msg.category === "반려";
        default:
          return true;
      }
    });
  }, [messages, filter]);

  useEffect(() => {
    if (!filteredMessages.length) {
      setSelectedId(null);
      return;
    }
    if (!selectedId || !filteredMessages.some((msg) => msg.id === selectedId)) {
      setSelectedId(filteredMessages[0].id);
    }
  }, [filteredMessages, selectedId]);

  const selected = filteredMessages.find((msg) => msg.id === selectedId) ?? null;

  const openDeleteModal = (id) => {
    setDeleteModal({ open: true, status: "confirm", id });
  };

  const closeDeleteModal = () => {
    setDeleteModal({ open: false, status: "confirm", id: null });
  };

  const handleDeleteConfirm = () => {
    if (!deleteModal.id) return;
    deleteInboxMessage(deleteModal.id);
    setDeleteModal((prev) => ({ ...prev, status: "done" }));
    deleteTimerRef.current = setTimeout(() => {
      closeDeleteModal();
    }, 1000);
  };

  return (
    <div className="mail-page">
      <div className="mail-list-card">
        <div className="mail-header">
          <div>
            <h3>받은 쪽지</h3>
            <span>{filteredMessages.length}건</span>
          </div>
          <div className="mail-filter-group">
            {filterOptions.map((label) => (
              <button
                key={label}
                type="button"
                className={filter === label ? "active" : ""}
                onClick={() => setFilter(label)}
              >
                {label}
              </button>
            ))}
            <button type="button" className="clear-btn" onClick={clearInboxMessages}>
              초기화
            </button>
          </div>
        </div>
        <ul className="mail-list">
          {filteredMessages.map((msg) => (
            <li
              key={msg.id}
              className={msg.id === selectedId ? "active" : ""}
              onClick={() => setSelectedId(msg.id)}
            >
              <div className="mail-subject">{msg.subject}</div>
              <div className="mail-meta">
                <span>{msg.sender}</span>
                <span>{msg.date}</span>
              </div>
              <p>{msg.preview}</p>
            </li>
          ))}
          {!filteredMessages.length && <p className="empty">조건에 맞는 쪽지가 없습니다.</p>}
        </ul>
      </div>

      <div className="mail-detail-card">
        {selected ? (
          <>
            <div className="mail-detail-header">
              <div>
                <h4>{selected.subject}</h4>
                <p>
                  {selected.sender} · {selected.date}
                </p>
              </div>
              <button type="button" onClick={() => openDeleteModal(selected.id)}>
                삭제
              </button>
            </div>
            <div className="mail-detail-body">
              <p>{selected.body || selected.preview}</p>
              {selected.metadata?.facility && (
                <div className="mail-detail-meta">대상 시설: {selected.metadata.facility}</div>
              )}
              {selected.metadata?.audience && (
                <div className="mail-detail-meta">대상: {selected.metadata.audience}</div>
              )}
            </div>
          </>
        ) : (
          <p className="empty">쪽지를 선택하세요.</p>
        )}
      </div>

      {deleteModal.open && (
        <div className="modal-overlay" role="dialog" aria-modal="true" onClick={closeDeleteModal}>
          <div className="modal delete" onClick={(e) => e.stopPropagation()}>
            <div className="modal-header">
              <h3>쪽지 삭제</h3>
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

export default StadiumMail;
