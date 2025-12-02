import React, { useEffect, useMemo, useState } from "react";
import BoardManager from "../components/BoardManager";
import "../styles/PostNotice.css";

const API_BASE = window.location.port === "5173" ? "http://localhost:8080" : "";

const isImage = (name = "") => /\.(png|jpe?g|gif|webp|svg)$/i.test(name);
const buildUrl = (path) => {
  if (!path) return "";
  const cleaned = path.replace(/\\/g, "/");
  const withPrefix = cleaned.startsWith("/upload/")
    ? cleaned
    : cleaned.startsWith("upload/")
    ? `/${cleaned}`
    : `/upload/${cleaned.replace(/^upload\//, "")}`;
  return `${API_BASE}${withPrefix}`;
};
const normalizeDate = (val) => {
  if (!val) return "";
  const d = new Date(val);
  if (Number.isNaN(d.getTime())) return val;
  return d.toISOString().slice(0, 10);
};

const PostFreeBoard = () => {
  const [activePosts, setActivePosts] = useState([]);
  const [deletedPosts, setDeletedPosts] = useState([]);
  const [chartData, setChartData] = useState([]);
  const [loading, setLoading] = useState(true);

  const fetchImages = async (communityNo) => {
    const res = await fetch(`${API_BASE}/api/admin/community/${communityNo}/images`, { credentials: "include" });
    if (!res.ok) return [];
    const imgs = await res.json();
    return imgs.map((img) => ({
      ...img,
      url: buildUrl(img.imgPath),
      isImage: isImage(img.imgOriginalName || img.imgRename),
    }));
  };

  const mapItem = async (item) => {
    const images = await fetchImages(item.communityNo);
    const attachments = images.map((img) => ({
      name: img.imgOriginalName || img.imgRename || "file",
      url: img.url,
      isImage: img.isImage,
    }));
    return {
      id: item.communityNo,
      date: normalizeDate(item.createdAt),
      author: item.userId || "관리자",
      nickname: item.userNickName || "",
      category: item.communityType || "정보",
      title: item.communityTitle,
      content: item.communityContent || "",
      attachments,
      images,
      viewCount: item.viewCount || 0,
      likeCount: item.likeCount || 0,
    };
  };

  const fetchPosts = async () => {
    setLoading(true);
    try {
      const [actRes, delRes, trendRes] = await Promise.all([
        fetch(`${API_BASE}/api/admin/community?deleted=N`, { credentials: "include" }),
        fetch(`${API_BASE}/api/admin/community?deleted=Y`, { credentials: "include" }),
        fetch(`${API_BASE}/api/admin/community/trend`, { credentials: "include" }),
      ]);
      const act = actRes.ok ? await actRes.json() : { items: [] };
      const del = delRes.ok ? await delRes.json() : { items: [] };
      const trend = trendRes.ok ? await trendRes.json() : [];
      const mappedAct = await Promise.all((act.items || []).map(mapItem));
      const mappedDel = await Promise.all((del.items || []).map(mapItem));
      // mark deleteYn
      mappedAct.forEach((p) => { p.deleteYn = "N"; });
      mappedDel.forEach((p) => { p.deleteYn = "Y"; });
      setActivePosts(mappedAct);
      setDeletedPosts(mappedDel);
      setChartData(trend.map((t) => t.CNT || t.cnt || 0));
    } catch (e) {
      console.error(e);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchPosts();
  }, []);

  const [actionModal, setActionModal] = useState({ open: false, mode: null, postId: null, status: "confirm" });

  const performAction = async () => {
    if (!actionModal.postId || !actionModal.mode) return;
    const deleteYn = actionModal.mode === "delete" ? "Y" : "N";
    await fetch(`${API_BASE}/api/admin/community/${actionModal.postId}/delete?deleteYn=${deleteYn}`, {
      method: "PATCH",
      credentials: "include",
    });
    setActionModal((prev) => ({ ...prev, status: "done" }));
    setTimeout(() => {
      setActionModal({ open: false, mode: null, postId: null, status: "confirm" });
    }, 1000);
    fetchPosts();
  };

  const baseColumns = useMemo(
    () => [
      { key: "id", label: "번호", sortable: "id", width: "60px" },
      { key: "date", label: "날짜", sortable: "date", width: "120px" },
      { key: "author", label: "작성자", sortable: "author", width: "140px" },
      { key: "nickname", label: "닉네임", sortable: "nickname", width: "140px" },
      { key: "category", label: "카테고리", sortable: "category", width: "120px" },
      { key: "title", label: "제목", sortable: "title" },
      {
        key: "ops",
        label: "게시글 이동",
        render: (post) => (
          <a
            className="primary-btn small"
            href={`/community/detail?boardNo=${post.id}`}
            target="_blank"
            rel="noreferrer"
            onClick={(e) => e.stopPropagation()}
          >
            이동
          </a>
        ),
        width: "90px",
      },
    ],
    []
  );

  const columns = baseColumns;
  const deletedColumns = baseColumns;

  const detailRenderer = ({ post }) => (
    <div className="detail-body">
      <div className="detail-row">
        <strong>작성자</strong> {post.author} ({post.nickname || "닉네임 없음"})
      </div>
      <div className="detail-row">
        <strong>카테고리</strong> {post.category}
      </div>
      <div className="detail-row">
        <strong>조회수</strong> {post.viewCount} · <strong>좋아요</strong> {post.likeCount}
      </div>
      <div
        className="detail-content-block"
        dangerouslySetInnerHTML={{ __html: post.content || "내용이 없습니다." }}
      />
      {post.attachments?.length ? (
        <div className="attachment-list">
          <strong>첨부파일</strong>
          <div className="attachment-grid">
            {post.attachments.map((att) => (
              <a key={att.url} href={att.url} download target="_blank" rel="noreferrer" className="attachment-card">
                {att.isImage ? <img src={att.url} alt={att.name} /> : <span className="attachment-name">{att.name}</span>}
              </a>
            ))}
          </div>
        </div>
      ) : null}
    </div>
  );

  const detailRendererWithActions = ({ post }) => (
    <div>
      {detailRenderer({ post })}
      <div className="detail-actions-row">
        {post.deleteYn === "Y" ? (
          <button className="delete-btn" onClick={() => setActionModal({ open: true, mode: "restore", postId: post.id, status: "confirm" })}>
            복구
          </button>
        ) : (
          <button className="delete-btn" onClick={() => setActionModal({ open: true, mode: "delete", postId: post.id, status: "confirm" })}>
            삭제
          </button>
        )}
      </div>
    </div>
  );

  return (
    <>
      <BoardManager
        boardTitle="자유 게시판 게시물 관리"
        initialPosts={activePosts}
        categories={["정보", "잡담", "이벤트", "제휴"]}
        chartLabels={["1", "2", "3", "4", "5"]}
        chartData={chartData.length ? chartData : [0, 0, 0, 0, 0]}
        chartDatasetLabel="게시글 등록 추이"
        storageKey={null}
        loading={loading}
        columns={columns}
        detailRenderer={detailRendererWithActions}
      />

      <BoardManager
        boardTitle="삭제된 자유 게시판 게시물 관리"
        initialPosts={deletedPosts}
        categories={["정보", "잡담", "이벤트", "제휴"]}
        chartLabels={[]}
        chartData={[]}
        chartDatasetLabel="삭제 게시글"
        storageKey={null}
        loading={loading}
        columns={deletedColumns}
        detailRenderer={detailRendererWithActions}
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
                  onClick={() => setActionModal({ open: false, mode: null, postId: null, status: "confirm" })}
                >
                  아니오
                </button>
              </div>
            ) : null}
          </div>
        </div>
      )}
    </>
  );
};

export default PostFreeBoard;
