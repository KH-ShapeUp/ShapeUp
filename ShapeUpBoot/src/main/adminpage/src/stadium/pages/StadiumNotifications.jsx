import React, { useEffect, useState } from "react";
import "../styles/StadiumAlerts.css";

const STORAGE_KEY = "stadium_operational_notifications";

const seedMemos = [
  { id: 1, text: "요가 강사 스케줄 업데이트 필요", date: "2025-11-14 09:40" },
  { id: 2, text: "풋살장 잔디 상태 사진 요청", date: "2025-11-14 11:15" },
];

const StadiumNotifications = () => {
  const [notifications, setNotifications] = useState([]);
  const [memos] = useState(seedMemos);

  const loadNotifications = () => {
    try {
      const raw = localStorage.getItem(STORAGE_KEY);
      if (!raw) return [];
      return JSON.parse(raw);
    } catch (err) {
      console.warn("Failed to load notifications", err);
      return [];
    }
  };

  useEffect(() => {
    setNotifications(loadNotifications());
    const handler = () => setNotifications(loadNotifications());
    window.addEventListener("storage", handler);
    return () => window.removeEventListener("storage", handler);
  }, []);

  return (
    <div className="stadium-alerts-page">
      <header className="alerts-header">
        <div>
          <h2>운영 알림 · 팀 메모</h2>
          <p>어드민에서 전달된 운영 지침을 확인하세요.</p>
        </div>
      </header>

      <section className="alerts-grid">
        <article className="alerts-card">
          <h3>운영 알림 ({notifications.length}건)</h3>
          <ul className="notification-list">
            {notifications.map((notice) => (
              <li key={notice.id}>
                <div>
                  <strong>{notice.title}</strong>
                  <p>{notice.message}</p>
                  <span>
                    대상: {notice.audience} · {notice.date}
                  </span>
                </div>
              </li>
            ))}
            {!notifications.length && <p className="empty">수신된 알림이 없습니다.</p>}
          </ul>
        </article>

        <article className="alerts-card">
          <h3>팀 메모</h3>
          <ul className="memo-list">
            {memos.map((memo) => (
              <li key={memo.id}>
                <p>{memo.text}</p>
                <span>{memo.date}</span>
              </li>
            ))}
          </ul>
        </article>
      </section>
    </div>
  );
};

export default StadiumNotifications;
