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
        const normalizeDateKey = (val) => {
          if (!val) return "";
          const num = Number(val);
          if (!Number.isNaN(num)) {
            const d = new Date(num);
            if (!Number.isNaN(d.getTime())) return d.toISOString().slice(0, 10);
          }
          const d = new Date(val);
          if (!Number.isNaN(d.getTime())) return d.toISOString().slice(0, 10);
          return String(val).slice(0, 10);
        };
        const pickDate = (obj) =>
          normalizeDateKey(
            obj.createdAt ||
              obj.created_at ||
              obj.joinDate ||
              obj.regDate ||
              obj.reg_date ||
              obj.date ||
              obj.updatedAt
          );

        let todayJoin = 0;
        let todayWithdraw = 0;
        let userCount = 0;
        let stadiumManagerCount = 0;
        let trainerCount = 0;

        (data || []).forEach((u) => {
          const created = pickDate(u);
          const updated = normalizeDateKey(u.updatedAt || u.updated_at || u.deletedAt || u.deleted_at);
          if (created === todayKey) todayJoin += 1;
          const status = (u.status || u.userStatus || "").toUpperCase();
          const deleted = (u.deleteYn || u.DELETE_YN || "").toUpperCase() === "Y";
          if ((status === "탈퇴" || status === "WITHDRAW" || deleted) && (updated === todayKey || created === todayKey)) {
            todayWithdraw += 1;
          }
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

        // 오늘 매칭 수 (모든 페이지 조회)
        const fetchTodayMatching = async () => {
          let page = 1;
          let maxPage = 1;
          let count = 0;
          do {
            const resMatch = await fetch(`/matching/list?page=${page}&deleteYn=N`, { credentials: "include" });
            if (!resMatch.ok) break;
            const payload = await resMatch.json();
            const list = Array.isArray(payload.mList) ? payload.mList : [];
            list.forEach((m) => {
              const createdKey = normalizeDateKey(
                m.createdAt || m.created_at || m.matchingDate || m.matchDate || m.date
              );
              if (createdKey === todayKey) count += 1;
            });
            maxPage = payload.maxPage || 1;
            page += 1;
          } while (page <= maxPage);
          return count;
        };

        // 오늘 신고 요청 수
        const fetchTodayReports = async () => {
          const resRpt = await fetch("/api/admin/reports", { credentials: "include" });
          if (!resRpt.ok) return 0;
          const json = await resRpt.json();
          const items = Array.isArray(json.items) ? json.items : [];
          return items.reduce((acc, r) => {
            const dateKey = normalizeDateKey(
              r.date || r.createdAt || r.reportDate || r.requestedAt || r.created_at
            );
            return dateKey === todayKey ? acc + 1 : acc;
          }, 0);
        };

        const [todayMatching, reportCount] = await Promise.all([fetchTodayMatching(), fetchTodayReports()]);
        setMetrics((prev) => ({ ...prev, todayMatching, reportCount }));
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
