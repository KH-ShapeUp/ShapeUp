// src/admin/components/KpiCardSection.jsx
import React, { useMemo, useState } from "react";
import "../styles/KpiCardSection.css";

const BASE_DATE = new Date("2025-11-13T00:00:00");

const mockDataByDate = {
  "2025-11-12": [25, 3, 18, 2, 980, 12, 65],
  "2025-11-13": [32, 4, 22, 1, 983, 12, 65],
  "2025-11-14": [28, 2, 25, 4, 987, 13, 66],
};

const labels = [
  "오늘 가입자 수",
  "오늘 탈퇴자 수",
  "오늘 매칭 수",
  "신고 요청",
  "회원 수",
  "시설 관리자 수",
  "트레이너 수",
];

const formatDate = (date) => date.toISOString().slice(0, 10).replace(/-/g, ".");

const KpiCardSection = () => {
  const [currentDate, setCurrentDate] = useState(BASE_DATE);

  const dataForDate = useMemo(() => {
    const key = currentDate.toISOString().slice(0, 10);
    return mockDataByDate[key] || mockDataByDate["2025-11-13"];
  }, [currentDate]);

  const stats = labels.map((label, idx) => ({ label, value: dataForDate[idx] ?? 0 }));

  const shiftDate = (days) => {
    setCurrentDate((prev) => {
      const next = new Date(prev);
      next.setDate(prev.getDate() + days);
      return next;
    });
  };

  return (
    <div className="kpi-container">
      {/* 날짜 이동 영역 */}
      <div className="kpi-date-row">
        <button type="button" className="arrow" onClick={() => shiftDate(-1)}>
          ←
        </button>
        <span className="date-text">{formatDate(currentDate)}</span>
        <button type="button" className="arrow" onClick={() => shiftDate(1)}>
          →
        </button>
      </div>

      {/* 가로 라인 */}
      <div className="divider" />

      {/* KPI 카드 목록 */}
      <div className="kpi-grid">
        {stats.map((item, idx) => (
          <div key={item.label} className="kpi-item" style={{ "--index": idx }}>
            <p className="kpi-label">{item.label}</p>
            <p className="kpi-value">{item.value}</p>
          </div>
        ))}
      </div>
    </div>
  );
};

export default KpiCardSection;
