// src/common/config/stadiumMenuConfig.jsx
import { FaHome, FaBuilding, FaMoneyCheckAlt } from "react-icons/fa";

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

  income: {
    name: "정산 / 매출 관리",
    icon: <FaMoneyCheckAlt />,
    path: "/stadium/income",
    subs: {
      summary: { label: "정산 내역", path: "/stadium/income/summary" },
      deposit: { label: "입금 확인", path: "/stadium/income/deposit" },
    },
  },
};

export default stadiumMenus;
