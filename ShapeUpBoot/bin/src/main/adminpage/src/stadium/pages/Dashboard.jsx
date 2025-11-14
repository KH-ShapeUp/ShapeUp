import React from "react";
import "../styles/StadiumDashboard.css";

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

const initialMaintenance = [
  { title: "트레드밀 점검", facility: "헬스장", due: "11.15", priority: "high" },
  { title: "샤워실 배수 청소", facility: "공용", due: "11.16", priority: "medium" },
  { title: "풋살장 조명 교체", facility: "풋살장", due: "11.18", priority: "low" },
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

const StadiumDashboard = () => {
  const kpis = initialKpis;
  const bookings = initialBookings;
  const maintenanceList = initialMaintenance;
  const notifications = initialNotifications;
  const memos = initialMemos;

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
                <th>시간</th>
                <th>시설</th>
                <th>회원</th>
                <th>상태</th>
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
            {notifications.map((note, idx) => (
              <li key={idx}>{note}</li>
            ))}
          </ul>
        </article>

        <article className="stadium-card">
          <header className="stadium-card__header">
            <div>
              <h3>메모</h3>
              <p>팀 공유 메모 {memos.length}건</p>
            </div>
          </header>
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

export default StadiumDashboard;
