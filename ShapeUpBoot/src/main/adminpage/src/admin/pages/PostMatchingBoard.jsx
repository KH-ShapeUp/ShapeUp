import React, { useCallback, useEffect, useMemo, useState } from "react";
import BoardManager from "../components/BoardManager";
import "../styles/PostNotice.css";

const API_BASE =
  import.meta.env.VITE_API_BASE ||
  (typeof window !== "undefined" && window.location.port === "5173" ? "http://localhost:8080" : "");
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
  const [activePosts, setActivePosts] = useState([]);
  const [deletedPosts, setDeletedPosts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [actionModal, setActionModal] = useState({ open: false, mode: null, postId: null, status: "confirm" });
  const [chartLabels, setChartLabels] = useState([]);
  const [chartData, setChartData] = useState([]);
  const categories = useMemo(() => ["모집중", "마감", "완료", "삭제"], []);
  // const API_BASE = window.location.port === "5173" ? "http://localhost:8080" : "";
  const columnsActive = useMemo(
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
      {
        key: "actions",
        label: "삭제",
        width: "10%",
        render: (post) => (
          <button
            className="delete-btn small"
            onClick={(e) => {
              e.stopPropagation();
              setActionModal({ open: true, mode: "delete", postId: post.id, status: "confirm" });
            }}
          >
            삭제
          </button>
        ),
      },
    ],
    []
  );

  const columnsDeleted = useMemo(
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
      {
        key: "actions",
        label: "복구",
        width: "10%",
        render: (post) => (
          <button
            className="delete-btn small"
            onClick={(e) => {
              e.stopPropagation();
              setActionModal({ open: true, mode: "restore", postId: post.id, status: "confirm" });
            }}
          >
            복구
          </button>
        ),
      },
    ],
    []
  );

  const fetchList = async () => {
    setLoading(true);
    try {
      const fetchAll = async (deleteYn) => {
        let page = 1;
        let maxPage = 1;
        const items = [];
        do {
          const res = await fetch(`${API_BASE}/matching/list?page=${page}&deleteYn=${deleteYn}`, {
            credentials: "include",
          });
          if (!res.ok) throw new Error("failed");
          const data = await res.json();
          const list = Array.isArray(data.mList) ? data.mList : [];
          items.push(...list);
          maxPage = data.maxPage || 1;
          page += 1;
        } while (page <= maxPage);
        return items;
      };

      const [list, delList] = await Promise.all([fetchAll("N"), fetchAll("Y")]);
      const mapped = list.map((item) => ({
        id: item.matchingNo,
        date: formatDate(item.createdAt),
        author: item.userNickName || `USER_${item.userNo}`,
        activityId: item.activityId,
        activityName: item.activityName,
        category: item.activityName || "매칭",
        status: item.deleteYn === "Y" ? "삭제" : item.matchingType || "모집중",
        deleteYn: item.deleteYn || "N",
        matchingType: item.matchingType,
        title: item.matchingTitle,
        content: item.matchingContent,
        location: item.matchingLocation,
        matchingDate: item.matchingDate,
        matchingTime: item.matchingTime,
        level: item.matchingLevel,
        partnerType: item.partnerType,
        matchingUserCount: item.matchingUserCount,
        price: item.matchingPrice,
      }));
      const mappedDel = delList.map((item) => ({
        id: item.matchingNo,
        date: formatDate(item.createdAt),
        author: item.userNickName || `USER_${item.userNo}`,
        activityId: item.activityId,
        activityName: item.activityName,
        category: item.activityName || "매칭",
        status: "삭제",
        deleteYn: item.deleteYn || "Y",
        matchingType: item.matchingType,
        title: item.matchingTitle,
        content: item.matchingContent,
        location: item.matchingLocation,
        matchingDate: item.matchingDate,
        matchingTime: item.matchingTime,
        level: item.matchingLevel,
        partnerType: item.partnerType,
        matchingUserCount: item.matchingUserCount,
        price: item.matchingPrice,
      }));
      setActivePosts(mapped);
      setDeletedPosts(mappedDel.filter(item => item.deleteYn === "Y"));

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
      setActivePosts([]);
      setDeletedPosts([]);
      setChartLabels([]);
      setChartData([]);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchList();
  }, []);

  const performAction = async () => {
    if (!actionModal.postId || !actionModal.mode) return;
    const deleteYn = actionModal.mode === "delete" ? "Y" : "N";
    try {
      await fetch(`${API_BASE}/matching/delete?matchingNo=${actionModal.postId}&deleteYn=${deleteYn}`, {
        method: "POST",
        credentials: "include",
      });
      setActionModal((prev) => ({ ...prev, status: "done" }));
      setTimeout(() => {
        setActionModal({ open: false, mode: null, postId: null, status: "confirm" });
        fetchList();
      }, 800);
    } catch (e) {
      console.error(e);
      setActionModal({ open: false, mode: null, postId: null, status: "confirm" });
    }
  };

  return (
    <div className="posts-page">
      <header className="title-header">
        <div>
          <h2>매칭 게시판 관리</h2>
          <p>매칭 모집 글을 조회하고 관리하세요.</p>
        </div>
      </header>
      <BoardManager
        boardTitle="매칭 "
        initialPosts={activePosts}
        categories={categories}
        chartLabels={chartLabels.length ? chartLabels : undefined}
        chartData={chartData.length ? chartData : undefined}
        chartDatasetLabel="매칭 모집 등록 수"
        detailMode="readonly"
        storageKey={null}
        showStatusColumn
        showMoveButton={false}
        loading={loading}
        columns={columnsActive}
        detailRenderer={({ post }) => (
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
            <div className="detail-actions-row">
              <button
                className="delete-btn"
                onClick={() => setActionModal({ open: true, mode: "delete", postId: post.id, status: "confirm" })}
              >
                삭제
              </button>
            </div>
    </div>
  )}
    />
      <BoardManager
        boardTitle="삭제된 매칭 "
        initialPosts={deletedPosts}
        categories={categories}
        chartLabels={[]}
        chartData={[]}
        chartDatasetLabel="삭제 매칭"
        detailMode="readonly"
        storageKey={null}
        showStatusColumn
        showMoveButton={false}
        loading={loading}
        columns={columnsDeleted}
        detailRenderer={({ post }) => (
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
                <label>등록일</label>
                <p className="detail-text">{post.date || "-"}</p>
              </div>
              <div className="field">
                <label>매칭 일자</label>
                <p className="detail-text">{post.matchingDate || "-"}</p>
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
            <div className="detail-actions-row">
              <button
                className="delete-btn"
                onClick={() => setActionModal({ open: true, mode: "restore", postId: post.id, status: "confirm" })}
              >
                복구
              </button>
            </div>
          </div>
        )}
      />

      {actionModal.open && (
        <div className="modal-overlay">
          <div className="modal delete">
            <div className="modal-header">
              <h3>{actionModal.mode === "delete" ? "게시글 삭제" : "게시글 복구"}</h3>
            </div>
            <div className="modal-body">
              {actionModal.status === "confirm"
                ? actionModal.mode === "delete" ? "삭제하시겠습니까?" : "복구하시겠습니까?"
                : actionModal.mode === "delete" ? "삭제되었습니다." : "복구되었습니다."}
            </div>
            {actionModal.status === "confirm" ? (
              <div className="modal-footer">
                <button className="confirm-btn" onClick={performAction}>
                  예
                </button>
                <button
                  className="cancel-btn"
                  onClick={() =>
                    setActionModal({ open: false, mode: null, postId: null, status: "confirm" })
                  }
                >
                  아니오
                </button>
              </div>
            ) : (
              <div className="modal-footer">
                <button
                  className="confirm-btn"
                  onClick={() =>
                    setActionModal({ open: false, mode: null, postId: null, status: "confirm" })
                  }
                >
                  확인
                </button>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
};

export default PostMatchingBoard;
