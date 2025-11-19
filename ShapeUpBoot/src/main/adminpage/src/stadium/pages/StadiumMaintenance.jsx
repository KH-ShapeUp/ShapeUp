import React, { useEffect, useMemo, useState } from "react";
import "../styles/StadiumAlerts.css";
import {
  STADIUM_MAINTENANCE_STORAGE_KEY,
  STORAGE_EVENTS,
} from "../../common/utils/storageKeys";
import { appendInboxMessage } from "../../common/utils/messageUtils";
import {
  loadMaintenanceTasks,
  saveMaintenanceTasks,
} from "../utils/maintenanceStorage";
import CustomSelect from "../../common/components/CustomSelect";

const statusOptions = ["대기", "진행중", "완료"];
const priorityOptions = ["high", "medium", "low"];
const isBrowser = typeof window !== "undefined";

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
  const [tasks, setTasks] = useState(() => loadMaintenanceTasks());
  const [filter, setFilter] = useState("전체");
  const [form, setForm] = useState({ title: "", facility: "", due: "", priority: "medium" });
  const filterOptions = useMemo(() => ["전체", ...statusOptions], []);
  const prioritySelectOptions = useMemo(
    () => priorityOptions.map((level) => ({ value: level, label: `우선순위: ${level}` })),
    []
  );
  const statusSelectOptions = useMemo(
    () => statusOptions.map((status) => ({ value: status, label: status })),
    []
  );

  useEffect(() => {
    if (!isBrowser) return;
    const sync = () => setTasks(loadMaintenanceTasks());
    const storageHandler = (event) => {
      if (event.key && event.key !== STADIUM_MAINTENANCE_STORAGE_KEY) return;
      sync();
    };
    window.addEventListener("storage", storageHandler);
    window.addEventListener(STORAGE_EVENTS.STADIUM_MAINTENANCE, sync);
    return () => {
      window.removeEventListener("storage", storageHandler);
      window.removeEventListener(STORAGE_EVENTS.STADIUM_MAINTENANCE, sync);
    };
  }, []);

  const filteredTasks = useMemo(() => {
    if (filter === "전체") return tasks;
    return tasks.filter((task) => task.status === filter);
  }, [tasks, filter]);

  const addTask = () => {
    if (!form.title.trim()) return;
    const nextTask = {
      id: Date.now(),
      title: form.title.trim(),
      facility: form.facility.trim() || "미지정",
      due: form.due.trim() || "미정",
      priority: form.priority,
      status: "대기",
      mailNotified: false,
    };
    setTasks((prev) => {
      const next = [nextTask, ...prev];
      saveMaintenanceTasks(next);
      return next;
    });
    setForm({ title: "", facility: "", due: "", priority: "medium" });
  };

  const updateStatus = (id, status) => {
    setTasks((prev) => {
      const next = prev.map((task) => (task.id === id ? { ...task, status } : task));
      saveMaintenanceTasks(next);
      return next;
    });
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
      saveMaintenanceTasks(nextTasks);
    }
  }, [tasks]);

  return (
    <div className="stadium-alerts-page">
      <header className="alerts-header">
        <div>
          <h2>시설 점검 일정</h2>
          <p>점검 / 청소 / 교체와 같은 작업 일정을 관리하세요.</p>
        </div>
        <CustomSelect value={filter} options={filterOptions} onChange={setFilter} size="sm" />
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
            <CustomSelect
              value={form.priority}
              options={prioritySelectOptions}
              onChange={(value) => setForm((prev) => ({ ...prev, priority: value }))}
              size="sm"
            />
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
                <CustomSelect
                  value={task.status}
                  options={statusSelectOptions}
                  onChange={(value) => updateStatus(task.id, value)}
                  size="sm"
                />
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
