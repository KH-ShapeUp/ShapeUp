import React, { useEffect, useState } from "react";
import "../styles/StadiumDashboard.css";
import {
  STADIUM_MESSAGE_STORAGE_KEY,
  STADIUM_MEMO_STORAGE_KEY,
  STADIUM_NOTIFICATION_STORAGE_KEY,
  STADIUM_MAINTENANCE_STORAGE_KEY,
  STORAGE_EVENTS,
} from "../../common/utils/storageKeys";
import { loadMaintenanceTasks } from "../utils/maintenanceStorage";
import CustomSelect from "../../common/components/CustomSelect";

const initialKpis = [
  { label: "오늘 예약", value: 42, accent: "#4c8bf5" },
  { label: "입금 확인 대기", value: 6, accent: "#ffaf3f" },
  { label: "시설 가동률", value: "87%", accent: "#2dcc70" },
  { label: "신규 문의", value: 5, accent: "#ff6b6b" },
];

const initialBookings = [
  { time: "09:00 - 10:00", facility: "풋살장 A", user: "김철수", status: "확정" },
  { time: "10:00 - 11:00", facility: "헬스 PT룸", user: "이영희", status: "입금대기" },
  { time: "11:00 - 12:00", facility: "수영장 트랙", user: "박민수", status: "확정" },
  { time: "13:00 - 14:00", facility: "요가실", user: "고은", status: "대기" },
];

const initialNotifications = [
  "11/14 10:00 시설 관리자 미팅",
  "신규 단체 이용 문의 2건 접수",
  "세금계산서 발행 마감 D-3",
  "요가 강사 스케줄 업데이트 필요",
];

const initialMemos = [
  { id: 1, text: "요가실 환기 점검 필요", date: "2025-11-14 09:20" },
  { id: 2, text: "풋살장 잔디 교체 일정 확인", date: "2025-11-14 13:05" },
];

const memoFilterOptions = ["전체", "시설 1", "시설 2", "시설 3"];

const inboxMessages = [
  {
    id: 1,
    sender: "ShapeUp 본사",
    subject: "정기 시설 안전 점검 안내",
    preview: "이번 주 내 점검표 공유 바랍니다.",
    date: "11.14",
  },
  {
    id: 2,
    sender: "회원 민지원",
    subject: "수영장 이용 문의",
    preview: "주말 이용 가능 여부 확인 요청",
    date: "11.13",
  },
];

const suggestionItems = [
  {
    id: 1,
    user: "김태훈",
    facility: "헬스장",
    content: "스트레칭 매트 추가 배치",
    status: "대기",
  },
  {
    id: 2,
    user: "이지수",
    facility: "요가실",
    content: "주말 오전 클래스 증설 요청",
    status: "완료",
  },
];

const isBrowser = typeof window !== "undefined";

const readInboxFromStorage = () => {
  if (!isBrowser) return [];
  try {
    const raw = window.localStorage.getItem(STADIUM_MESSAGE_STORAGE_KEY);
    if (!raw) return [];
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [];
  } catch (err) {
    console.warn("Failed to load inbox messages", err);
    return [];
  }
};

const readNotificationFeed = () => {
  if (!isBrowser) return initialNotifications;
  try {
    const raw = window.localStorage.getItem(STADIUM_NOTIFICATION_STORAGE_KEY);
    if (!raw) {
      window.localStorage.setItem(
        STADIUM_NOTIFICATION_STORAGE_KEY,
        JSON.stringify(initialNotifications)
      );
      return initialNotifications;
    }
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) && parsed.length ? parsed : initialNotifications;
  } catch (err) {
    console.warn("Failed to load notifications", err);
    return initialNotifications;
  }
};

const readMemosFromStorage = () => {
  if (!isBrowser) return initialMemos;
  try {
    const raw = window.localStorage.getItem(STADIUM_MEMO_STORAGE_KEY);
    if (!raw) {
      window.localStorage.setItem(STADIUM_MEMO_STORAGE_KEY, JSON.stringify(initialMemos));
      return initialMemos;
    }
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : initialMemos;
  } catch (err) {
    console.warn("Failed to load memos", err);
    return initialMemos;
  }
};

const StadiumDashboard = () => {
  const kpis = initialKpis;
  const bookings = initialBookings;
  const suggestions = suggestionItems;
  const [incomingMessages, setIncomingMessages] = useState([]);
  const [notifications, setNotifications] = useState(() => readNotificationFeed());
  const [memoFeed, setMemoFeed] = useState(() => readMemosFromStorage());
  const [memoTab, setMemoTab] = useState("전체");
  const [maintenanceList, setMaintenanceList] = useState(() => loadMaintenanceTasks());

  useEffect(() => {
    if (!isBrowser) return;
    const sync = () => setIncomingMessages(readInboxFromStorage());
    const storageHandler = (event) => {
      if (event.key && event.key !== STADIUM_MESSAGE_STORAGE_KEY) return;
      sync();
    };
    sync();
    window.addEventListener("storage", storageHandler);
    window.addEventListener(STORAGE_EVENTS.STADIUM_MESSAGES, sync);
    return () => {
      window.removeEventListener("storage", storageHandler);
      window.removeEventListener(STORAGE_EVENTS.STADIUM_MESSAGES, sync);
    };
  }, []);

  useEffect(() => {
    if (!isBrowser) return;
    const syncNotices = () => setNotifications(readNotificationFeed());
    const storageHandler = (event) => {
      if (event.key && event.key !== STADIUM_NOTIFICATION_STORAGE_KEY) return;
      syncNotices();
    };
    syncNotices();
    window.addEventListener("storage", storageHandler);
    window.addEventListener(STORAGE_EVENTS.STADIUM_NOTIFICATIONS, syncNotices);
    return () => {
      window.removeEventListener("storage", storageHandler);
      window.removeEventListener(STORAGE_EVENTS.STADIUM_NOTIFICATIONS, syncNotices);
    };
  }, []);

  useEffect(() => {
    if (!isBrowser) return;
    const syncMemos = () => setMemoFeed(readMemosFromStorage());
    const storageHandler = (event) => {
      if (event.key && event.key !== STADIUM_MEMO_STORAGE_KEY) return;
      syncMemos();
    };
    syncMemos();
    window.addEventListener("storage", storageHandler);
    window.addEventListener(STORAGE_EVENTS.STADIUM_MEMOS, syncMemos);
    return () => {
      window.removeEventListener("storage", storageHandler);
      window.removeEventListener(STORAGE_EVENTS.STADIUM_MEMOS, syncMemos);
    };
  }, []);

  useEffect(() => {
    if (!isBrowser) return;
    const syncMaintenance = () => setMaintenanceList(loadMaintenanceTasks());
    const storageHandler = (event) => {
      if (event.key && event.key !== STADIUM_MAINTENANCE_STORAGE_KEY) return;
      syncMaintenance();
    };
    syncMaintenance();
    window.addEventListener("storage", storageHandler);
    window.addEventListener(STORAGE_EVENTS.STADIUM_MAINTENANCE, syncMaintenance);
    return () => {
      window.removeEventListener("storage", storageHandler);
      window.removeEventListener(STORAGE_EVENTS.STADIUM_MAINTENANCE, syncMaintenance);
    };
  }, []);

  const messages = [...incomingMessages, ...inboxMessages];
  const memoList = memoFeed.filter((memo) =>
    memoTab === "전체" ? true : memo.facility === memoTab
  );

  return (
    <div className="stadium-dashboard">
      <section className="stadium-kpis">
        {kpis.map((card) => (
          <article key={card.label} className="stadium-kpi" style={{ borderColor: card.accent }}>
            <span className="kpi-label">{card.label}</span>
            <strong className="kpi-value" style={{ color: card.accent }}>
              {card.value}
            </strong>
          </article>
        ))}
      </section>

      <section className="stadium-grid">
        <article className="stadium-card">
          <header className="stadium-card__header">
            <div>
              <h3>다가오는 예약</h3>
              <p>실시간 예약 현황</p>
            </div>
            <span className="badge badge--primary">오늘</span>
          </header>
          <table className="stadium-table">
            <thead>
              <tr>
                <th>시간 </th>
                <th>시설 </th>
                <th>회원 </th>
                <th>상태 </th>
              </tr>
            </thead>
            <tbody>
              {bookings.map((row) => (
                <tr key={row.time}>
                  <td>{row.time}</td>
                  <td>{row.facility}</td>
                  <td>{row.user}</td>
                  <td>
                    <span className={`pill pill--${row.status}`}>
                      {row.status}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </article>

        <article className="stadium-card">
          <header className="stadium-card__header">
            <div>
              <h3>시설 점검 일정</h3>
              <p>잔여 작업 {maintenanceList.length}건</p>
            </div>
            <span className="badge">이번 주</span>
          </header>
          <ul className="maintenance-list">
            {maintenanceList.map((task) => (
              <li key={`${task.title}-${task.due}`} className={`priority-${task.priority}`}>
                <div>
                  <strong>{task.title}</strong>
                  <span>{task.facility || "시설 미지정"}</span>
                </div>
                <span className="due">{task.due || "미정"}</span>
              </li>
            ))}
          </ul>
        </article>
      </section>

      <section className="stadium-grid">
        <article className="stadium-card">
          <header className="stadium-card__header">
            <div>
              <h3>운영 알림</h3>
              <p>확인 필요 {notifications.length}건</p>
            </div>
          </header>
          <ul className="notification-list">
            {notifications.map((item, idx) => {
              if (typeof item === "string") {
                return <li key={idx}>{item}</li>;
              }
              return (
                <li key={item.id ?? idx}>
                  <div>
                    <strong>{item.title}</strong>
                    <p>{item.message}</p>
                    <span>
                      대상: {item.audience} · {item.date}
                    </span>
                  </div>
                </li>
              );
            })}
          </ul>
        </article>

        <article className="stadium-card">
          <header className="stadium-card__header">
            <div>
              <h3>메모</h3>
              <p>팀 공유 메모 {memoFeed.length}건</p>
            </div>
            <div className="memo-filter">
              <label>필터</label>
              <CustomSelect
                size="sm"
                value={memoTab}
                options={memoFilterOptions}
                onChange={setMemoTab}
              />
            </div>
          </header>
          <ul className="memo-list">
            {memoList.slice(0, 5).map((memo) => (
              <li key={memo.id}>
                <strong>{memo.facility || "시설 미지정"}</strong>
                <p>{memo.content}</p>
                <span>{memo.date}</span>
              </li>
            ))}
            {memoList.length === 0 && <p className="empty">등록된 메모가 없습니다.</p>}
          </ul>
        </article>
      </section>

      <section className="stadium-grid">
        <article className="stadium-card">
          <header className="stadium-card__header">
            <div>
              <h3>받은 쪽지</h3>
              <p>관리자 공지 및 회원 문의</p>
            </div>
            <span className="badge">최근 {messages.length}건</span>
          </header>
          <ul className="message-list">
            {messages.map((msg) => (
              <li key={msg.id}>
                <div className="message-meta">
                  <strong>{msg.sender}</strong>
                  <span>{msg.date}</span>
                </div>
                <p className="message-subject">{msg.subject}</p>
                <p className="message-preview">{msg.preview}</p>
              </li>
            ))}
          </ul>
        </article>

        <article className="stadium-card">
          <header className="stadium-card__header">
            <div>
              <h3>건의 사항</h3>
              <p>회원 요청 대응 현황</p>
            </div>
          </header>
          <table className="stadium-table suggestion-table">
            <thead>
              <tr>
                <th>회원</th>
                <th>시설</th>
                <th>내용</th>
                <th>상태</th>
              </tr>
            </thead>
            <tbody>
              {suggestions.map((row) => (
                <tr key={row.id}>
                  <td>{row.user}</td>
                  <td>{row.facility}</td>
                  <td>{row.content}</td>
                  <td>
                    <span className={`pill pill--${row.status}`}>{row.status}</span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </article>
      </section>
    </div>
  );
};

export default StadiumDashboard;
