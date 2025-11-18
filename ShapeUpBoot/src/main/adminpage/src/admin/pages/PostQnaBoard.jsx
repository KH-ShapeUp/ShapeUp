import React, { useEffect, useMemo, useRef, useState } from "react";
import Chart from "chart.js/auto";
import "../styles/PostNotice.css";
import { BOARD_STORAGE_KEYS } from "../../common/utils/storageKeys";

const initialPosts = [
  {
    id: 1,
    date: "2025.11.10",
    author: "user21",
    category: "질문",
    title: "유산소 순서가 궁금해요",
    content: "웨이트와 유산소 순서를 어떻게 가져가야 할까요?",
    attachments: ["order.png"],
    status: "대기",
    answer: "",
  },
  {
    id: 2,
    date: "2025.11.11",
    author: "user35",
    category: "건의",
    title: "새 프로그램 요청",
    content: "요가 특화 프로그램을 추가해 주세요.",
    attachments: [],
    status: "완료",
    answer: "요가 강사 배치 후 공지 드리겠습니다.",
  },
  {
    id: 3,
    date: "2025.11.11",
    author: "user18",
    category: "버그",
    title: "결제 화면 이슈",
    content: "모바일 결제 화면에서 버튼이 안 보입니다.",
    attachments: ["error-log.txt"],
    status: "대기",
    answer: "",
  },
  {
    id: 4,
    date: "2025.11.12",
    author: "user09",
    category: "질문",
    title: "PT 결제 내역 확인 부탁",
    content: "지난달 결제 내역이 보이지 않습니다.",
    attachments: [],
    status: "완료",
    answer: "마이페이지에서 다시 확인해 보시고, 안 될 경우 고객센터로 연락 주세요.",
  },
];

const chartLabels = ["11월 1주", "11월 2주", "11월 3주", "11월 4주", "12월 1주"];
const STORAGE_KEY = BOARD_STORAGE_KEYS.QNA;
const isBrowser = typeof window !== "undefined";

const loadStoredQnaPosts = () => {
  const fallback = Array.isArray(initialPosts) ? initialPosts : [];
  if (!isBrowser) return fallback;
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) {
      window.localStorage.setItem(STORAGE_KEY, JSON.stringify(fallback));
      return fallback;
    }
    const parsed = JSON.parse(raw);
    if (Array.isArray(parsed)) return parsed;
  } catch (err) {
    console.warn("Failed to load Q&A posts", err);
  }
  try {
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(fallback));
  } catch {
    /* ignore */
  }
  return fallback;
};

const categoryFilters = ["전체", "질문", "버그", "건의"];

const PostQnaBoard = () => {
  const initialData = useMemo(() => loadStoredQnaPosts(), []);
  const [posts, setPosts] = useState(initialData);
  const [selectedId, setSelectedId] = useState(initialData[0]?.id ?? null);
  const [answerDraft, setAnswerDraft] = useState("");
  const [message, setMessage] = useState("");
  const [sort, setSort] = useState({ key: "id", dir: "asc" });
  const chartRef = useRef(null);
  const [categoryFilter, setCategoryFilter] = useState("전체");

  useEffect(() => {
    if (!isBrowser) return;
    try {
      window.localStorage.setItem(STORAGE_KEY, JSON.stringify(posts));
    } catch (err) {
      console.warn("Failed to save Q&A posts", err);
    }
  }, [posts]);

  const sortPosts = (list) => {
    const collator = new Intl.Collator("ko");
    const getVal = (post) => {
      switch (sort.key) {
        case "id":
          return post.id;
        case "title":
          return post.title ?? "";
        case "author":
          return post.author ?? "";
        case "category":
          return post.category ?? "";
        case "status":
          return post.status ?? "";
        default:
          return post.id;
      }
    };

    return [...list].sort((a, b) => {
      const va = getVal(a);
      const vb = getVal(b);
      let cmp = 0;
      if (sort.key === "id") cmp = va - vb;
      else cmp = collator.compare(String(va), String(vb));
      return sort.dir === "asc" ? cmp : -cmp;
    });
  };

  const filteredByCategory = useMemo(
    () =>
      posts.filter((post) =>
        categoryFilter === "전체" ? true : post.category === categoryFilter
      ),
    [posts, categoryFilter]
  );

  useEffect(() => {
    if (!filteredByCategory.some((post) => post.id === selectedId)) {
      setSelectedId(filteredByCategory[0]?.id ?? null);
    }
  }, [filteredByCategory, selectedId]);

  const pendingPosts = useMemo(
    () => sortPosts(filteredByCategory.filter((p) => p.status !== "완료")),
    [filteredByCategory, sort]
  );
  const answeredPosts = useMemo(
    () => sortPosts(filteredByCategory.filter((p) => p.status === "완료")),
    [filteredByCategory, sort]
  );

  const toggleSort = (key) => {
    setSort((prev) =>
      prev.key === key ? { key, dir: prev.dir === "asc" ? "desc" : "asc" } : { key, dir: "asc" }
    );
  };

  const sortArrow = (key) => (sort.key === key ? (sort.dir === "asc" ? " ▲" : " ▼") : "");

  const selectedPost = posts.find((p) => p.id === selectedId) || null;

  useEffect(() => {
    setAnswerDraft(selectedPost?.answer ?? "");
    setMessage("");
  }, [selectedPost]);

  const chartData = useMemo(() => {
    const counts = [5, 7, 4, answeredPosts.length, pendingPosts.length];
    return counts;
  }, [answeredPosts.length, pendingPosts.length]);

  useEffect(() => {
    if (!chartRef.current) return;
    const ctx = chartRef.current.getContext("2d");
    const chartInstance = new Chart(ctx, {
      type: "line",
      data: {
        labels: chartLabels,
        datasets: [
          {
            label: "문의 처리 추이",
            data: chartData,
            borderColor: "#4c8bf5",
            borderWidth: 2,
            fill: false,
          },
        ],
      },
      options: { responsive: true, maintainAspectRatio: false },
    });
    return () => chartInstance.destroy();
  }, [chartData]);

  const selectPost = (id) => setSelectedId(id);

  const handleAnswer = () => {
    if (!selectedPost) return;
    if (!answerDraft.trim()) {
      setMessage("답변 내용을 입력하세요.");
      return;
    }

    setPosts((prev) =>
      prev.map((post) =>
        post.id === selectedPost.id
          ? { ...post, answer: answerDraft, status: "완료" }
          : post
      )
    );
    setMessage(selectedPost.status === "완료" ? "답변이 수정되었습니다." : "답변되었습니다.");
    setTimeout(() => setMessage(""), 1500);
  };

  const buttonLabel = selectedPost?.status === "완료" ? "답변 수정" : "답변하기";

  return (
    <div className="posts-container qna-board">
      <div className="qna-filter-group">
        {categoryFilters.map((label) => (
          <button
            key={label}
            type="button"
            className={categoryFilter === label ? "active" : ""}
            onClick={() => setCategoryFilter(label)}
          >
            {label}
          </button>
        ))}
      </div>
      <div className="posts-list">
        <div className="qna-block">
          <div className="qna-block-header">대기 중 질문 / 건의</div>
          <table className="posts-table">
            <thead>
              <tr>
                <th className="sortable" onClick={() => toggleSort("id")}>
                  번호{sortArrow("id")}
                </th>
                <th className="sortable" onClick={() => toggleSort("title")}>
                  제목{sortArrow("title")}
                </th>
                <th className="sortable" onClick={() => toggleSort("author")}>
                  작성자{sortArrow("author")}
                </th>
                <th className="sortable" onClick={() => toggleSort("category")}>
                  카테고리{sortArrow("category")}
                </th>
                <th className="sortable" onClick={() => toggleSort("status")}>
                  상태{sortArrow("status")}
                </th>
              </tr>
            </thead>
            <tbody>
              {pendingPosts.map((post) => (
                <tr
                  key={post.id}
                  className={post.id === selectedId ? "active" : ""}
                  onClick={() => selectPost(post.id)}
                >
                  <td>{post.id}</td>
                  <td>{post.title}</td>
                  <td>{post.author}</td>
                  <td>{post.category}</td>
                  <td><span className="qna-status waiting">대기</span></td>
                </tr>
              ))}
              {pendingPosts.length === 0 && (
                <tr>
                  <td colSpan={5} className="empty-row">대기 중인 문의가 없습니다.</td>
                </tr>
              )}
            </tbody>
          </table>
        </div>

        <div className="qna-block">
          <div className="qna-block-header">답변된 질문 / 건의</div>
          <table className="posts-table">
            <thead>
              <tr>
                <th className="sortable" onClick={() => toggleSort("id")}>
                  번호{sortArrow("id")}
                </th>
                <th className="sortable" onClick={() => toggleSort("title")}>
                  제목{sortArrow("title")}
                </th>
                <th className="sortable" onClick={() => toggleSort("author")}>
                  작성자{sortArrow("author")}
                </th>
                <th className="sortable" onClick={() => toggleSort("category")}>
                  카테고리{sortArrow("category")}
                </th>
                <th className="sortable" onClick={() => toggleSort("status")}>
                  상태{sortArrow("status")}
                </th>
              </tr>
            </thead>
            <tbody>
              {answeredPosts.map((post) => (
                <tr
                  key={post.id}
                  className={post.id === selectedId ? "active" : ""}
                  onClick={() => selectPost(post.id)}
                >
                  <td>{post.id}</td>
                  <td>{post.title}</td>
                  <td>{post.author}</td>
                  <td>{post.category}</td>
                  <td><span className="qna-status done">완료</span></td>
                </tr>
              ))}
              {answeredPosts.length === 0 && (
                <tr>
                  <td colSpan={5} className="empty-row">답변된 문의가 없습니다.</td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      <div className="posts-detail">
        <div className="detail-header">질문 / 건의 상세</div>
        {selectedPost ? (
          <div className="detail-body">
            <label>제목</label>
            <p className="detail-text">{selectedPost.title}</p>

            <div className="row-inputs">
              <div>
                <label>작성자</label>
                <p className="detail-text">{selectedPost.author}</p>
              </div>
              <div>
                <label>카테고리</label>
                <p className="detail-text">{selectedPost.category}</p>
              </div>
              <div>
                <label>등록일</label>
                <p className="detail-text">{selectedPost.date}</p>
              </div>
              <div>
                <label>상태</label>
                <p className="detail-text">{selectedPost.status}</p>
              </div>
            </div>

            <label>내용</label>
            <div className="detail-content-block">{selectedPost.content}</div>

            <label>첨부파일</label>
            {selectedPost.attachments?.length ? (
              <ul className="attachments-list">
                {selectedPost.attachments.map((file) => (
                  <li key={file}>
                    <span className="attachment-icon">📎</span>
                    {file}
                  </li>
                ))}
              </ul>
            ) : (
              <p className="detail-text">첨부된 파일이 없습니다.</p>
            )}

            <label>답변</label>
            <textarea
              placeholder="답변 내용을 입력하세요"
              value={answerDraft}
              onChange={(e) => setAnswerDraft(e.target.value)}
            />
            {message && <p className="answer-message">{message}</p>}
            <button className="update-btn" onClick={handleAnswer}>
              {buttonLabel}
            </button>
          </div>
        ) : (
          <p className="empty">문의 항목을 선택하세요.</p>
        )}
      </div>

      <div className="posts-chart">
        <div className="chart-header">질문 / 건의 처리 추이</div>
        <div className="chart-area">
          <canvas ref={chartRef}></canvas>
        </div>
      </div>
    </div>
  );
};

export default PostQnaBoard;
