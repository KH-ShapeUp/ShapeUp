import React, { useEffect, useMemo, useState } from "react";
import "../styles/StadiumMemo.css";
import { useFacilityData } from "../context/FacilityDataContext";
import {
  STADIUM_MEMO_STORAGE_KEY,
  STORAGE_EVENTS,
} from "../../common/utils/storageKeys";
import CustomSelect from "../../common/components/CustomSelect";

const isBrowser = typeof window !== "undefined";

const readStorage = () => {
  if (!isBrowser) return [];
  try {
    const raw = window.localStorage.getItem(STADIUM_MEMO_STORAGE_KEY);
    if (!raw) return [];
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : [];
  } catch (err) {
    console.warn("Failed to read memos", err);
    return [];
  }
};

const writeStorage = (data) => {
  if (!isBrowser) return;
  try {
    window.localStorage.setItem(STADIUM_MEMO_STORAGE_KEY, JSON.stringify(data));
    window.dispatchEvent(new Event(STORAGE_EVENTS.STADIUM_MEMOS));
  } catch (err) {
    console.warn("Failed to write memos", err);
  }
};

const StadiumMemo = () => {
  const { facilities } = useFacilityData();
  const [memos, setMemos] = useState(() => readStorage());
  const [facilityInput, setFacilityInput] = useState("시설 1");
  const [content, setContent] = useState("");
  const [filter, setFilter] = useState("전체");
  const [feedback, setFeedback] = useState("");

  const facilityOptions = useMemo(() => {
    if (!facilities.length) return ["시설 1", "시설 2", "시설 3"];
    return facilities;
  }, [facilities]);
  const memoFilterOptions = useMemo(
    () => ["전체", ...facilityOptions],
    [facilityOptions]
  );

  useEffect(() => {
    if (!isBrowser) return;
    const sync = () => setMemos(readStorage());
    const storageHandler = (event) => {
      if (event.key && event.key !== STADIUM_MEMO_STORAGE_KEY) return;
      sync();
    };
    sync();
    window.addEventListener("storage", storageHandler);
    window.addEventListener(STORAGE_EVENTS.STADIUM_MEMOS, sync);
    return () => {
      window.removeEventListener("storage", storageHandler);
      window.removeEventListener(STORAGE_EVENTS.STADIUM_MEMOS, sync);
    };
  }, []);

  useEffect(() => {
    if (!feedback) return;
    const timer = setTimeout(() => setFeedback(""), 1500);
    return () => clearTimeout(timer);
  }, [feedback]);

  const saveMemos = (updateFn) => {
    setMemos((prev) => {
      const next = updateFn(prev);
      writeStorage(next);
      return next;
    });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    const text = content.trim();
    if (!text) {
      setFeedback("메모 내용을 입력하세요.");
      return;
    }
    const now = new Date();
    const newMemo = {
      id: now.getTime(),
      facility: facilityInput,
      content: text,
      date: now.toLocaleString("ko-KR", {
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit",
      }),
    };
    saveMemos((prev) => [newMemo, ...prev]);
    setContent("");
    setFeedback("메모가 저장되었습니다.");
  };

  const deleteMemo = (id) => {
    saveMemos((prev) => prev.filter((memo) => memo.id !== id));
  };

  const filteredMemos = memos.filter((memo) =>
    filter === "전체" ? true : memo.facility === filter
  );

  return (
    <div className="memo-page">
      <header className="memo-header">
        <div>
          <h2>시설 팀 메모</h2>
          <p>시설 별 메모를 작성하고 공유하세요.</p>
        </div>
        <div className="memo-filter">
          <label>확인 범위</label>
          <CustomSelect
            size="sm"
            value={filter}
            options={memoFilterOptions}
            onChange={setFilter}
          />
        </div>
      </header>

      <section className="memo-grid">
        <article className="memo-card memo-form-card">
          <h3>메모 작성</h3>
          <form onSubmit={handleSubmit}>
            <label>대상 시설</label>
            <CustomSelect
              value={facilityInput}
              options={facilityOptions}
              onChange={setFacilityInput}
            />

            <label>메모 내용</label>
            <textarea
              value={content}
              onChange={(e) => setContent(e.target.value)}
              placeholder="메모를 입력하세요."
            />

            {feedback && <p className="memo-feedback">{feedback}</p>}

            <button type="submit">메모 저장</button>
          </form>
        </article>

        <article className="memo-card memo-list-card">
          <div className="memo-list-header">
            <h3>메모 목록</h3>
            <span>
              {filter} · {filteredMemos.length}건
            </span>
          </div>
          <ul className="memo-list">
            {filteredMemos.map((memo) => (
              <li key={memo.id}>
                <div className="memo-meta">
                  <strong>{memo.facility}</strong>
                  <span>{memo.date}</span>
                </div>
                <p>{memo.content}</p>
                <button type="button" onClick={() => deleteMemo(memo.id)}>
                  삭제
                </button>
              </li>
            ))}
            {!filteredMemos.length && (
              <p className="empty">선택한 시설에 등록된 메모가 없습니다.</p>
            )}
          </ul>
        </article>
      </section>
    </div>
  );
};

export default StadiumMemo;
