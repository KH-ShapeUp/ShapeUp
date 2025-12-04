import React, { useEffect, useMemo, useState } from "react";
import BoardManager from "../components/BoardManager";
import.meta.env.VITE_API_BASE || ""
const formatDate = (val) => {
  if (!val) return "";
  const fromNumber = (num) => {
    const d = new Date(num);
    if (Number.isNaN(d.getTime())) return null;
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, "0");
    const dd = String(d.getDate()).padStart(2, "0");
    return `${y}.${m}.${dd}`;
  };

  // 숫자(timestamp)인 경우
  const num = Number(val);
  if (!Number.isNaN(num) && String(val).length >= 10) {
    const formatted = fromNumber(num);
    if (formatted) return formatted;
  }

  // 문자열 날짜인 경우
  const str = String(val);
  if (/^\d{4}-\d{2}-\d{2}/.test(str)) return str.slice(0, 10).replace(/-/g, ".");
  const parsed = fromNumber(Date.parse(str));
  return parsed || str;
};

const mapLevelText = (val) => {
  const num = String(val || "").trim();
  if (num === "1") return "초급";
  if (num === "2") return "중급";
  if (num === "3") return "고급";
  return num || "-";
};

const PostMatchingBoard = () => {
  const [posts, setPosts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [chartLabels, setChartLabels] = useState([]);
  const [chartData, setChartData] = useState([]);
  const categories = useMemo(() => ["모집중", "마감", "완료", "삭제"], []);
  // const API_BASE = window.location.port === "5173" ? "http://localhost:8080" : "";
  const columns = useMemo(
    () => [
      { key: "id", label: "번호", sortable: "id", width: "6%" },
      { key: "date", label: "작성일", sortable: "date", width: "12%" },
      { key: "author", label: "작성자", sortable: "author", width: "12%" },
      {
        key: "activityName",
        label: "운동",
        width: "14%",
        sortable: "activityName",
        render: (post) => post.activityName || "-",
      },
      { key: "title", label: "제목", sortable: "title", width: "18%" },
      { key: "level", label: "강도", sortable: "level", width: "10%" },
      { key: "location", label: "지역", sortable: "location", width: "18%" },
      { key: "actions", label: "삭제", width: "12%" },
    ],
    []
  );

  useEffect(() => {
    const fetchList = async () => {
      setLoading(true);
      try {
        const res = await fetch(`${API_BASE}/matching/list?page=1`, { credentials: "include" });
        if (!res.ok) throw new Error("failed");
        const data = await res.json();
        const list = Array.isArray(data.mList) ? data.mList : [];
        const mapped = list.map((item) => ({
          id: item.matchingNo,
          date: formatDate(item.createdAt),
          author: item.userNickName || `USER_${item.userNo}`,
          activityId: item.activityId,
          activityName: item.activityName,
          category: item.activityName || "매칭",
          status: item.deleteYn === "Y" ? "삭제" : item.matchingType || "모집중",
          matchingType: item.matchingType,
          title: item.matchingTitle,
          content: item.matchingContent,
          location: item.matchingLocation,
          matchingDate: item.matchingDate,
          matchingTime: item.matchingTime,
          level: item.matchingLevel,
          partnerType: item.partnerType,
          matchingUserCount: item.matchingUserCount,
          matchingType: item.matchingType,
          price: item.matchingPrice,
        }));
        setPosts(mapped);

        // 등록 추이 집계 (주 단위)
        const toWeekInfo = (val) => {
          const d = val ? new Date(val) : null;
          if (!d || Number.isNaN(d.getTime())) return { key: "기타", label: "기타", sort: 0 };
          const year = d.getFullYear();
          const month = d.getMonth(); // 0-based
          const monthStartDay = new Date(year, month, 1).getDay();
          const week = Math.ceil((d.getDate() + monthStartDay) / 7);
          const sort = new Date(year, month, 1).getTime() + (week - 1) * 7 * 24 * 60 * 60 * 1000;
          return {
            key: `${year}-${month + 1}-${week}`,
            label: `${month + 1}월 ${week}주`,
            sort,
          };
        };

        const bucket = new Map();
        mapped.forEach((m) => {
          const info = toWeekInfo(m.date);
          if (!bucket.has(info.key)) bucket.set(info.key, { ...info, count: 0 });
          bucket.get(info.key).count += 1;
        });

        const sorted = Array.from(bucket.values()).sort((a, b) => a.sort - b.sort);
        const sliced = sorted.slice(-6); // 최근 6개만 표시
        setChartLabels(sliced.map((s) => s.label));
        setChartData(sliced.map((s) => s.count));
      } catch (e) {
        console.error("매칭 목록 불러오기 실패", e);
        setPosts([]);
        setChartLabels([]);
        setChartData([]);
      } finally {
        setLoading(false);
      }
    };
    fetchList();
  }, [API_BASE]);

  return (
    <BoardManager
      boardTitle="매칭 게시판"
      initialPosts={posts}
      categories={categories}
      chartData={[5, 7, 6, 8, 9]}
      chartDatasetLabel="매칭 모집 등록 수"
      chartLabels={chartLabels.length ? chartLabels : undefined}
      chartData={chartData.length ? chartData : undefined}
      detailMode="readonly"
      storageKey={null}
      showStatusColumn
      showMoveButton={false}
      loading={loading}
      columns={columns}
      detailRenderer={({ post, onDelete }) => (
        <div className="detail-body matching-detail">
          <div className="grid-3">
            <div className="field">
              <label>매칭 번호</label>
              <p className="detail-text">{post.id}</p>
            </div>
            <div className="field">
              <label>작성자</label>
              <p className="detail-text">{post.author}</p>
            </div>
            <div className="field">
              <label>활동</label>
              <p className="detail-text">
                {post.activityId ? `${post.activityId} / ` : ""}
                {post.activityName || "-"}
              </p>
            </div>
            <div className="field">
              <label>등록일</label>
              <p className="detail-text">{post.date || "-"}</p>
            </div>
            <div className="field">
              <label>매칭 일자</label>
              <p className="detail-text">{post.matchingDate || "-"}</p>
            </div>
            <div className="field">
              <label>매칭 시간</label>
              <p className="detail-text">{post.matchingTime || "-"}</p>
            </div>
            <div className="field">
              <label>매칭 타입</label>
              <p className="detail-text">{post.matchingType || "-"}</p>
            </div>
            <div className="field">
              <label>장소</label>
              <p className="detail-text">{post.location || "-"}</p>
            </div>
            <div className="field">
              <label>난이도</label>
              <p className="detail-text">{mapLevelText(post.level)}</p>
            </div>
            <div className="field">
              <label>모집 인원</label>
              <p className="detail-text">{post.matchingUserCount ?? "-"}</p>
            </div>
            <div className="field">
              <label>금액</label>
              <p className="detail-text">{post.price || "-"}</p>
            </div>
          </div>

          <div className="field full">
            <label>제목</label>
            <p className="detail-text">{post.title}</p>
          </div>

          <div className="field full">
            <label>본문</label>
            <div className="detail-content-block tall">{post.content || "내용이 없습니다."}</div>
          </div>

          <div className="field full">
            <label>파트너 조건</label>
            <p className="detail-text">{post.partnerType || "-"}</p>
          </div>

          <button className="delete-btn" onClick={() => onDelete()}>
            삭제
          </button>
        </div>
      )}
    />
  );
};

export default PostMatchingBoard;
