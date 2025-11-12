import React, { useEffect, useMemo, useRef, useState } from "react";
import Chart from "chart.js/auto";
import "../styles/PostNotice.css";

const PostsNotice = () => {
  const [posts, setPosts] = useState([
    { id: 1, date: "2025.12.12", author: "관리자", category: "공지", title: "서비스 점검 안내" },
    { id: 2, date: "2025.12.13", author: "관리자", category: "업데이트", title: "신규 기능 추가" },
    { id: 3, date: "2025.12.14", author: "운영팀", category: "공지", title: "회원 정책 변경" },
    { id: 4, author: "마케팅팀", category: "이벤트", title: "겨울 맞이 이벤트", startDate: "2025.12.20", endDate: "2026.01.05" },
    { id: 5, author: "운영팀", category: "이벤트", title: "새해 복권 이벤트", startDate: "2026.01.10", endDate: "2026.01.31" },
  ]);

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

  const getSortDateValue = (post) => (post.category === "이벤트" ? post.startDate ?? post.date ?? "" : post.date ?? "");

  useEffect(() => {
    const ctx = chartRef.current.getContext("2d");
    const chartInstance = new Chart(ctx, {
      type: "bar",
      data: {
        labels: ["11월 1주", "11월 2주", "11월 3주", "11월 4주", "12월 1주"],
        datasets: [
          {
            label: "등록 게시물 수",
            data: [5, 9, 3, 7, 6],
            backgroundColor: "#007bff",
          },
        ],
      },
      options: { responsive: true, maintainAspectRatio: false },
    });
    return () => chartInstance.destroy();
  }, []);

  const handleSelectPost = (post) => setSelectedPost(post);
  const handleChange = (e) => setSelectedPost({ ...selectedPost, [e.target.name]: e.target.value });
  const handleUpdate = () => {
    if (!selectedPost) return;
    setPosts((prev) => prev.map((p) => (p.id === selectedPost.id ? selectedPost : p)));
    alert("게시물 수정 완료");
  };

  const toggleSort = (key) => {
    setSort((prev) => (prev.key === key ? { key, dir: prev.dir === "asc" ? "desc" : "asc" } : { key, dir: "asc" }));
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
        case "id": return post.id;
        case "date": return normalizeDate(getSortDateValue(post));
        case "author": return post.author ?? "";
        case "category": return post.category ?? "";
        case "title": return post.title ?? "";
        default: return "";
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
        case "날짜": return dateVal.includes(query);
        case "제목": return titleVal.includes(query);
        case "작성자": return authorVal.includes(query);
        default: return dateVal.includes(query) || titleVal.includes(query) || authorVal.includes(query);
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

  return (
    <div className="posts-container">
      <div className="posts-list">
        <div className="posts-header">
          <span>게시된 게시물 <em className="count-label">(총 게시글 개수 : {totalPosts.toLocaleString()}건)</em></span>
          <div className="search-stack">
            <div className="search-bar">
              <select value={categoryFilter} onChange={(e) => setCategoryFilter(e.target.value)}>
                <option value="전체">전체</option>
                <option value="공지">공지</option>
                <option value="업데이트">업데이트</option>
                <option value="이벤트">이벤트</option>
              </select>
              <input type="text" placeholder="제목을 입력하세요" value={titleQuery} onChange={(e) => setTitleQuery(e.target.value)} />
              <select className="page-size-select" value={pageSize} onChange={(e) => setPageSize(Number(e.target.value))}>
                {[5, 10, 30, 50].map((size) => (
                  <option key={size} value={size}>{size}개</option>
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
              <input type="text" placeholder="추가 검색어 입력" value={advancedQuery} onChange={(e) => setAdvancedQuery(e.target.value)} />
            </div>
          </div>
        </div>

        <table className="posts-table">
          <thead>
            <tr>
              <th onClick={() => toggleSort("id")} style={{ cursor: "pointer" }}>번호{sortMark("id")}</th>
              <th onClick={() => toggleSort("date")} style={{ cursor: "pointer" }}>날짜{sortMark("date")}</th>
              <th onClick={() => toggleSort("author")} style={{ cursor: "pointer" }}>작성자{sortMark("author")}</th>
              <th onClick={() => toggleSort("category")} style={{ cursor: "pointer" }}>카테고리{sortMark("category")}</th>
              <th onClick={() => toggleSort("title")} style={{ cursor: "pointer" }}>제목{sortMark("title")}</th>
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
                <td><button className="move-btn">보기</button></td>
              </tr>
            ))}
          </tbody>
        </table>

        <div className="pagination-controls">
          <button type="button" onClick={() => setPage((prev) => Math.max(1, prev - 1))} disabled={currentPage === 1}>&lt;</button>
          <span className="pagination-status">{currentPage}/{totalPages}</span>
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
          <button type="button" onClick={() => setPage((prev) => Math.min(totalPages, prev + 1))} disabled={currentPage === totalPages}>&gt;</button>
        </div>
      </div>

      <div className="posts-detail">
        <div className="detail-header">게시물 상태 수정</div>
        {selectedPost ? (
          <div className="detail-body">
            <label>게시글 번호</label>
            <input type="text" value={selectedPost.id} disabled />

            <label>제목</label>
            <input type="text" name="title" value={selectedPost.title} onChange={handleChange} />

            <div className="row-inputs">
              {selectedPost.category === "이벤트" ? (
                <>
                  <div>
                    <label>시작일</label>
                    <input type="text" name="startDate" placeholder="YYYY.MM.DD" value={selectedPost.startDate || ""} onChange={handleChange} />
                  </div>
                  <div>
                    <label>종료일</label>
                    <input type="text" name="endDate" placeholder="YYYY.MM.DD" value={selectedPost.endDate || ""} onChange={handleChange} />
                  </div>
                </>
              ) : (
                <div>
                  <label>날짜</label>
                  <input type="text" value={selectedPost.date} disabled />
                </div>
              )}
              <div>
                <label>작성자</label>
                <input type="text" value={selectedPost.author} disabled />
              </div>
            </div>

            <label>내용</label>
            <textarea name="content" placeholder="내용을 입력하세요" value={selectedPost.content || ""} onChange={handleChange} />

            <label>첨부파일</label>
            <input type="file" />

            <button className="update-btn" onClick={handleUpdate}>수정</button>
          </div>
        ) : (
          <p className="empty">게시물을 선택하세요.</p>
        )}
      </div>

      <div className="posts-chart">
        <div className="chart-header">게시물 등록 그래프</div>
        <div className="chart-area">
          <canvas ref={chartRef}></canvas>
        </div>
      </div>
    </div>
  );
};

export default PostsNotice;
