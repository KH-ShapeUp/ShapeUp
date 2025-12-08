import React, { useEffect, useMemo, useState } from "react";
import BoardManager from "../components/BoardManager";
import "../styles/PostNotice.css";

const API_BASE =
  import.meta.env.VITE_API_BASE ||
  (typeof window !== "undefined" && window.location.port === "5173" ? "http://localhost:8080" : "");

const formatDate = (val) => {
  if (!val) return "";
  const d = new Date(val);
  if (Number.isNaN(d.getTime())) return "";
  const y = d.getFullYear();
  const m = String(d.getMonth() + 1).padStart(2, "0");
  const dd = String(d.getDate()).padStart(2, "0");
  return `${y}.${m}.${dd}`;
};

const mapLevelText = (val) => {
  const num = String(val || "").trim();
  if (num === "1") return "초급";
  if (num === "2") return "중급";
  if (num === "3") return "고급";
  return num || "-";
};

const PostTrainerBoard = () => {
  const [activePosts, setActivePosts] = useState([]);
  const [deletedPosts, setDeletedPosts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [actionModal, setActionModal] = useState({ open: false, mode: null, postId: null, status: "confirm" });
  const [chartLabels, setChartLabels] = useState([]);
  const [chartData, setChartData] = useState([]);
  const categories = useMemo(() => ["모집중", "마감", "완료", "삭제"], []);

  const columnsActive = useMemo(() => [
    { key: "id", label: "번호", width: "6%" },
    { key: "date", label: "작성일", width: "12%" },
    { key: "author", label: "작성자", width: "12%" },
    { key: "activityName", label: "운동", width: "14%", render: post => post.activityName || "-" },
    { key: "title", label: "제목", width: "18%" },
    { key: "level", label: "강도", width: "10%", render: post => mapLevelText(post.level) },
    { key: "location", label: "지역", width: "18%" },
    {
      key: "actions",
      label: "삭제",
      width: "10%",
      render: post => (
        <button className="delete-btn small" onClick={(e) => {
          e.stopPropagation();
          setActionModal({ open: true, mode: "delete", postId: post.id, status: "confirm" });
        }}>삭제</button>
      ),
    }
  ], []);

  const columnsDeleted = useMemo(() => [
    { key: "id", label: "번호", width: "6%" },
    { key: "date", label: "작성일", width: "12%" },
    { key: "author", label: "작성자", width: "12%" },
    { key: "activityName", label: "운동", width: "14%", render: post => post.activityName || "-" },
    { key: "title", label: "제목", width: "18%" },
    { key: "level", label: "강도", width: "10%", render: post => mapLevelText(post.level) },
    { key: "location", label: "지역", width: "18%" },
    {
      key: "actions",
      label: "복구",
      width: "10%",
      render: post => (
        <button className="delete-btn small" onClick={(e) => {
          e.stopPropagation();
          setActionModal({ open: true, mode: "restore", postId: post.id, status: "confirm" });
        }}>복구</button>
      ),
    }
  ], []);
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

    // 활성(N) / 삭제(Y) 게시글 구분
    const [list, delList] = await Promise.all([fetchAll("N"), fetchAll("Y")]);

    const mapped = list.map((item) => ({
      ...item,
      id: item.matchingNo,
      date: formatDate(item.createdAt),
      author: item.userNickName || `USER_${item.userNo}`,
      activityName: item.activityName,
      status: item.matchingType || "모집중",
      deleteYn: "N", // 활성 게시글은 무조건 N
    }));

    const mappedDel = delList.map((item) => ({
      ...item,
      id: item.matchingNo,
      date: formatDate(item.createdAt),
      author: item.userNickName || `USER_${item.userNo}`,
      activityName: item.activityName,
      status: "삭제",
      deleteYn: "Y", // 삭제 게시글은 무조건 Y
    }));

    setActivePosts(mapped);
    setDeletedPosts(mappedDel);
  } catch (err) {
    console.error(err);
    setActivePosts([]);
    setDeletedPosts([]);
  } finally {
    setLoading(false);
  }
};

  useEffect(() => { fetchList(); }, []);

  const performAction = async () => {
    if (!actionModal.postId || !actionModal.mode) return;
    const deleteYn = actionModal.mode === "delete" ? "Y" : "N";
    try {
      await fetch(`${API_BASE}/trainer/matching/delete?matchingNo=${actionModal.postId}&deleteYn=${deleteYn}`, {
        method: "POST",
        credentials: "include",
      });
      setActionModal(prev => ({ ...prev, status: "done" }));
      setTimeout(() => {
        setActionModal({ open: false, mode: null, postId: null, status: "confirm" });
        fetchList();
      }, 800);
    } catch (err) {
      console.error(err);
      setActionModal({ open: false, mode: null, postId: null, status: "confirm" });
    }
  };

  return (
    <div className="posts-page">
      <header className="title-header">
        <div>
          <h2>트레이너 매칭 게시판 관리</h2>
          <p>트레이너 매칭 글을 조회하고 관리하세요.</p>
        </div>
      </header>

      <BoardManager
        boardTitle="트레이너 매칭"
        initialPosts={activePosts}
        categories={categories}
        chartLabels={chartLabels.length ? chartLabels : undefined}
        chartData={chartData.length ? chartData : undefined}
        chartDatasetLabel="트레이너 매칭 등록 수"
        detailMode="readonly"
        storageKey={null}
        showStatusColumn
        showMoveButton={false}
        loading={loading}
        columns={columnsActive}
        detailRenderer={({ post }) => (
          <div className="detail-body matching-detail">
            <div className="field">
              <label>매칭 번호</label>
              <p className="detail-text">{post.id}</p>
            </div>
            <div className="field">
              <label>작성자</label>
              <p className="detail-text">{post.author}</p>
            </div>
            <div className="field">
              <label>운동</label>
              <p className="detail-text">{post.activityName || "-"}</p>
            </div>
            <div className="detail-actions-row">
              <button className="delete-btn" onClick={() => setActionModal({ open: true, mode: "delete", postId: post.id, status: "confirm" })}>삭제</button>
            </div>
          </div>
        )}
      />

      <BoardManager
        boardTitle="삭제된 트레이너 매칭"
        initialPosts={deletedPosts}
        categories={categories}
        chartLabels={[]}
        chartData={[]}
        chartDatasetLabel="삭제된 트레이너 매칭"
        detailMode="readonly"
        storageKey={null}
        showStatusColumn
        showMoveButton={false}
        loading={loading}
        columns={columnsDeleted}
        detailRenderer={({ post }) => (
          <div className="detail-body matching-detail">
            <div className="field">
              <label>매칭 번호</label>
              <p className="detail-text">{post.id}</p>
            </div>
            <div className="field">
              <label>작성자</label>
              <p className="detail-text">{post.author}</p>
            </div>
            <div className="detail-actions-row">
              <button className="delete-btn" onClick={() => setActionModal({ open: true, mode: "restore", postId: post.id, status: "confirm" })}>복구</button>
            </div>
          </div>
        )}
      />
    </div>
  );
};

export default PostTrainerBoard;
