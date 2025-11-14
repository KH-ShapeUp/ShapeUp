// src/config/menuConfig.jsx
import { FaUser, FaDumbbell, FaRegNewspaper, FaClipboardList } from "react-icons/fa";

const menus = {
  members: {
    name: "회원 관리",
    icon: <FaUser />, // ✅ 아이콘 추가
    path: "/members",
    subs: {
      submenu1: { label: "회원 관리", path: "/members/user" },
      submenu2: { label: "회원 신고 관리", path: "/members/report" },
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
    name: "피드 관리",
    icon: <FaRegNewspaper />,
    path: "/feeds",
    subs: {
      submenu1: { label: "사이드메뉴1", path: "/feeds/submenu1" },
      submenu2: { label: "사이드메뉴2", path: "/feeds/submenu2" },
    },
  },
  posts: {
    name: "게시글",
    icon: <FaClipboardList />,
    path: "/posts",
    subs: {
      submenu1: { label: "공지사항", path: "/posts/notice" },
      submenu2: { label: "자유 게시판", path: "/posts/submenu2" },
      submenu3: { label: "성공 후기", path: "/posts/submenu3" },
      submenu4: { label: "질문 / 건의사항", path: "/posts/submenu4" },
    },
  },
};

export default menus;
