import React, { useEffect, useState } from "react";
import "../styles/SendGuideline.css";

const STORAGE_KEY = "stadium_operational_notifications";

const loadNotifications = () => {
  try {
    const raw = localStorage.getItem(STORAGE_KEY);
    if (!raw) return [];
    return JSON.parse(raw);
  } catch (err) {
    console.warn("Failed to parse notifications", err);
    return [];
  }
};

const persistNotifications = (records) => {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(records));
};

const SendGuideline = () => {
  const [notifications, setNotifications] = useState(() => loadNotifications());
  const [form, setForm] = useState({ title: "", message: "", audience: "전체" });
  const [status, setStatus] = useState("");

  useEffect(() => {
    const handler = () => setNotifications(loadNotifications());
    window.addEventListener("storage", handler);
    return () => window.removeEventListener("storage", handler);
  }, []);

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
    setForm({ title: "", message: "", audience: form.audience });
    setStatus("운영 지침이 전송되었습니다.");
    setTimeout(() => setStatus(""), 1500);
  };

  const handleInput = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  return (
    <div className="guideline-page">
      <header className="guideline-header">
        <div>
          <h2>운영 지침 보내기</h2>
          <p>시설 관리자에게 전달할 지침을 작성해 전송하세요.</p>
        </div>
      </header>

      <section className="guideline-card">
        <form className="guideline-form" onSubmit={handleSubmit}>
          <label>
            지침 제목
            <input
              type="text"
              name="title"
              value={form.title}
              onChange={handleInput}
              placeholder="예: 주말 운영 정책"
            />
          </label>

          <label>
            전달 대상
            <select name="audience" value={form.audience} onChange={handleInput}>
              <option value="전체">전체</option>
              <option value="시설 관리자">시설 관리자</option>
              <option value="현장 매니저">현장 매니저</option>
            </select>
          </label>

          <label>
            내용
            <textarea
              name="message"
              value={form.message}
              onChange={handleInput}
              placeholder="지침 내용을 입력하세요"
            />
          </label>

          {status && <p className="guideline-status">{status}</p>}

          <button type="submit">운영 지침 전송</button>
        </form>
      </section>

      <section className="guideline-card">
        <h3>전송 내역 ({notifications.length}건)</h3>
        <ul className="guideline-list">
          {notifications.map((item) => (
            <li key={item.id}>
              <div>
                <strong>{item.title}</strong>
                <p>{item.message}</p>
                <span>
                  대상: {item.audience} · {item.date}
                </span>
              </div>
            </li>
          ))}
          {!notifications.length && <p className="empty">전송된 지침이 없습니다.</p>}
        </ul>
      </section>
    </div>
  );
};

export default SendGuideline;
