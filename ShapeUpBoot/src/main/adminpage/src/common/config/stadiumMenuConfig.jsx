// src/common/config/stadiumMenuConfig.jsx
import { FaBuilding, FaBell } from "react-icons/fa";

const stadiumMenus = {

  facility: {
    name: "시설 관리자",
    icon: <FaBuilding />,
    path: "/stadium/facility",
    subs: {
      check: { label: "입금 / 예약 확인", path: "/stadium/facility/check" },
      edit: { label: "시설 추가 및 수정", path: "/stadium/facility/edit" }
    },
  },

  alerts: {
    name: "알림 / 메모",
    icon: <FaBell />,
    path: "/stadium/alerts",
    subs: {
      maintenance: { label: "시설 점검 일정 확인", path: "/stadium/alerts/maintenance" },
      notifications: { label: "운영 알림", path: "/stadium/alerts/notifications" },
    },
  },
};

export default stadiumMenus;
