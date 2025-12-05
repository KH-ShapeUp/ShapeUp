import React, { useEffect, useState } from "react";
import { Routes, Route, useLocation, useNavigate } from "react-router-dom";
import Sidebar from "../common/components/Sidebar";
import Header from "../common/components/Header";
import Dashboard from "./pages/Dashboard";
import PagePlaceholder from "../common/components/PagePlaceholder";
import menus from "../common/config/menuConfig";
import MembersUser from "./pages/MembersUser";
import PostsNotice from "./pages/PostNotice";
import PostFreeBoard from "./pages/PostFreeBoard";
import PostSuccessBoard from "./pages/PostSuccessBoard";
import PostQnaBoard from "./pages/PostQnaBoard";
import PostMatchingBoard from "./pages/PostMatchingBoard";
import SendGuideline from "./pages/SendGuideline";
import MembersReport from "./pages/ReportManagement";
import TrainerReport from "./pages/TrainerReport";
import MembersRoleRequest from "./pages/MembersRoleRequest";
import PostContactBoard from "./pages/PostContactBoard";
import "./App.css";
import "./styles/Dashboard.css";

const useHeaderTitle = () => {
  const { pathname } = useLocation();
  const parts = pathname.split("/admin").filter(Boolean);
  if (parts.length === 0) return "메인 화면";

  const [section, submenu] = parts;
  const menu = menus[section];
  if (!menu) return "메인 화면";

  // ✅ submenu 객체 접근 시 label 사용
  if (submenu && menu.subs && menu.subs[submenu]) {
    return `${menu.name} - ${menu.subs[submenu].label}`;
  }
  return menu.name;
};

function App() {
  const title = useHeaderTitle();
  const navigate = useNavigate();
  const [authChecked, setAuthChecked] = useState(false);

  useEffect(() => {
    const checkAuth = async () => {
      try {
        const res = await fetch("/api/session/user-type", { credentials: "include" });
        if (!res.ok) {
          alert("잘못된 접근입니다.");
          window.location.href = "http://localhost:8080";
          return;
        }
        const data = await res.json();
        if (data.userType !== "SYSTEM_MANAGER") {
          if (data.userType === "STADIUM_MANAGER") {
            alert("잘못된 접근입니다.");
            window.location.href = "http://localhost:8080/stadium";
            return;
          }
          alert("잘못된 접근입니다.");
          window.location.href = "http://localhost:8080";
          return;
        }
        setAuthChecked(true);
      } catch (e) {
        alert("잘못된 접근입니다.");
        window.location.href = "http://localhost:8080";
      }
    };
    checkAuth();
  }, []);

  if (!authChecked) return null;

  return (
    <div className="app-container">
      <Sidebar homeHref="/admin" variant="admin" mainPath="/admin" />
      <div className="main-content">
        <Header title={title} />

        <Routes>
          <Route path="/" element={<Dashboard />} />

          {/* ✅ 메뉴 기반 라우팅 자동 생성 */}
          {Object.entries(menus).map(([sectionKey, section]) =>
            Object.entries(section.subs).map(([subKey, sub]) => {
              const routeElements = {
                "/admin/members/user": <MembersUser />,
                "/admin/members/report": <MembersReport />,
                "/admin/members/trainer-report": <TrainerReport />,
                "/admin/members/role-request": <MembersRoleRequest />,
                "/admin/posts/notice": <PostsNotice />,
                "/admin/posts/submenu2": <PostFreeBoard />,
                "/admin/posts/submenu3": <PostSuccessBoard />,
                "/admin/posts/submenu4": <PostContactBoard />,
                "/admin/posts/matching": <PostMatchingBoard />,
                "/admin/feeds/send-guideline": <SendGuideline />,
              };
              const element = routeElements[sub.path] ?? (
                <PagePlaceholder title={`${section.name} - ${sub.label}`} />
              );

              const relPath = sub.path.startsWith("/admin")
                ? sub.path.substring("/admin".length)
                : sub.path;

              return (
                <React.Fragment key={`${sectionKey}-${subKey}`}>
                  <Route path={sub.path} element={element} />
                  <Route path={relPath} element={element} />
                </React.Fragment>
              );
            })
          )}
        </Routes>
      </div>
    </div>
  );
}

export default App;
