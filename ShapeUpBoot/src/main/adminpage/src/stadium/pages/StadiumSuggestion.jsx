import React, { useEffect, useMemo, useRef, useState } from "react";
import Chart from "chart.js/auto";
import "../styles/StadiumSuggestion.css";
import "../../admin/styles/PostNotice.css";
import { useFacilityData } from "../context/FacilityDataContext";
import { appendInboxMessage } from "../../common/utils/messageUtils";
import { STADIUM_SUGGESTION_STORAGE_KEY } from "../../common/utils/storageKeys";

const initialSuggestions = [
  {
    id: 1,
    facility: "시설 1",
    date: "2025.12.10",
    member: "lee_gym",
    title: "러닝머신 추가 도입 요청",
    content: "출근 시간대에 대기 줄이 너무 길어서 장비를 더 늘려 주세요.",
    attachments: ["treadmill_waiting.png"],
    status: "대기",
    answer: "",
    mailNotified: false,
  },
  {
    id: 2,
    facility: "시설 2",
    date: "2025.12.11",
    member: "park_hi",
    title: "요가 매트 교체 필요",
    content: "몇몇 매트가 오래되어 미끄러워요. 교체가 필요합니다.",
    attachments: [],
    status: "완료",
    answer: "다음 주에 전체 교체 예정이며 안내 드리겠습니다.",
    mailNotified: false,
  },
  {
    id: 3,
    facility: "시설 3",
    date: "2025.12.12",
    member: "kim_ho",
    title: "사물함 잠금장치 개선",
    content: "사물함 잠금장치가 잘 풀려서 개선이 필요합니다.",
    attachments: ["locker_video.mp4"],
    status: "대기",
    answer: "",
    mailNotified: false,
  },
  {
    id: 4,
    facility: "시설 1",
    date: "2025.12.13",
    member: "song_pt",
    title: "주말 PT 슬롯 확대",
    content: "토요일 오후에도 PT를 받을 수 있게 해주세요.",
    attachments: [],
    status: "완료",
    answer: "강사 스케줄 조정 후 주말 오후 세션을 열 예정입니다.",
    mailNotified: false,
  },
];

const chartLabels = ["대기", "완료"];
const isBrowser = typeof window !== "undefined";

const loadSuggestions = () => {
  if (!isBrowser) return initialSuggestions;
  try {
    const raw = window.localStorage.getItem(STADIUM_SUGGESTION_STORAGE_KEY);
    if (!raw) {
      window.localStorage.setItem(STADIUM_SUGGESTION_STORAGE_KEY, JSON.stringify(initialSuggestions));
      return initialSuggestions;
    }
    const parsed = JSON.parse(raw);
    if (Array.isArray(parsed)) return parsed;
  } catch (err) {
    console.warn("Failed to load suggestions", err);
  }
  return initialSuggestions;
};

const persistSuggestions = (data) => {
  if (!isBrowser) return;
  window.localStorage.setItem(STADIUM_SUGGESTION_STORAGE_KEY, JSON.stringify(data));
};

const StadiumSuggestion = () => {
  const { facilities } = useFacilityData();
  const initialData = useMemo(() => loadSuggestions(), []);
  const [suggestions, setSuggestions] = useState(initialData);
  const [selectedFacility, setSelectedFacility] = useState("전체");
  const [selectedId, setSelectedId] = useState(initialData[0]?.id ?? null);
  const [answerDraft, setAnswerDraft] = useState("");
  const [message, setMessage] = useState("");
  const [sort, setSort] = useState({ key: "id", dir: "asc" });
  const chartRef = useRef(null);

  const facilityFilters = ["전체", "시설 1", "시설 2", "시설 3"];
  const facilityOptions = useMemo(() => {
    const names = new Set([...facilities, ...suggestions.map((s) => s.facility)]);
    return ["전체", ...Array.from(names)];
  }, [facilities, suggestions]);

  useEffect(() => {
    if (!facilityOptions.includes(selectedFacility)) {
      setSelectedFacility("전체");
    }
  }, [facilityOptions, selectedFacility]);

  useEffect(() => {
    persistSuggestions(suggestions);
  }, [suggestions]);

  const filteredSuggestions = useMemo(() => {
    return suggestions.filter(
      (item) => selectedFacility === "전체" || item.facility === selectedFacility
    );
  }, [suggestions, selectedFacility]);

  useEffect(() => {
    if (!filteredSuggestions.some((item) => item.id === selectedId)) {
      setSelectedId(filteredSuggestions[0]?.id ?? null);
    }
  }, [filteredSuggestions, selectedId]);

  const sortList = (list) => {
    const collator = new Intl.Collator("ko");
    const getVal = (item) => {
      switch (sort.key) {
        case "id":
          return item.id;
        case "title":
          return item.title ?? "";
        case "member":
          return item.member ?? "";
        case "facility":
          return item.facility ?? "";
        case "status":
          return item.status ?? "";
        default:
          return item.id;
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

  const pendingList = useMemo(
    () => sortList(filteredSuggestions.filter((item) => item.status !== "완료")),
    [filteredSuggestions, sort]
  );

  const answeredList = useMemo(
    () => sortList(filteredSuggestions.filter((item) => item.status === "완료")),
    [filteredSuggestions, sort]
  );

  const toggleSort = (key) => {
    setSort((prev) =>
      prev.key === key ? { key, dir: prev.dir === "asc" ? "desc" : "asc" } : { key, dir: "asc" }
    );
  };

  const sortArrow = (key) => (sort.key === key ? (sort.dir === "asc" ? " ▲" : " ▼") : "");

  const selectedItem = suggestions.find((s) => s.id === selectedId) ?? null;

  useEffect(() => {
    setAnswerDraft(selectedItem?.answer ?? "");
    setMessage("");
  }, [selectedItem]);

  useEffect(() => {
    if (!chartRef.current) return;
    const ctx = chartRef.current.getContext("2d");
    const dataPoints = [
      pendingList.length,
      answeredList.length,
    ];
    const chartInstance = new Chart(ctx, {
      type: "line",
      data: {
        labels: chartLabels,
        datasets: [
          {
            label: "건의 처리 현황",
            data: dataPoints,
            borderColor: "#4c8bf5",
            borderWidth: 2,
            fill: false,
          },
        ],
      },
      options: { responsive: true, maintainAspectRatio: false },
    });
    return () => chartInstance.destroy();
  }, [pendingList.length, answeredList.length]);

  useEffect(() => {
    let needsUpdate = false;
    const nextSuggestions = suggestions.map((item) => {
      if (!item.mailNotified) {
        appendInboxMessage({
          sender: "건의 사항",
          subject: `[건의] ${item.title}`,
          preview: `${item.member} · ${item.facility}`,
          body: item.content,
          category: "건의 사항",
          metadata: { facility: item.facility, member: item.member },
        });
        needsUpdate = true;
        return { ...item, mailNotified: true };
      }
      return item;
    });
    if (needsUpdate) {
      setSuggestions(nextSuggestions);
    }
  }, [suggestions]);

  const handleAnswer = () => {
    if (!selectedItem) return;
    if (!answerDraft.trim()) {
      setMessage("답변 내용을 입력하세요.");
      return;
    }

    setSuggestions((prev) =>
      prev.map((item) =>
        item.id === selectedItem.id
          ? { ...item, answer: answerDraft, status: "완료" }
          : item
      )
    );
    setMessage(selectedItem.status === "완료" ? "답변이 수정되었습니다." : "답변되었습니다.");
    setTimeout(() => setMessage(""), 1500);
  };

  const buttonLabel = selectedItem?.status === "완료" ? "답변 수정" : "답변하기";

  return (
    <div className="posts-container qna-board stadium-qna-board">
      <div className="posts-list">
        <div className="suggestion-filter-bar">
          <span className="filter-label">시설 필터</span>
          <div className="facility-filter-group">
            {facilityFilters.map((label) => (
              <button
                type="button"
                key={label}
                className={selectedFacility === label ? "active" : ""}
                onClick={() => setSelectedFacility(label)}
              >
                {label}
              </button>
            ))}
          </div>
        </div>
        <div className="qna-block">
          <div className="qna-block-header">대기 중 건의 사항</div>
          <table className="posts-table">
            <thead>
              <tr>
                <th className="sortable" onClick={() => toggleSort("id")}>
                  번호{sortArrow("id")}
                </th>
                <th className="sortable" onClick={() => toggleSort("title")}>
                  제목{sortArrow("title")}
                </th>
                <th className="sortable" onClick={() => toggleSort("member")}>
                  회원{sortArrow("member")}
                </th>
                <th className="sortable" onClick={() => toggleSort("facility")}>
                  시설{sortArrow("facility")}
                </th>
                <th className="sortable" onClick={() => toggleSort("status")}>
                  상태{sortArrow("status")}
                </th>
              </tr>
            </thead>
            <tbody>
              {pendingList.map((item) => (
                <tr
                  key={item.id}
                  className={item.id === selectedId ? "active" : ""}
                  onClick={() => setSelectedId(item.id)}
                >
                  <td>{item.id}</td>
                  <td>{item.title}</td>
                  <td>{item.member}</td>
                  <td>{item.facility}</td>
                  <td>
                    <span className="qna-status waiting">대기</span>
                  </td>
                </tr>
              ))}
              {!pendingList.length && (
                <tr>
                  <td colSpan={5} className="empty-row">
                    선택한 시설에 대기 중인 건의가 없습니다.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>

        <div className="qna-block">
          <div className="qna-block-header">답변된 건의 사항</div>
          <table className="posts-table">
            <thead>
              <tr>
                <th className="sortable" onClick={() => toggleSort("id")}>
                  번호{sortArrow("id")}
                </th>
                <th className="sortable" onClick={() => toggleSort("title")}>
                  제목{sortArrow("title")}
                </th>
                <th className="sortable" onClick={() => toggleSort("member")}>
                  회원{sortArrow("member")}
                </th>
                <th className="sortable" onClick={() => toggleSort("facility")}>
                  시설{sortArrow("facility")}
                </th>
                <th className="sortable" onClick={() => toggleSort("status")}>
                  상태{sortArrow("status")}
                </th>
              </tr>
            </thead>
            <tbody>
              {answeredList.map((item) => (
                <tr
                  key={item.id}
                  className={item.id === selectedId ? "active" : ""}
                  onClick={() => setSelectedId(item.id)}
                >
                  <td>{item.id}</td>
                  <td>{item.title}</td>
                  <td>{item.member}</td>
                  <td>{item.facility}</td>
                  <td>
                    <span className="qna-status done">완료</span>
                  </td>
                </tr>
              ))}
              {!answeredList.length && (
                <tr>
                  <td colSpan={5} className="empty-row">
                    선택한 시설에 답변된 건의가 없습니다.
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      </div>

      <div className="posts-detail">
        <div className="detail-header">건의 상세</div>
        {selectedItem ? (
          <div className="detail-body">
            <label>제목</label>
            <p className="detail-text">{selectedItem.title}</p>

            <div className="row-inputs">
              <div>
                <label>회원</label>
                <p className="detail-text">{selectedItem.member}</p>
              </div>
              <div>
                <label>시설</label>
                <p className="detail-text">{selectedItem.facility}</p>
              </div>
              <div>
                <label>등록일</label>
                <p className="detail-text">{selectedItem.date}</p>
              </div>
              <div>
                <label>상태</label>
                <p className="detail-text">{selectedItem.status}</p>
              </div>
            </div>

            <label>내용</label>
            <div className="detail-content-block">{selectedItem.content}</div>

            <label>첨부파일</label>
            {selectedItem.attachments?.length ? (
              <ul className="attachments-list">
                {selectedItem.attachments.map((file) => (
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
        <div className="chart-header">시설별 건의 처리 추이</div>
        <div className="chart-area">
          <canvas ref={chartRef}></canvas>
        </div>
      </div>
    </div>
  );
};

export default StadiumSuggestion;
