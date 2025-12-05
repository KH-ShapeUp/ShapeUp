import React, { useEffect, useMemo, useState } from "react";
import "../styles/PostNotice.css";
import CustomSelect from "../../common/components/CustomSelect";

const API_BASE =
  import.meta?.env?.VITE_API_BASE ||
  (typeof window !== "undefined" && window.location.port === "5173" ? "http://localhost:8080" : "");

const statusOptions = [
  { label: "전체", value: "" },
  { label: "대기", value: "대기" },
  { label: "완료", value: "완료" },
];

const PostContactBoard = () => {
  const [items, setItems] = useState([]);
  const [selected, setSelected] = useState(null);
  const [loading, setLoading] = useState(false);
  const [statusFilter, setStatusFilter] = useState("");
  const [categoryFilter, setCategoryFilter] = useState("");
  const [page, setPage] = useState(1);
  const [total, setTotal] = useState(0);
  const size = 10;
  const [answer, setAnswer] = useState("");
  const [modal, setModal] = useState({ open: false, mode: "confirm" });
  const [pageInput, setPageInput] = useState("");

  const columns = useMemo(
    () => [
      { key: "id", label: "번호", width: "70px" },
      { key: "title", label: "제목", width: "40%" },
      { key: "category", label: "유형", width: "120px" },
      { key: "status", label: "상태", width: "100px" },
      { key: "createdAt", label: "작성일", width: "160px" },
      { key: "userName", label: "작성자", width: "140px" },
    ],
    []
  );

  const loadList = async () => {
    setLoading(true);
    try {
      const qs = new URLSearchParams({
        page: String(page),
        size: String(size),
      });
      if (statusFilter) qs.append("status", statusFilter);
      if (categoryFilter) qs.append("category", categoryFilter);
      const res = await fetch(`${API_BASE}/contact/api/admin/list?${qs.toString()}`, {
        credentials: "include",
      });
      if (!res.ok) throw new Error("fail");
      const data = await res.json();
      console.log("admin contact raw:", data);
      const mapped = (data.items || [])
        .map((d) => {
          const get = (k) => {
            const snake = k?.replace(/[A-Z]/g, (m) => "_" + m.toLowerCase());
            const upperSnake = snake?.toUpperCase();
            return (
              d[k] ??
              d[k?.toLowerCase()] ??
              d[snake] ??
              d[upperSnake] ??
              d[k?.toUpperCase()]
            );
          };
          const parseId = (v) => {
            if (v === undefined || v === null) return null;
            const num = Number(String(v).trim());
            return Number.isNaN(num) ? null : num;
          };
          const idVal = parseId(get("contactNo")) ?? parseId(get("contact_no"));
          if (idVal === null) {
            console.warn("contactNo missing in admin list item", d);
            return null;
          }
          return {
            id: idVal,
            title: get("contactTitle"),
            category: get("category"),
            status: get("status"),
            createdAt: (() => {
              const v = get("createdAt");
              if (!v) return "";
              if (!Number.isNaN(Number(v))) {
                const d = new Date(Number(v));
                return Number.isNaN(d.getTime()) ? String(v) : d.toISOString().replace("T", " ").slice(0, 19);
              }
              return v.toString().replace("T", " ").slice(0, 19);
            })(),
            userName: get("userNickname") || get("nickname") || get("userId") || get("userName") || get("userNo"),
            userNo: get("userNo"),
            content: get("contactContent"),
            answerContent: get("answerContent"),
            answerAt: get("answerAt"),
          };
        })
        .filter(Boolean);
      setItems(mapped);
      setTotal(data.total || 0);
      if (mapped.length && !selected) setSelected(mapped[0]);
    } catch (e) {
      console.error(e);
      alert("목록을 불러오지 못했습니다.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadList();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [page, statusFilter, categoryFilter]);

  useEffect(() => {
    // 필터 변경 시 첫 페이지로 이동
    setPage(1);
  }, [statusFilter, categoryFilter]);

  const selectItem = (item) => {
    setSelected(item);
    setAnswer(item.answerContent || "");
  };

  const saveAnswer = async () => {
    if (!selected) return;
    try {
      const res = await fetch(`${API_BASE}/contact/api/admin/answer`, {
        method: "POST",
        credentials: "include",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ contactNo: selected.id, answerContent: answer }),
      });
      if (!res.ok) throw new Error("fail");
      setSelected((prev) => prev && { ...prev, answerContent: answer, status: "완료" });
      setModal({ open: true, mode: "done" });
      setTimeout(() => setModal({ open: false, mode: "confirm" }), 1000);
      loadList();
    } catch (e) {
      alert("등록에 실패했습니다.");
    }
  };

  const handleAnswerClick = () => {
    if (!selected || !answer.trim()) return;
    setModal({ open: true, mode: "confirm" });
  };

  const totalPages = Math.max(1, Math.ceil(total / size));

  return (
    <>
    <div className="posts-page">
      <header className="title-header">
        <div>
          <h2>고객센터 문의 관리</h2>
          <p>사용자 문의 내역을 확인하고 답변을 등록하세요.</p>
        </div>
      </header>

      <div className="posts-container">
        <div className="posts-list">
          <div className="posts-header">
            <span>
              문의 목록 <em className="count-label">(총 {total.toLocaleString()}건)</em>
            </span>
            <div className="search-stack">
              <div className="search-bar">
                <CustomSelect
                  value={statusFilter}
                  options={statusOptions}
                  onChange={setStatusFilter}
                  size="sm"
                  className="page-size-select"
                />
                <CustomSelect
                  value={categoryFilter}
                  options={[
                    { label: "유형 전체", value: "" },
                    { label: "질문", value: "질문" },
                    { label: "건의", value: "건의" },
                    { label: "버그", value: "버그" },
                  ]}
                  onChange={setCategoryFilter}
                  size="sm"
                  className="page-size-select"
                />
              </div>
            </div>
          </div>
          <table className="posts-table">
            <thead>
              <tr>
                {columns.map((col) => (
                  <th key={col.key} style={col.width ? { width: col.width } : undefined}>
                    {col.label}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {items.map((item, idx) => (
                <tr
                  key={item.id}
                  onClick={() => selectItem(item)}
                  className={selected?.id === item.id ? "active" : undefined}
                >
                  {columns.map((col) => (
                    <td key={`${item.id}-${col.key}`}>
                      {col.key === "id" ? (page - 1) * size + idx + 1 : item[col.key]}
                    </td>
                  ))}
                </tr>
              ))}
              {!items.length && (
                <tr>
                  <td colSpan={columns.length}>문의가 없습니다.</td>
                </tr>
              )}
            </tbody>
          </table>

          <div className="pagination-controls">
            <button type="button" onClick={() => setPage((p) => Math.max(1, p - 1))} disabled={page === 1}>
              &lt;
            </button>
            <span className="pagination-status">
              {page}/{totalPages}
            </span>
            <input
              type="number"
              min={1}
              max={totalPages}
              value={pageInput}
              placeholder="페이지"
              className="pagination-input"
              onChange={(e) => setPageInput(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === "Enter") {
                  const v = Number(e.currentTarget.value);
                  if (!Number.isNaN(v) && v >= 1 && v <= totalPages) {
                    setPage(v);
                    setPageInput("");
                  }
                }
              }}
            />
            <button
              type="button"
              onClick={() => setPage((p) => Math.min(totalPages, p + 1))}
              disabled={page === totalPages}
            >
              &gt;
            </button>
          </div>
        </div>

        <div className="posts-detail">
          <div className="detail-header">문의 상세 / 답변</div>
          {selected ? (
            <div className="detail-body matching-detail">
              <div className="grid-3">
                <div className="field">
                  <label>번호</label>
                  <p className="detail-text">{selected.id}</p>
                </div>
            <div className="field">
              <label>작성자</label>
              <p className="detail-text">{selected.userName}</p>
            </div>
                <div className="field">
                  <label>유형</label>
                  <p className="detail-text">{selected.category}</p>
                </div>
                <div className="field">
                  <label>상태</label>
                  <p className="detail-text">{selected.status}</p>
                </div>
                <div className="field">
                  <label>작성일</label>
                  <p className="detail-text">{selected.createdAt}</p>
                </div>
              </div>
              <div className="field full">
                <label>제목</label>
                <p className="detail-text">{selected.title}</p>
              </div>
              <div className="field full">
                <label>본문</label>
                <div className="detail-content-block tall">{selected.content || "내용이 없습니다."}</div>
              </div>
              <div className="field full">
                <label>답변</label>
                <textarea
                  value={answer}
                  onChange={(e) => setAnswer(e.target.value)}
                  placeholder="답변을 입력하세요"
                  style={{ minHeight: "160px" }}
                  disabled={selected.status === "완료"}
                />
              </div>
              <div className="detail-actions-row">
                <button
                  className="confirm-btn"
                  onClick={() => setModal({ open: true, mode: "confirm" })}
                  disabled={loading || !answer.trim() || selected.status === "완료"}
                >
                  {selected.status === "완료" ? "답변 완료했습니다." : "답변 등록"}
                </button>
              </div>
            </div>
          ) : (
            <p>문의가 없습니다.</p>
          )}
        </div>
      </div>
    </div>
      {modal.open && (
        <div className="modal-overlay">
          <div className="modal delete">
            <div className="modal-header">
              <h3>{modal.mode === "confirm" ? "답변 등록" : "완료"}</h3>
            </div>
            <div className="modal-body">
              {modal.mode === "confirm" ? "등록하시겠습니까?" : "등록되었습니다."}
            </div>
            <div className="modal-footer">
              {modal.mode === "confirm" ? (
                <>
                  <button className="confirm-btn" onClick={saveAnswer}>예</button>
                  <button className="cancel-btn" onClick={() => setModal({ open: false, mode: "confirm" })}>아니오</button>
                </>
              ) : (
                <button className="confirm-btn" onClick={() => setModal({ open: false, mode: "confirm" })}>확인</button>
              )}
            </div>
          </div>
        </div>
      )}
    </>
  );
};

export default PostContactBoard;
