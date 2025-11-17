import React, { useEffect, useMemo, useState } from "react";
import ChartCard from "../../common/components/ChartCard";
import KpiCardSection from "../components/KpiCardSection";
import "../styles/Dashboard.css";
import { BOARD_STORAGE_KEYS, BOARD_STORAGE_EVENT } from "../../common/utils/storageKeys";

const Dashboard = () => {
  const visitData = [12, 19, 3, 5, 2, 3, 7];
  const memberData = [2, 5, 4, 8, 3, 6, 9];
  const isBrowser = typeof window !== "undefined";

  const loadQnaPosts = () => {
    if (!isBrowser) return [];
    try {
      const raw = window.localStorage.getItem(BOARD_STORAGE_KEYS.QNA);
      if (!raw) return [];
      const parsed = JSON.parse(raw);
      return Array.isArray(parsed) ? parsed : [];
    } catch (err) {
      console.warn("Failed to load QnA posts", err);
      return [];
    }
  };

  const [qnaPosts, setQnaPosts] = useState(() => loadQnaPosts());
  const [qnaFilter, setQnaFilter] = useState("전체");

  useEffect(() => {
    if (!isBrowser) return;
    const sync = () => setQnaPosts(loadQnaPosts());
    const storageHandler = (event) => {
      if (event.key && event.key !== BOARD_STORAGE_KEYS.QNA) return;
      sync();
    };
    const boardHandler = (event) => {
      if (!event.detail || event.detail.storageKey === BOARD_STORAGE_KEYS.QNA) {
        sync();
      }
    };
    window.addEventListener("storage", storageHandler);
    window.addEventListener(BOARD_STORAGE_EVENT, boardHandler);
    return () => {
      window.removeEventListener("storage", storageHandler);
      window.removeEventListener(BOARD_STORAGE_EVENT, boardHandler);
    };
  }, [isBrowser]);

  const filteredQna = useMemo(
    () =>
      qnaPosts.filter((post) =>
        qnaFilter === "전체" ? true : post.category === qnaFilter
      ),
    [qnaPosts, qnaFilter]
  );
  const qnaLatest = filteredQna.slice(0, 5);

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
          <div className="report-header">
            <h4>질문 / 건의 사항</h4>
            <div className="qna-filter-group">
              {["전체", "질문", "버그", "건의"].map((label) => (
                <button
                  type="button"
                  key={label}
                  className={qnaFilter === label ? "active" : ""}
                  onClick={() => setQnaFilter(label)}
                >
                  {label}
                </button>
              ))}
            </div>
          </div>
          <div className="dashboard-qna-table-wrapper">
            <table className="dashboard-qna-table">
              <thead>
                <tr>
                  <th>카테고리</th>
                  <th>작성자</th>
                  <th>제목</th>
                  <th>상태</th>
                </tr>
              </thead>
              <tbody>
                {qnaLatest.map((post) => (
                  <tr key={post.id}>
                    <td>{post.category}</td>
                    <td>{post.author}</td>
                    <td>{post.title}</td>
                    <td>{post.status}</td>
                  </tr>
                ))}
                {!qnaLatest.length && (
                  <tr>
                    <td colSpan={4} className="empty-row">
                      표시할 문의가 없습니다.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
