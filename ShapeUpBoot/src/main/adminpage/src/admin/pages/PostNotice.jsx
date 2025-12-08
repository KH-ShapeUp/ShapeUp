import React, { useEffect, useMemo, useState } from "react";
import BoardManager from "../components/BoardManager";
import "../styles/PostNotice.css";
import { BOARD_STORAGE_KEYS } from "../../common/utils/storageKeys";
import CustomSelect from "../../common/components/CustomSelect";

const API_BASE =
  import.meta.env.VITE_API_BASE ||
  (typeof window !== "undefined" && window.location.port === "5173" ? "http://localhost:8080" : "");
const PostNotice = () => {
  const [posts, setPosts] = useState([]);
  const [loading, setLoading] = useState(false);
  const [chartData, setChartData] = useState([0, 0, 0, 0, 0]);

  const [category, setCategory] = useState("공지");
  const [title, setTitle] = useState("");
  const [eventStart, setEventStart] = useState("");
  const [eventEnd, setEventEnd] = useState("");
  const [content, setContent] = useState("");
  const [files, setFiles] = useState([]);
  const [filePreviews, setFilePreviews] = useState([]);
  const [modal, setModal] = useState({ open: false, status: "confirm" });
  const [bannerToggle, setBannerToggle] = useState(false);
  const [bannerTitle, setBannerTitle] = useState("");
  const [bannerFile, setBannerFile] = useState(null);
  const [bannerPreview, setBannerPreview] = useState("");
  const [errors, setErrors] = useState({});

  const handleFiles = (e) => {
    const fileList = Array.from(e.target.files || []);
    setFiles(fileList);
    setFilePreviews(fileList.map((f) => ({ name: f.name, url: URL.createObjectURL(f) })));
  };
  const handleBannerFile = (e) => {
    const f = e.target.files?.[0];
    setBannerFile(f || null);
    setBannerPreview(f ? URL.createObjectURL(f) : "");
  };

  const resetForm = () => {
    setCategory("공지");
    setTitle("");
    setEventStart("");
    setEventEnd("");
    setContent("");
    setFiles([]);
    setFilePreviews([]);
    setBannerToggle(false);
    setBannerTitle("");
    setBannerFile(null);
    setBannerPreview("");
    setErrors({});
  };

  const normalizeDate = (val) => {
    if (!val) return "";
    const d = new Date(val);
    if (Number.isNaN(d.getTime())) return val;
    const y = d.getFullYear();
    const m = String(d.getMonth() + 1).padStart(2, "0");
    const dd = String(d.getDate()).padStart(2, "0");
    return `${y}.${m}.${dd}`;
  };

  const uploadBanner = async (noticeNo, file, title, enabled) => {
    if (!noticeNo || !file || !enabled) return;
    try {
      const form = new FormData();
      form.append("bannerTitle", title || "");
      form.append("bannerYn", enabled ? "Y" : "N");
      form.append("file", file);
      await fetch(`${API_BASE}/api/admin/notices/${noticeNo}/banner`, {
        method: "POST",
        body: form,
        credentials: "include",
      });
    } catch (err) {
      console.error("배너 업로드 실패", err);
    }
  };

  // const API_BASE = window.location.port === "5173" ? "http://localhost:8080" : "";

  const fetchNotices = async () => {
    setLoading(true);
    try {
      const res = await fetch(`${API_BASE}/api/admin/notices?page=1&size=200`, {
        credentials: "include",
      });
      if (!res.ok) throw new Error(`status ${res.status}`);
      const data = await res.json();
      const items = Array.isArray(data.items) ? data.items : [];
      const resolveUrl = (path) => {
        if (!path) return "";
        if (path.startsWith("http")) return path;
        return `${API_BASE}${path.startsWith("/") ? "" : "/"}${path}`;
      };
      const mapped = items.map((n) => ({
        id: n.noticeNo,
        date: normalizeDate(n.eventStart || n.createdAt),
        author: n.userName || (n.userNo ? `작성자#${n.userNo}` : "관리자"),
        category: n.noticeCategory || n.category || "공지",
        title: n.noticeTitle,
        startDate: n.eventStart ? normalizeDate(n.eventStart) : undefined,
        endDate: n.eventEnd ? normalizeDate(n.eventEnd) : undefined,
        content: n.noticeContent,
        bannerYn: n.bannerYn === "Y" ? "Y" : "N",
        bannerTitle: n.bannerTitle || "",
        bannerImgPath: resolveUrl(n.bannerImgPath || ""),
        images: Array.isArray(n.images)
          ? n.images.map((img) => ({ ...img, imgPath: resolveUrl(img.imgPath) }))
          : [],
      }));
      setPosts(mapped);
      // 트렌드 데이터 불러오기
      try {
        const trendRes = await fetch(`${API_BASE}/api/admin/notices/trend`, { credentials: "include" });
        if (trendRes.ok) {
          const trend = await trendRes.json();
          const labels = trend.map((t) => t.LABEL || t.label);
          const counts = trend.map((t) => t.CNT || t.cnt || 0);
          if (labels.length && counts.length) {
            setChartData(counts);
          }
        }
      } catch (err) {
        console.warn("트렌드 불러오기 실패", err);
      }
    } catch (err) {
      console.error("공지 목록 불러오기 실패", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchNotices();
  }, []);

  const validate = () => {
    const next = {};
    if (!title.trim()) next.title = true;
    // if (!content.trim()) next.content = true;
    if (category === "이벤트" && !eventEnd) next.eventEnd = true;
    setErrors(next);
    return Object.keys(next).length === 0;
  };

  const openSubmit = () => {
    if (!validate()) return;
    setModal({ open: true, status: "confirm" });
  };

  const submitNotice = async () => {
    const body = {
      noticeTitle: title,
      noticeContent: content,
      noticeCategory: category,
      eventStart: category === "이벤트" ? eventStart || new Date().toISOString().slice(0, 10) : null,
      eventEnd: category === "이벤트" ? eventEnd : null,
      userNo: 1, // TODO: 실제 로그인 세션 사용자 번호로 교체
    };
    try {
      const res = await fetch(`${API_BASE}/api/admin/notices`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        credentials: "include",
        body: JSON.stringify(body),
      });
      if (!res.ok) throw new Error(`status ${res.status}`);
      const created = await res.json();
      // 이미지 업로드
      if (files.length && created.noticeNo) {
        const form = new FormData();
        files.forEach((f) => form.append("files", f));
        await fetch(`${API_BASE}/api/admin/notices/${created.noticeNo}/images`, {
          method: "POST",
          body: form,
          credentials: "include",
        });
      }
      if (bannerToggle && bannerFile && created.noticeNo) {
        await uploadBanner(created.noticeNo, bannerFile, bannerTitle, bannerToggle);
      }
      setModal({ open: true, status: "done" });
      resetForm();
      setTimeout(() => {
        setModal({ open: false, status: "confirm" });
        fetchNotices();
      }, 1000);
    } catch (err) {
      console.error("등록 실패", err);
      setModal({ open: false, status: "confirm" });
    }
  };

  const handleDeleteImage = async (imgNo, noticeId) => {
    try {
      await fetch(`${API_BASE}/api/admin/notices/${noticeId}/images/${imgNo}`, {
        method: "DELETE",
        credentials: "include",
      });
    } catch (err) {
      console.error("첨부 삭제 실패", err);
    }
  };

  const handleUploadImages = async (newFiles, noticeId) => {
    try {
      const form = new FormData();
      newFiles.forEach((f) => form.append("files", f));
      await fetch(`${API_BASE}/api/admin/notices/${noticeId}/images`, {
        method: "POST",
        body: form,
        credentials: "include",
      });
      fetchNotices();
      return true;
    } catch (err) {
      console.error("첨부 추가 실패", err);
      return false;
    }
  };

  const handleUpdatePost = async (post) => {
    const payload = {
      noticeTitle: post.title,
      noticeContent: post.content || "",
      noticeCategory: post.category || "공지",
      eventStart: post.startDate || null,
      eventEnd: post.endDate || null,
    };
    const res = await fetch(`${API_BASE}/api/admin/notices/${post.id}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      credentials: "include",
      body: JSON.stringify(payload),
    });
    if (!res.ok) {
      throw new Error(`update failed ${res.status}`);
    }
    await fetchNotices();
  };

  const handleDeletePost = async (id) => {
    await fetch(`${API_BASE}/api/admin/notices/${id}`, {
      method: "DELETE",
      credentials: "include",
    });
    fetchNotices();
  };

  return (
    <div className="posts-page">
      <header className="title-header">
        <div>
          <h2>공지사항 관리</h2>
          <p>공지/이벤트/제휴/징계를 작성하고 배너를 설정하세요.</p>
        </div>
      </header>
      <BoardManager
        boardTitle="공지사항"
        initialPosts={posts}
        categories={["공지", "이벤트", "제휴", "징계"]}
        chartLabels={["11월 1주", "11월 2주", "11월 3주", "11월 4주", "12월 1주"]}
        chartData={chartData}
        chartDatasetLabel="공지 등록 수"
        storageKey={null}
        loading={loading}
        onDeleteImage={handleDeleteImage}
        onUploadImages={handleUploadImages}
        onUpdatePost={handleUpdatePost}
        onDeletePost={handleDeletePost}
        onUploadBanner={uploadBanner}
      />

      <div className="notice-compose-card">
        <div className="compose-header">
          <div>
            <h3>공지사항 작성</h3>
            <p className="compose-sub">제목, 카테고리, 본문을 입력하고 필요 시 이미지를 첨부하세요.</p>
          </div>
          <div className="compose-actions">
            <button className="primary-btn" type="button" onClick={openSubmit}>
              등록
            </button>
          </div>
        </div>

        <div className="compose-row">
        <div className="compose-field">
          <label>제목</label>
          <input
            type="text"
            placeholder="제목을 입력하세요"
            value={title}
            onChange={(e) => {
              setTitle(e.target.value);
              if (errors.title) setErrors((prev) => ({ ...prev, title: false }));
            }}
            style={errors.title ? { borderColor: "red" } : {}}
          />
        </div>
        <div className="compose-field narrow">
          <label>카테고리</label>
          <CustomSelect
              value={category}
              options={["공지", "이벤트", "제휴", "징계"].map((c) => ({ label: c, value: c }))}
              onChange={setCategory}
              size="sm"
            />
        </div>
      </div>

        {category === "이벤트" && (
          <div className="compose-row">
            <div className="compose-field">
              <label>시작일</label>
              <input
                type="date"
                value={eventStart}
                onChange={(e) => setEventStart(e.target.value)}
              />
            </div>
            <div className="compose-field">
              <label>종료일</label>
              <input
                type="date"
                value={eventEnd}
                onChange={(e) => {
                  setEventEnd(e.target.value);
                  if (errors.eventEnd) setErrors((prev) => ({ ...prev, eventEnd: false }));
                }}
                style={errors.eventEnd ? { borderColor: "red" } : {}}
              />
            </div>
          </div>
        )}

          <div className="compose-field compose-full">
            <label>본문</label>
            <textarea
              placeholder="본문을 입력하세요"
              value={content}
              onChange={(e) => {
                setContent(e.target.value);
                if (errors.content) setErrors((prev) => ({ ...prev, content: false }));
              }}
              rows={10}
              className="compose-textarea"
              style={errors.content ? { borderColor: "red" } : {}}
            />
          </div>

        <div className="compose-field">
          <label>첨부파일 (이미지)</label>
          <input type="file" accept="image/*" multiple onChange={handleFiles} />
          {filePreviews.length > 0 && (
            <div className="preview-wrap">
              {filePreviews.map((fp, idx) => (
                <div key={fp.name + idx} className="preview-chip">
                  <span className="clip">📎</span>
                  <span className="name">{fp.name}</span>
                  <img src={fp.url} alt={fp.name} className="preview-thumb" />
                </div>
              ))}
            </div>
          )}
        </div>

        <div className="banner-section">
          <div className="banner-header">
            <label>공지사항 배너 노출</label>
            <div
              className={`toggle ${bannerToggle ? "on" : "off"}`}
              onClick={() => setBannerToggle((v) => !v)}
            >
              <span className="knob" />
            </div>
          </div>
          <div className="banner-fields">
            <div className="compose-field">
              <label>배너 제목</label>
              <input
                type="text"
                placeholder="배너에 표시할 제목"
                value={bannerTitle}
                onChange={(e) => setBannerTitle(e.target.value)}
              />
            </div>
            <div className="compose-field">
              <label>배너 이미지</label>
              <input type="file" accept="image/*" onChange={handleBannerFile} />
              {bannerFile && <p className="banner-file-name">{bannerFile.name}</p>}
              {bannerPreview && (
                <div className="image-thumb" style={{ marginTop: "6px" }}>
                  <img src={bannerPreview} alt="배너 미리보기" />
                </div>
              )}
            </div>
          </div>
          <p className="muted small">배너 업로드 경로: uploads/notice/{"{userid}"}/banner/</p>
        </div>
      </div>

      {modal.open && (
        <div className="modal-overlay">
          <div className="modal">
            <div className="modal-header">
              <h3>공지 등록</h3>
            </div>
            <div className="modal-body">
              {modal.status === "confirm" ? "등록하시겠습니까?" : "등록되었습니다."}
            </div>
            {modal.status === "confirm" ? (
              <div className="modal-footer">
                <button className="confirm-btn" onClick={submitNotice}>예</button>
                <button className="cancel-btn" onClick={() => setModal({ open: false, status: "confirm" })}>
                  아니오
                </button>
              </div>
            ) : null}
          </div>
        </div>
      )}
    </div>
  );
};

export default PostNotice;
