import React, { useState } from "react";
import "../styles/StadiumAlerts.css";

const seedNotifications = [
  { id: 1, text: "11/14 10:00 시설 관리자 미팅", pinned: false },
  { id: 2, text: "신규 단체 이용 문의 2건 접수", pinned: true },
  { id: 3, text: "세금계산서 발행 마감 D-3", pinned: false },
];

const seedMemos = [
  { id: 1, text: "요가 강사 스케줄 업데이트 필요", date: "2025-11-14 09:40" },
  { id: 2, text: "풋살장 잔디 상태 사진 요청", date: "2025-11-14 11:15" },
];

const StadiumNotifications = () => {
  const [notifications, setNotifications] = useState(seedNotifications);
  const [memos, setMemos] = useState(seedMemos);
  const [noticeDraft, setNoticeDraft] = useState("");
  const [memoDraft, setMemoDraft] = useState("");

  const addNotification = () => {
    if (!noticeDraft.trim()) return;
    setNotifications((prev) => [
      { id: Date.now(), text: noticeDraft.trim(), pinned: false },
      ...prev,
    ]);
    setNoticeDraft("");
  };

  const togglePin = (id) => {
    setNotifications((prev) =>
      prev.map((notice) => (notice.id === id ? { ...notice, pinned: !notice.pinned } : notice))
    );
  };

  const addMemo = () => {
    if (!memoDraft.trim()) return;
    const stamp = new Date().toLocaleString();
    setMemos((prev) => [{ id: Date.now(), text: memoDraft.trim(), date: stamp }, ...prev]);
    setMemoDraft("");
  };

  const sortedNotifications = [...notifications].sort((a, b) => Number(b.pinned) - Number(a.pinned));

  return (
    <div className="stadium-alerts-page">
      <header className="alerts-header">
        <div>
          <h2>운영 알림 · 팀 메모</h2>
          <p>현장 관리자에게 전달할 공지와 메모를 관리합니다.</p>
        </div>
      </header>

      <section className="alerts-grid">
        <article className="alerts-card">
          <h3>운영 알림</h3>
          <div className="alert-form">
            <textarea
              placeholder="알림 내용을 입력하세요"
              value={noticeDraft}
              onChange={(e) => setNoticeDraft(e.target.value)}
            />
            <button type="button" onClick={addNotification}>
              알림 추가
            </button>
          </div>
          <ul className="notification-list">
            {sortedNotifications.map((notice) => (
              <li key={notice.id} className={notice.pinned ? "pinned" : ""}>
                <p>{notice.text}</p>
                <button type="button" onClick={() => togglePin(notice.id)}>
                  {notice.pinned ? "고정 해제" : "상단 고정"}
                </button>
              </li>
            ))}
          </ul>
        </article>

        <article className="alerts-card">
          <h3>팀 메모</h3>
          <div className="memo-form">
            <textarea
              placeholder="메모를 입력하세요"
              value={memoDraft}
              onChange={(e) => setMemoDraft(e.target.value)}
            />
            <button type="button" onClick={addMemo}>
              메모 저장
            </button>
          </div>
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
