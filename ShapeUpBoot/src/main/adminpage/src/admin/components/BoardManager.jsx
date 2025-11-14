import React, { useEffect, useMemo, useRef, useState } from "react";
import Chart from "chart.js/auto";
import "../styles/PostNotice.css";

const defaultChartLabels = ["11월 1주", "11월 2주", "11월 3주", "11월 4주", "12월 1주"];

const BoardManager = ({
  boardTitle = "게시판",
  initialPosts = [],
  categories = [],
  chartLabels = defaultChartLabels,
  chartData = [5, 9, 3, 7, 6],
  chartDatasetLabel = "등록 게시물 수",
  detailMode = "edit",
}) => {
  const [posts, setPosts] = useState(initialPosts);
  const [selectedPost, setSelectedPost] = useState(null);
  const [categoryFilter, setCategoryFilter] = useState("전체");
  const [titleQuery, setTitleQuery] = useState("");
  const [advancedFilter, setAdvancedFilter] = useState("전체");
  const [advancedQuery, setAdvancedQuery] = useState("");
  const [sort, setSort] = useState({ key: "id", dir: "asc" });
  const [pageSize, setPageSize] = useState(10);
  const [page, setPage] = useState(1);
  const [pageInput, setPageInput] = useState("");
  const chartRef = useRef(null);
  const [deleteModal, setDeleteModal] = useState({ open: false, status: "confirm" });

  useEffect(() => {
    setPosts(initialPosts);
  }, [initialPosts]);

  const categoryOptions = useMemo(() => {
    const options = ["전체"];
    categories.forEach((cat) => {
      if (cat && !options.includes(cat)) options.push(cat);
    });
    return options;
  }, [categories]);

  const getDisplayDate = (post) => {
    if (post.category === "이벤트") {
      const start = post.startDate ?? "";
      const end = post.endDate ?? "";
      if (start && end) return `${start} ~ ${end}`;
      if (start) return `${start} ~`;
      if (end) return `~ ${end}`;
      return "-";
    }
    return post.date ?? "-";
  };

  const getSortDateValue = (post) =>
    post.category === "이벤트" ? post.startDate ?? post.date ?? "" : post.date ?? "";

  useEffect(() => {
    if (!chartRef.current) return;
    const ctx = chartRef.current.getContext("2d");
    const chartInstance = new Chart(ctx, {
      type: "bar",
      data: {
        labels: chartLabels,
        datasets: [
          {
            label: chartDatasetLabel,
            data: chartData,
            backgroundColor: "#007bff",
          },
        ],
      },
      options: { responsive: true, maintainAspectRatio: false },
    });
    return () => chartInstance.destroy();
  }, [chartLabels, chartDatasetLabel, chartData]);

  const handleSelectPost = (post) => setSelectedPost(post);
  const handleChange = (e) =>
    setSelectedPost((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  const handleUpdate = () => {
    if (!selectedPost) return;
    setPosts((prev) => prev.map((p) => (p.id === selectedPost.id ? selectedPost : p)));
    alert("게시물 수정 완료");
  };

  const toggleSort = (key) => {
    setSort((prev) =>
      prev.key === key ? { key, dir: prev.dir === "asc" ? "desc" : "asc" } : { key, dir: "asc" }
    );
  };
  const sortMark = (key) => (sort.key === key ? (sort.dir === "asc" ? " ▲" : " ▼") : "");

  const filteredPosts = useMemo(() => {
    const collator = new Intl.Collator("ko");
    const normalizeDate = (value = "") => {
      const iso = value.replace(/\./g, "-");
      const time = Date.parse(iso);
      return Number.isNaN(time) ? value : time;
    };
    const getVal = (post) => {
      switch (sort.key) {
        case "id":
          return post.id;
        case "date":
          return normalizeDate(getSortDateValue(post));
        case "author":
          return post.author ?? "";
        case "category":
          return post.category ?? "";
        case "title":
          return post.title ?? "";
        default:
          return "";
      }
    };

    const matchesPrimary = (post) => {
      const term = titleQuery.trim().toLowerCase();
      if (!term) return true;
      return (post.title ?? "").toLowerCase().includes(term);
    };

    const matchesAdvanced = (post) => {
      const query = advancedQuery.trim().toLowerCase();
      if (!query) return true;
      const dateVal = getDisplayDate(post).toLowerCase();
      const titleVal = (post.title ?? "").toLowerCase();
      const authorVal = (post.author ?? "").toLowerCase();

      switch (advancedFilter) {
        case "날짜":
          return dateVal.includes(query);
        case "제목":
          return titleVal.includes(query);
        case "작성자":
          return authorVal.includes(query);
        default:
          return dateVal.includes(query) || titleVal.includes(query) || authorVal.includes(query);
      }
    };

    const searched = posts
      .filter((post) => categoryFilter === "전체" || post.category === categoryFilter)
      .filter(matchesPrimary)
      .filter(matchesAdvanced);

    return [...searched].sort((a, b) => {
      const va = getVal(a);
      const vb = getVal(b);
      let cmp;
      if (typeof va === "number" && typeof vb === "number") cmp = va - vb;
      else cmp = collator.compare(String(va), String(vb));
      return sort.dir === "asc" ? cmp : -cmp;
    });
  }, [posts, categoryFilter, titleQuery, advancedFilter, advancedQuery, sort]);

  const totalPosts = filteredPosts.length;
  const totalPages = Math.max(1, Math.ceil(totalPosts / pageSize));
  const currentPage = Math.min(page, totalPages);
  const pageStart = (currentPage - 1) * pageSize;
  const paginatedPosts = filteredPosts.slice(pageStart, pageStart + pageSize);

  useEffect(() => {
    setPage(1);
    setPageInput("");
  }, [categoryFilter, titleQuery, advancedFilter, advancedQuery, pageSize]);

  useEffect(() => {
    setPage((prev) => Math.min(prev, totalPages));
  }, [totalPages]);

  const isEditable = detailMode === "edit";

  const openDeleteModal = () => {
    if (!selectedPost) return;
    setDeleteModal({ open: true, status: "confirm" });
  };

  const closeDeleteModal = () => setDeleteModal({ open: false, status: "confirm" });

  const confirmDelete = () => {
    if (!selectedPost) return;
    setDeleteModal({ open: true, status: "done" });
    setTimeout(() => {
      setPosts((prev) => prev.filter((post) => post.id !== selectedPost.id));
      setSelectedPost(null);
      closeDeleteModal();
    }, 1000);
  };

  return (
    <div className="posts-container">
      <div className="posts-list">
        <div className="posts-header">
          <span>
            {boardTitle} 게시물 관리{" "}
            <em className="count-label">(총 {totalPosts.toLocaleString()}건)</em>
          </span>
          <div className="search-stack">
            <div className="search-bar">
              <select value={categoryFilter} onChange={(e) => setCategoryFilter(e.target.value)}>
                {categoryOptions.map((option) => (
                  <option key={option} value={option}>
                    {option}
                  </option>
                ))}
              </select>
              <input
                type="text"
                placeholder="제목을 입력하세요"
                value={titleQuery}
                onChange={(e) => setTitleQuery(e.target.value)}
              />
              <select
                className="page-size-select"
                value={pageSize}
                onChange={(e) => setPageSize(Number(e.target.value))}
              >
                {[5, 10, 30, 50].map((size) => (
                  <option key={size} value={size}>
                    {size}개
                  </option>
                ))}
              </select>
            </div>
            <div className="search-bar secondary-search">
              <select value={advancedFilter} onChange={(e) => setAdvancedFilter(e.target.value)}>
                <option value="전체">전체</option>
                <option value="날짜">날짜</option>
                <option value="제목">제목</option>
                <option value="작성자">작성자</option>
              </select>
              <input
                type="text"
                placeholder="추가 검색어 입력"
                value={advancedQuery}
                onChange={(e) => setAdvancedQuery(e.target.value)}
              />
            </div>
          </div>
        </div>

        <table className="posts-table">
          <thead>
            <tr>
              <th onClick={() => toggleSort("id")} style={{ cursor: "pointer" }}>
                번호{sortMark("id")}
              </th>
              <th onClick={() => toggleSort("date")} style={{ cursor: "pointer" }}>
                날짜{sortMark("date")}
              </th>
              <th onClick={() => toggleSort("author")} style={{ cursor: "pointer" }}>
                작성자{sortMark("author")}
              </th>
              <th onClick={() => toggleSort("category")} style={{ cursor: "pointer" }}>
                카테고리{sortMark("category")}
              </th>
              <th onClick={() => toggleSort("title")} style={{ cursor: "pointer" }}>
                제목{sortMark("title")}
              </th>
              <th>이동</th>
            </tr>
          </thead>
          <tbody>
            {paginatedPosts.map((post, idx) => (
              <tr key={post.id} onClick={() => handleSelectPost(post)}>
                <td>{pageStart + idx + 1}</td>
                <td>{getDisplayDate(post)}</td>
                <td>{post.author}</td>
                <td>{post.category}</td>
                <td>{post.title}</td>
                <td>
                  <button className="move-btn">보기</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>

        <div className="pagination-controls">
          <button
            type="button"
            onClick={() => setPage((prev) => Math.max(1, prev - 1))}
            disabled={currentPage === 1}
          >
            &lt;
          </button>
          <span className="pagination-status">
            {currentPage}/{totalPages}
          </span>
          <input
            type="number"
            min="1"
            max={totalPages}
            className="pagination-input"
            placeholder="페이지 입력"
            value={pageInput}
            onChange={(e) => setPageInput(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter") {
                const target = Number(e.currentTarget.value);
                if (!Number.isNaN(target) && target >= 1 && target <= totalPages) {
                  setPage(target);
                  setPageInput("");
                }
              }
            }}
          />
          <button
            type="button"
            onClick={() => setPage((prev) => Math.min(totalPages, prev + 1))}
            disabled={currentPage === totalPages}
          >
            &gt;
          </button>
        </div>
      </div>

      <div className="posts-detail">
        <div className="detail-header">
          {boardTitle} {isEditable ? "게시물 상태 수정" : "상세 정보"}
        </div>
        {selectedPost ? (
          <div className="detail-body">
            <label>게시글 번호</label>
            {isEditable ? (
              <input type="text" value={selectedPost.id} disabled />
            ) : (
              <p className="detail-text">{selectedPost.id}</p>
            )}

            <label>제목</label>
            {isEditable ? (
              <input type="text" name="title" value={selectedPost.title} onChange={handleChange} />
            ) : (
              <p className="detail-text">{selectedPost.title}</p>
            )}

            <div className="row-inputs">
              {selectedPost.category === "이벤트" ? (
                isEditable ? (
                  <>
                    <div>
                      <label>시작일</label>
                      <input
                        type="text"
                        name="startDate"
                        placeholder="YYYY.MM.DD"
                        value={selectedPost.startDate || ""}
                        onChange={handleChange}
                      />
                    </div>
                    <div>
                      <label>종료일</label>
                      <input
                        type="text"
                        name="endDate"
                        placeholder="YYYY.MM.DD"
                        value={selectedPost.endDate || ""}
                        onChange={handleChange}
                      />
                    </div>
                  </>
                ) : (
                  <>
                    <div>
                      <label>시작일</label>
                      <p className="detail-text">{selectedPost.startDate || "-"}</p>
                    </div>
                    <div>
                      <label>종료일</label>
                      <p className="detail-text">{selectedPost.endDate || "-"}</p>
                    </div>
                  </>
                )
              ) : isEditable ? (
                <div>
                  <label>날짜</label>
                  <input type="text" value={selectedPost.date} disabled />
                </div>
              ) : (
                <div>
                  <label>날짜</label>
                  <p className="detail-text">{selectedPost.date}</p>
                </div>
              )}
              <div>
                <label>작성자</label>
                {isEditable ? (
                  <input type="text" value={selectedPost.author} disabled />
                ) : (
                  <p className="detail-text">{selectedPost.author}</p>
                )}
              </div>
            </div>

            <label>내용</label>
            {isEditable ? (
              <textarea
                name="content"
                placeholder="내용을 입력하세요"
                value={selectedPost.content || ""}
                onChange={handleChange}
              />
            ) : (
              <div className="detail-content-block">{selectedPost.content || "내용이 없습니다."}</div>
            )}

            <label>첨부파일</label>
            {isEditable ? (
              <input type="file" />
            ) : selectedPost.attachments && selectedPost.attachments.length ? (
              <ul className="attachments-list">
                {selectedPost.attachments.map((file, idx) => (
                  <li key={file + idx}>
                    <span className="attachment-icon">📎</span>
                    {file}
                  </li>
                ))}
              </ul>
            ) : (
              <p className="detail-text">첨부된 파일이 없습니다.</p>
            )}

            {isEditable ? (
              <button className="update-btn" onClick={handleUpdate}>
                수정
              </button>
            ) : (
              <button className="delete-btn" onClick={openDeleteModal}>
                삭제
              </button>
            )}
          </div>
        ) : (
          <p className="empty">게시물을 선택하세요.</p>
        )}
      </div>

      <div className="posts-chart">
        <div className="chart-header">{boardTitle} 등록 추이</div>
        <div className="chart-area">
          <canvas ref={chartRef}></canvas>
        </div>
      </div>

      {deleteModal.open && selectedPost && (
        <div className="modal-overlay">
          <div className="modal delete">
            <div className="modal-header">
              <h3>게시물 삭제</h3>
              {deleteModal.status === "confirm" && (
                <button className="close" onClick={closeDeleteModal}>
                  ×
                </button>
              )}
            </div>
            <div className="modal-body">
              {deleteModal.status === "confirm" ? <p>삭제하시겠습니까?</p> : <p>삭제되었습니다.</p>}
            </div>
            {deleteModal.status === "confirm" && (
              <div className="modal-footer">
                <button className="confirm-btn" onClick={confirmDelete}>
                  네
                </button>
                <button className="cancel-btn" onClick={closeDeleteModal}>
                  아니요
                </button>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
};

export default BoardManager;
