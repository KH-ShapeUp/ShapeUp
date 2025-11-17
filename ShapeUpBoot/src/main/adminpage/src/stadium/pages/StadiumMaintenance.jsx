import React, { useEffect, useMemo, useState } from "react";
import "../styles/StadiumAlerts.css";
import { STADIUM_MAINTENANCE_STORAGE_KEY } from "../../common/utils/storageKeys";
import { appendInboxMessage } from "../../common/utils/messageUtils";

const seedTasks = [
  {
    id: 1,
    title: "트레드밀 점검",
    facility: "헬스장",
    due: "11.15",
    priority: "high",
    status: "대기",
    mailNotified: false,
  },
  {
    id: 2,
    title: "샤워실 배수 청소",
    facility: "공용",
    due: "11.16",
    priority: "medium",
    status: "진행중",
    mailNotified: false,
  },
  {
    id: 3,
    title: "풋살장 조명 교체",
    facility: "풋살장",
    due: "11.18",
    priority: "low",
    status: "대기",
    mailNotified: false,
  },
];

const statusOptions = ["대기", "진행중", "완료"];
const priorityOptions = ["high", "medium", "low"];
const isBrowser = typeof window !== "undefined";

const loadTasks = () => {
  if (!isBrowser) return seedTasks;
  try {
    const raw = window.localStorage.getItem(STADIUM_MAINTENANCE_STORAGE_KEY);
    if (!raw) {
      window.localStorage.setItem(STADIUM_MAINTENANCE_STORAGE_KEY, JSON.stringify(seedTasks));
      return seedTasks;
    }
    const parsed = JSON.parse(raw);
    if (Array.isArray(parsed)) return parsed;
  } catch (err) {
    console.warn("Failed to load maintenance tasks", err);
  }
  return seedTasks;
};

const persistTasks = (tasks) => {
  if (!isBrowser) return;
  window.localStorage.setItem(STADIUM_MAINTENANCE_STORAGE_KEY, JSON.stringify(tasks));
};

const parseDue = (due) => {
  if (!due) return null;
  const cleaned = due.replace(/[^\d.]/g, ".");
  const parts = cleaned.split(".").filter(Boolean);
  if (!parts.length) return null;
  let year;
  let month;
  let day;
  if (parts.length === 3) {
    [year, month, day] = parts.map(Number);
  } else if (parts.length === 2) {
    const now = new Date();
    [month, day] = parts.map(Number);
    year = now.getFullYear();
  } else {
    return null;
  }
  const candidate = new Date(year, (month ?? 1) - 1, day ?? 1);
  if (Number.isNaN(candidate.getTime())) return null;
  return candidate;
};

const StadiumMaintenance = () => {
  const [tasks, setTasks] = useState(() => loadTasks());
  const [filter, setFilter] = useState("전체");
  const [form, setForm] = useState({ title: "", facility: "", due: "", priority: "medium" });

  useEffect(() => {
    persistTasks(tasks);
  }, [tasks]);

  const filteredTasks = useMemo(() => {
    if (filter === "전체") return tasks;
    return tasks.filter((task) => task.status === filter);
  }, [tasks, filter]);

  const addTask = () => {
    if (!form.title.trim()) return;
    setTasks((prev) => [
      {
        id: Date.now(),
        title: form.title.trim(),
        facility: form.facility.trim() || "미지정",
        due: form.due.trim() || "미정",
        priority: form.priority,
        status: "대기",
        mailNotified: false,
      },
      ...prev,
    ]);
    setForm({ title: "", facility: "", due: "", priority: "medium" });
  };

  const updateStatus = (id, status) => {
    setTasks((prev) => prev.map((task) => (task.id === id ? { ...task, status } : task)));
  };

  useEffect(() => {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    let updated = false;
    const nextTasks = tasks.map((task) => {
      if (task.mailNotified || task.status === "완료") return task;
      const dueDate = parseDue(task.due);
      if (!dueDate) return task;
      const diffDays = Math.floor((dueDate.getTime() - today.getTime()) / (1000 * 60 * 60 * 24));
      if (diffDays >= 0 && diffDays <= 3) {
        appendInboxMessage({
          sender: "시스템",
          subject: `[점검 예정] ${task.title}`,
          preview: `${task.facility} · ${task.due} 예정`,
          body: `${task.facility} 시설 점검 일정이 ${diffDays}일 남았습니다.`,
          category: "시설 점검",
          metadata: { facility: task.facility, due: task.due },
        });
        updated = true;
        return { ...task, mailNotified: true };
      }
      return task;
    });
    if (updated) {
      setTasks(nextTasks);
    }
  }, [tasks]);

  return (
    <div className="stadium-alerts-page">
      <header className="alerts-header">
        <div>
          <h2>시설 점검 일정</h2>
          <p>점검 / 청소 / 교체와 같은 작업 일정을 관리하세요.</p>
        </div>
        <select value={filter} onChange={(e) => setFilter(e.target.value)}>
          <option value="전체">전체</option>
          {statusOptions.map((status) => (
            <option key={status} value={status}>
              {status}
            </option>
          ))}
        </select>
      </header>

      <section className="alerts-grid">
        <article className="alerts-card">
          <h3>새 일정 추가</h3>
          <div className="alerts-form">
            <input
              type="text"
              placeholder="작업명"
              value={form.title}
              onChange={(e) => setForm((prev) => ({ ...prev, title: e.target.value }))}
            />
            <input
              type="text"
              placeholder="시설"
              value={form.facility}
              onChange={(e) => setForm((prev) => ({ ...prev, facility: e.target.value }))}
            />
            <input
              type="text"
              placeholder="예: 11.20"
              value={form.due}
              onChange={(e) => setForm((prev) => ({ ...prev, due: e.target.value }))}
            />
            <select
              value={form.priority}
              onChange={(e) => setForm((prev) => ({ ...prev, priority: e.target.value }))}
            >
              {priorityOptions.map((level) => (
                <option key={level} value={level}>
                  우선순위: {level}
                </option>
              ))}
            </select>
            <button type="button" onClick={addTask}>
              일정 저장
            </button>
          </div>
        </article>

        <article className="alerts-card">
          <h3>일정 목록 ({filteredTasks.length}건)</h3>
          <ul className="maintenance-list">
            {filteredTasks.map((task) => (
              <li key={task.id} className={`priority-${task.priority}`}>
                <div>
                  <strong>{task.title}</strong>
                  <span>{task.facility}</span>
                  <small>예정일: {task.due}</small>
                </div>
                <select value={task.status} onChange={(e) => updateStatus(task.id, e.target.value)}>
                  {statusOptions.map((status) => (
                    <option key={status} value={status}>
                      {status}
                    </option>
                  ))}
                </select>
              </li>
            ))}
          </ul>
          {!filteredTasks.length && <p className="empty">조건에 맞는 일정이 없습니다.</p>}
        </article>
      </section>
    </div>
  );
};

export default StadiumMaintenance;
