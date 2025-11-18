import React, { useEffect, useState } from "react";
import "../styles/StadiumAlerts.css";
import {
  STADIUM_NOTIFICATION_STORAGE_KEY,
  STORAGE_EVENTS,
} from "../../common/utils/storageKeys";

const StadiumNotifications = () => {
  const [notifications, setNotifications] = useState([]);

  const loadNotifications = () => {
    try {
      const raw = localStorage.getItem(STADIUM_NOTIFICATION_STORAGE_KEY);
      if (!raw) return [];
      return JSON.parse(raw);
    } catch (err) {
      console.warn("Failed to load notifications", err);
      return [];
    }
  };

  useEffect(() => {
    setNotifications(loadNotifications());
    const handler = (event) => {
      if (event.key && event.key !== STADIUM_NOTIFICATION_STORAGE_KEY) return;
      setNotifications(loadNotifications());
    };
    const customHandler = () => setNotifications(loadNotifications());
    window.addEventListener("storage", handler);
    window.addEventListener(STORAGE_EVENTS.STADIUM_NOTIFICATIONS, customHandler);
    return () => {
      window.removeEventListener("storage", handler);
      window.removeEventListener(STORAGE_EVENTS.STADIUM_NOTIFICATIONS, customHandler);
    };
  }, []);

  return (
    <div className="stadium-alerts-page">
      <header className="alerts-header">
        <div>
          <h2>운영 알림</h2>
          <p>어드민에서 전달된 운영 지침을 확인하세요.</p>
        </div>
      </header>

      <section className="alerts-grid single">
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
      </section>
    </div>
  );
};

export default StadiumNotifications;
