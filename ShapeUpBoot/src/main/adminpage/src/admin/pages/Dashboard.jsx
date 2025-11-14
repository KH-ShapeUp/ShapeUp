import React from "react";
import ChartCard from "../../common/components/ChartCard";
import KpiCardSection from "../components/KpiCardSection";
import "../styles/Dashboard.css";

const Dashboard = () => {
  const visitData = [12, 19, 3, 5, 2, 3, 7];
  const memberData = [2, 5, 4, 8, 3, 6, 9];

  return (
    <div className="dashboard-container">
      <div className="top-section">
        <ChartCard title="일일 방문량" data={visitData} />
        <ChartCard title="일일 회원 수" data={memberData} />
      </div>

      <KpiCardSection /> 

      <div className="bottom-section">
        <div className="message-box">
          <h4>받은 쪽지 (관리자 통합)</h4>
          <div className="box-content">쪽지함 내용 표시 영역</div>
        </div>

        <div className="report-box">
          <h4>건의 사항 (관리자)</h4>
          <div className="box-content">건의사항 표시 영역</div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
