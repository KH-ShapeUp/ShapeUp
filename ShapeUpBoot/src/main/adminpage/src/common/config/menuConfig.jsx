// src/config/menuConfig.jsx
import { FaUser, FaDumbbell, FaRegNewspaper, FaClipboardList } from "react-icons/fa";

const menus = {
  members: {
    name: "회원 관리",
    icon: <FaUser />, // ✅ 아이콘 추가
    path: "/members",
    subs: {
      submenu1: { label: "회원 관리", path: "/admin/members/user" },
      submenu2: { label: "회원 신고 관리", path: "/admin/members/report" },
      trainerReport: { label: "트레이너 신고 관리", path: "/admin/members/trainer-report" },
    },
  },
  trainers: {
    name: "DEV",
    icon: <FaDumbbell />,
    path: "/trainers",
    subs: {
      submenu1: { label: "시설 관리자 페이지 이동", path: "/stadium" },
    },
  },
  feeds: {
    name: "요청 보내기",
    icon: <FaRegNewspaper />,
    path: "/feeds",
    subs: {
      send: { label: "운영지침 보내기", path: "/admin/feeds/send-guideline" },
    },
  },
  posts: {
    name: "게시글",
    icon: <FaClipboardList />,
    path: "/posts",
    subs: {
      submenu1: { label: "공지사항", path: "/admin/posts/notice" },
      submenu2: { label: "자유 게시판", path: "/admin/posts/submenu2" },
      submenu3: { label: "성공 후기", path: "/admin/posts/submenu3" },
      submenu4: { label: "질문 / 건의사항", path: "/admin/posts/submenu4" },
      submenu5: { label: "매칭 관리", path : "/admin/posts/matching"},
    },
  },
};

export default menus;
