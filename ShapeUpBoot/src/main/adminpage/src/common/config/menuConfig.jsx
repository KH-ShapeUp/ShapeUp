// src/config/menuConfig.jsx
import { FaUser, FaDumbbell, FaRegNewspaper, FaClipboardList } from "react-icons/fa";

const menus = {
  members: {
    name: "회원 관리",
    icon: <FaUser />, 
    path: "/members",
    subs: {
      submenu1:       { label: "회원",            path: "/admin/members/user" },
      submenu2:       { label: "회원 신고",       path: "/admin/members/report" },
      trainerReport:  { label: "트레이너 신고",    path: "/admin/members/trainer-report" },
      roleRequest:    { label: "권한 요청",            path: "/admin/members/role-request" },
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
      submenu4: { label: "고객센터 문의", path: "/admin/posts/submenu4"},
      submenu5: { label: "매칭 게시판", path : "/admin/posts/matching"},
      submenu6: { label: "트레이너 매칭 게시판", path : "/admin/posts/trainer"},
    },
  },
};

export default menus;
