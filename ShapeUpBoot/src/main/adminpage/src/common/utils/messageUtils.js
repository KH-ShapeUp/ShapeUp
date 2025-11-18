import {
  STADIUM_MESSAGE_STORAGE_KEY,
  STORAGE_EVENTS,
} from "./storageKeys";

const isBrowser = typeof window !== "undefined";

export const readInboxMessages = () => {
  if (!isBrowser) return [];
  try {
    const raw = window.localStorage.getItem(STADIUM_MESSAGE_STORAGE_KEY);
    if (!raw) return [];
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) return [];
    return parsed.filter((msg) => msg && msg.category);
  } catch (err) {
    console.warn("Failed to read inbox messages", err);
    return [];
  }
};

const writeInboxMessages = (records) => {
  if (!isBrowser) return;
  window.localStorage.setItem(STADIUM_MESSAGE_STORAGE_KEY, JSON.stringify(records));
  window.dispatchEvent(new Event(STORAGE_EVENTS.STADIUM_MESSAGES));
};

const defaultDateString = () =>
  new Date().toLocaleString("ko-KR", {
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
  });

export const appendInboxMessage = ({
  id,
  sender = "시스템",
  subject = "새 알림",
  preview = "",
  body = "",
  category = "알림",
  metadata = {},
  sourceType,
  sourceId,
}) => {
  if (!isBrowser) return null;
  const entry = {
    id: id ?? Date.now(),
    sender,
    subject,
    preview,
    body: body || preview,
    category,
    date: defaultDateString(),
    metadata: { sourceType, sourceId, ...metadata },
  };
  const next = [entry, ...readInboxMessages()];
  writeInboxMessages(next);
  return entry;
};

export const deleteInboxMessage = (id) => {
  if (!isBrowser) return;
  const next = readInboxMessages().filter((msg) => msg.id !== id);
  writeInboxMessages(next);
};

export const clearInboxMessages = () => {
  if (!isBrowser) return;
  window.localStorage.removeItem(STADIUM_MESSAGE_STORAGE_KEY);
  window.dispatchEvent(new Event(STORAGE_EVENTS.STADIUM_MESSAGES));
};
