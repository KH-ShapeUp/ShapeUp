export const defaultTimeSlots = [
  "08:00~09:00",
  "09:00~10:00",
  "10:00~11:00",
  "11:00~12:00",
  "12:00~13:00",
  "13:00~14:00",
  "14:00~15:00",
];

export const buildEmptySlots = (slots = defaultTimeSlots) =>
  slots.map((time) => ({ time, memberId: null }));

export const initialSchedules = {
  "시설 1": {
    "2025-12-11": [
      { time: "09:00~10:00", memberId: 6 },
      { time: "10:00~11:00", memberId: null },
      { time: "11:00~12:00", memberId: 7 },
      { time: "12:00~13:00", memberId: null },
      { time: "13:00~14:00", memberId: null },
      { time: "14:00~15:00", memberId: null },
    ],
    "2025-12-12": [
      { time: "09:00~10:00", memberId: 1 },
      { time: "10:00~11:00", memberId: 2 },
      { time: "11:00~12:00", memberId: null },
      { time: "12:00~13:00", memberId: null },
      { time: "13:00~14:00", memberId: null },
      { time: "14:00~15:00", memberId: 3 },
    ],
    "2025-12-13": buildEmptySlots(),
  },
  "시설 2": {
    "2025-12-12": [
      { time: "08:00~09:00", memberId: 4 },
      { time: "09:00~10:00", memberId: null },
      { time: "10:00~11:00", memberId: 5 },
      { time: "11:00~12:00", memberId: null },
      { time: "12:00~13:00", memberId: null },
      { time: "13:00~14:00", memberId: null },
    ],
    "2025-12-14": buildEmptySlots(),
  },
  "시설 3": {
    "2025-12-13": [
      { time: "08:00~09:00", memberId: null },
      { time: "09:00~10:00", memberId: 8 },
      { time: "10:00~11:00", memberId: null },
      { time: "11:00~12:00", memberId: 9 },
      { time: "12:00~13:00", memberId: null },
      { time: "13:00~14:00", memberId: null },
    ],
  },
};

export const initialMembers = [
  { id: 1, user: "홍길동", userId: "user01", facility: "시설 1", date: "2025-12-12", time: "09:00~10:00", price: 50000, status: "입금 확인 대기" },
  { id: 2, user: "김철수", userId: "user02", facility: "시설 1", date: "2025-12-12", time: "10:00~11:00", price: 70000, status: "예약 확인 대기" },
  { id: 3, user: "이영희", userId: "user03", facility: "시설 1", date: "2025-12-12", time: "14:00~15:00", price: 40000, status: "입금 확인 대기" },
  { id: 4, user: "최지원", userId: "user04", facility: "시설 2", date: "2025-12-12", time: "08:00~09:00", price: 65000, status: "확인 완료" },
  { id: 5, user: "조민수", userId: "user05", facility: "시설 2", date: "2025-12-12", time: "10:00~11:00", price: 75000, status: "입금 확인 대기" },
  { id: 6, user: "오지현", userId: "user06", facility: "시설 1", date: "2025-12-11", time: "09:00~10:00", price: 42000, status: "입금 확인 대기" },
  { id: 7, user: "남지훈", userId: "user07", facility: "시설 1", date: "2025-12-11", time: "11:00~12:00", price: 38000, status: "예약 확인 대기" },
  { id: 8, user: "장유나", userId: "user08", facility: "시설 3", date: "2025-12-13", time: "09:00~10:00", price: 56000, status: "입금 확인 대기" },
  { id: 9, user: "백승환", userId: "user09", facility: "시설 3", date: "2025-12-13", time: "11:00~12:00", price: 61000, status: "예약 확인 대기" },
];
