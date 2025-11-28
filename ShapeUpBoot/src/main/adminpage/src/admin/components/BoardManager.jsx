import React, { useEffect, useMemo, useRef, useState } from "react";
import Chart from "chart.js/auto";
import "../styles/PostNotice.css";
import { BOARD_STORAGE_EVENT } from "../../common/utils/storageKeys";
import CustomSelect from "../../common/components/CustomSelect";

const defaultChartLabels = ["11월 1주", "11월 2주", "11월 3주", "11월 4주", "12월 1주"];
const isBrowser = typeof window !== "undefined";

const BoardManager = ({
  boardTitle = "게시판",
  initialPosts = [],
  categories = [],
  chartLabels = defaultChartLabels,
  chartData = [5, 9, 3, 7, 6],
  chartDatasetLabel = "등록 게시물 수",
  detailMode = "edit",
  storageKey = null,
  onDeleteImage = null,
  onUpdatePost = null,
  onDeletePost = null,
  onUploadImages = null,
  columns = null,
  detailRenderer = null,
}) => {
  const loadStoredPosts = () => {
    const fallback = Array.isArray(initialPosts) ? initialPosts : [];
    if (!storageKey || !isBrowser) return fallback;
    try {
      const raw = window.localStorage.getItem(storageKey);
      if (!raw) {
        window.localStorage.setItem(storageKey, JSON.stringify(fallback));
        return fallback;
      }
      const parsed = JSON.parse(raw);
      if (Array.isArray(parsed)) return parsed;
    } catch (err) {
      console.warn(`Failed to load board data for ${storageKey}`, err);
    }
    try {
      window.localStorage.setItem(storageKey, JSON.stringify(fallback));
    } catch {
      /* ignore */
    }
    return fallback;
  };

  const [posts, setPosts] = useState(() => loadStoredPosts());
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
    if (storageKey) return;
    setPosts(initialPosts);
  }, [initialPosts, storageKey]);

  useEffect(() => {
    if (!storageKey || !isBrowser) return;
    try {
      window.localStorage.setItem(storageKey, JSON.stringify(posts));
      window.dispatchEvent(
        new CustomEvent(BOARD_STORAGE_EVENT, { detail: { storageKey } })
      );
    } catch (err) {
      console.warn(`Failed to save board data for ${storageKey}`, err);
    }
  }, [posts, storageKey]);

  const categoryOptions = useMemo(() => {
    const options = ["전체"];
    categories.forEach((cat) => {
      if (cat && !options.includes(cat)) options.push(cat);
    });
    return options;
  }, [categories]);

  const advancedOptions = useMemo(() => ["전체", "날짜", "제목", "작성자"], []);
  const pageSizeOptions = useMemo(() => ["5", "10", "30", "50"], []);

  const defaultColumns = useMemo(
    () => [
      { key: "id", label: "번호", sortable: "id" },
      { key: "date", label: "날짜", sortable: "date" },
      { key: "author", label: "작성자", sortable: "author" },
      { key: "category", label: "카테고리", sortable: "category" },
      { key: "title", label: "제목", sortable: "title" },
      { key: "actions", label: "삭제" },
    ],
    []
  );
  const columnsToUse = columns && columns.length ? columns : defaultColumns;

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
  const [actionModal, setActionModal] = useState({ open: false, mode: null, status: "confirm" });

  const handleUpdate = () => {
    if (!selectedPost) return;
    setActionModal({ open: true, mode: "update", status: "confirm" });
  };

  const handleDeletePost = () => {
    if (!selectedPost) return;
    setActionModal({ open: true, mode: "delete", status: "confirm" });
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
        case "activityName":
          return post.activityName ?? "";
        case "location":
          return post.location ?? "";
        case "level":
          return post.level ?? "";
        case "status":
          return post.status ?? "";
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
              <CustomSelect
                value={categoryFilter}
                options={categoryOptions.map((option) => ({ label: option, value: option }))}
                onChange={setCategoryFilter}
                size="sm"
              />
              <input
                type="text"
                placeholder="제목을 입력하세요"
                value={titleQuery}
                onChange={(e) => setTitleQuery(e.target.value)}
              />
              <CustomSelect
                className="page-size-select"
                value={String(pageSize)}
                options={pageSizeOptions.map((size) => ({ label: `${size}개`, value: size }))}
                onChange={(val) => setPageSize(Number(val))}
                size="sm"
              />
            </div>
            <div className="search-bar secondary-search">
              <CustomSelect
                value={advancedFilter}
                options={advancedOptions.map((option) => ({ label: option, value: option }))}
                onChange={setAdvancedFilter}
                size="sm"
              />
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
              {columnsToUse.map((col) => {
                const style = {
                  cursor: col.sortable ? "pointer" : "default",
                  ...(col.width ? { width: col.width } : {}),
                };
                return (
                  <th
                    key={col.key}
                    onClick={() => col.sortable && toggleSort(col.sortable)}
                    style={style}
                    className={col.sortable ? "sortable-header" : undefined}
                  >
                    <span className="header-label">
                      {col.label}
                      {col.sortable ? <span className="sort-mark">{sortMark(col.sortable)}</span> : null}
                    </span>
                  </th>
                );
              })}
            </tr>
          </thead>
          <tbody>
            {paginatedPosts.map((post, idx) => (
              <tr key={post.id} onClick={() => handleSelectPost(post)}>
                {columnsToUse.map((col) => {
                  if (col.key === "actions") {
                    return (
                      <td key={`${post.id}-actions`} style={col.width ? { width: col.width } : undefined}>
                        <button
                          className="delete-btn small"
                          onClick={(e) => {
                            e.stopPropagation();
                            handleSelectPost(post);
                            setActionModal({ open: true, mode: "delete", status: "confirm" });
                          }}
                        >
                          삭제
                        </button>
                      </td>
                    );
                  }
                  const value =
                    typeof col.render === "function"
                      ? col.render(post, pageStart + idx + 1)
                      : col.key === "id"
                      ? pageStart + idx + 1
                      : post[col.key] ?? "";
                  return (
                    <td
                      key={`${post.id}-${col.key}`}
                      style={col.width ? { width: col.width } : undefined}
                    >
                      {value}
                    </td>
                  );
                })}
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
          detailRenderer ? (
            detailRenderer({ post: selectedPost, onDelete: handleDeletePost })
          ) : (
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
              <div className="detail-content-block">
                {selectedPost.content || "내용이 없습니다."}
                {selectedPost.images && selectedPost.images.length > 0 && (
                  <div className="image-gallery">
                    {selectedPost.images.map((img, idx) => {
                      const src = img.imgPath || img.imgRename || img;
                      return (
                        <div key={img.imgRename || idx} className="image-thumb">
                          <img src={src} alt="첨부" />
                          {isEditable && onDeleteImage && img.imgNo && (
                            <button
                              type="button"
                              className="delete-img-btn"
                              onClick={() => {
                                onDeleteImage(img.imgNo, selectedPost.id);
                                setSelectedPost((prev) => ({
                                  ...prev,
                                  images: (prev.images || []).filter((im) => im.imgNo !== img.imgNo),
                                }));
                              }}
                            >
                              삭제
                            </button>
                          )}
                        </div>
                      );
                    })}
                  </div>
                )}
              </div>
            )}

            <label>첨부파일</label>
            {selectedPost.images && selectedPost.images.length > 0 ? (
              <div className="image-gallery">
                {selectedPost.images.map((img, idx) => {
                  const src = img.imgPath || img.imgRename || img;
                  return (
                    <div key={img.imgRename || idx} className="image-thumb">
                      <img src={src} alt="첨부" />
                      {isEditable && onDeleteImage && img.imgNo && (
                        <button
                          type="button"
                          className="delete-img-btn"
                          onClick={() => {
                            onDeleteImage(img.imgNo, selectedPost.id);
                            setSelectedPost((prev) => ({
                              ...prev,
                              images: (prev.images || []).filter((im) => im.imgNo !== img.imgNo),
                            }));
                          }}
                        >
                          삭제
                        </button>
                      )}
                    </div>
                  );
                })}
              </div>
            ) : (
              <p className="detail-text">첨부된 파일이 없습니다.</p>
            )}
            {isEditable && onUploadImages && (
              <div className="row-inputs">
                <div>
                  <label>첨부 추가</label>
                  <input
                    type="file"
                    multiple
                    accept="image/*"
                    onChange={async (e) => {
                      const files = Array.from(e.target.files || []);
                      if (!files.length) return;
                      if (await onUploadImages(files, selectedPost.id)) {
                        setSelectedPost((prev) => ({
                          ...prev,
                          images: [
                            ...(prev.images || []),
                            ...files.map((f, idx) => ({
                              imgNo: undefined,
                              imgPath: URL.createObjectURL(f),
                              imgOriginalName: f.name,
                            })),
                          ],
                        }));
                      }
                      e.target.value = "";
                    }}
                  />
                </div>
              </div>
            )}

            {isEditable ? (
              <button className="update-btn" onClick={handleUpdate}>
                수정
              </button>
            ) : (
              <button className="delete-btn" onClick={handleDeletePost}>
                삭제
              </button>
            )}
          </div>
          )
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

      {actionModal.open && selectedPost && (
        <div className="modal-overlay">
          <div className="modal delete">
            <div className="modal-header">
              <h3>{actionModal.mode === "update" ? "게시물 수정" : "게시물 삭제"}</h3>
            </div>
            <div className="modal-body">
              {actionModal.status === "confirm"
                ? actionModal.mode === "update"
                  ? "수정하시겠습니까?"
                  : "삭제하시겠습니까?"
                : actionModal.mode === "update"
                ? "수정되었습니다."
                : "삭제되었습니다."}
            </div>
            {actionModal.status === "confirm" ? (
              <div className="modal-footer">
                <button
                  className="confirm-btn"
                  onClick={async () => {
                    try {
                      if (actionModal.mode === "update" && onUpdatePost) {
                        await onUpdatePost(selectedPost);
                      } else if (actionModal.mode === "delete" && onDeletePost) {
                        await onDeletePost(selectedPost.id);
                      }
                      setActionModal((prev) => ({ ...prev, status: "done" }));
                      if (actionModal.mode === "delete") {
                        setPosts((prev) => prev.filter((p) => p.id !== selectedPost.id));
                        setSelectedPost(null);
                      }
                      setTimeout(() => setActionModal({ open: false, mode: null, status: "confirm" }), 1000);
                    } catch {
                      setActionModal({ open: false, mode: null, status: "confirm" });
                    }
                  }}
                >
                  예
                </button>
                <button
                  className="cancel-btn"
                  onClick={() => setActionModal({ open: false, mode: null, status: "confirm" })}
                >
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

export default BoardManager;
