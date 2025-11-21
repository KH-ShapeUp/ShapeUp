// src/admin/components/KpiCardSection.jsx
import React, { useEffect, useMemo, useState } from "react";
import "../styles/KpiCardSection.css";

const formatDate = (date) => date.toISOString().slice(0, 10).replace(/-/g, ".");

const KpiCardSection = () => {
  const [currentDate] = useState(new Date());
  const [loading, setLoading] = useState(false);
  const [metrics, setMetrics] = useState({
    todayJoin: 0,
    todayWithdraw: 0,
    userCount: 0,
    stadiumManagerCount: 0,
    trainerCount: 0,
    todayMatching: 0,
    reportCount: 0,
  });

  useEffect(() => {
    const fetchMetrics = async () => {
      setLoading(true);
      try {
        const res = await fetch("/api/admin/users", { credentials: "include" });
        if (!res.ok) throw new Error("fail");
        const data = await res.json();
        const todayKey = new Date().toISOString().slice(0, 10);
        let todayJoin = 0;
        let todayWithdraw = 0;
        let userCount = 0;
        let stadiumManagerCount = 0;
        let trainerCount = 0;

        (data || []).forEach((u) => {
          const created = u.createdAt ? String(u.createdAt).slice(0, 10) : "";
          const updated = u.updatedAt ? String(u.updatedAt).slice(0, 10) : "";
          if (created === todayKey) todayJoin += 1;
          if (u.status === "탈퇴" && (updated === todayKey || created === todayKey)) todayWithdraw += 1;
          const type = (u.userType || "").toUpperCase();
          if (type === "USER") userCount += 1;
          else if (type === "STADIUM_MANAGER") stadiumManagerCount += 1;
          else if (type === "TRAINER") trainerCount += 1;
        });

        setMetrics((prev) => ({
          ...prev,
          todayJoin,
          todayWithdraw,
          userCount,
          stadiumManagerCount,
          trainerCount,
        }));
      } catch (e) {
        // ignore errors, keep zeros
      } finally {
        setLoading(false);
      }
    };
    fetchMetrics();
  }, []);

  const stats = useMemo(
    () => [
      { label: "오늘 가입자 수", value: metrics.todayJoin },
      { label: "오늘 탈퇴자 수", value: metrics.todayWithdraw },
      { label: "오늘 매칭 수", value: metrics.todayMatching },
      { label: "신고 요청", value: metrics.reportCount },
      { label: "회원 수", value: metrics.userCount },
      { label: "시설 관리자 수", value: metrics.stadiumManagerCount },
      { label: "트레이너 수", value: metrics.trainerCount },
    ],
    [metrics]
  );

  return (
    <div className="kpi-container">
      {/* 날짜 영역 */}
      <div className="kpi-date-row">
        <span className="date-text">{formatDate(currentDate)}</span>
        {loading && <span className="kpi-loading">불러오는 중...</span>}
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
