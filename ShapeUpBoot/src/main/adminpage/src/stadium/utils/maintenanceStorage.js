import { STADIUM_MAINTENANCE_STORAGE_KEY, STORAGE_EVENTS } from "../../common/utils/storageKeys";

export const defaultMaintenanceTasks = [
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

const isBrowser = typeof window !== "undefined";

export const loadMaintenanceTasks = () => {
  if (!isBrowser) return defaultMaintenanceTasks;
  try {
    const raw = window.localStorage.getItem(STADIUM_MAINTENANCE_STORAGE_KEY);
    if (!raw) {
      window.localStorage.setItem(
        STADIUM_MAINTENANCE_STORAGE_KEY,
        JSON.stringify(defaultMaintenanceTasks)
      );
      return defaultMaintenanceTasks;
    }
    const parsed = JSON.parse(raw);
    return Array.isArray(parsed) ? parsed : defaultMaintenanceTasks;
  } catch (err) {
    console.warn("Failed to load maintenance tasks", err);
    return defaultMaintenanceTasks;
  }
};

export const saveMaintenanceTasks = (tasks) => {
  if (!isBrowser) return;
  window.localStorage.setItem(STADIUM_MAINTENANCE_STORAGE_KEY, JSON.stringify(tasks));
  window.dispatchEvent(new Event(STORAGE_EVENTS.STADIUM_MAINTENANCE));
};
