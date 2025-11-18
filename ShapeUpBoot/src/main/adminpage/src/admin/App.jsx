import React from "react";
import { Routes, Route, useLocation } from "react-router-dom";
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
import SendGuideline from "./pages/SendGuideline";
import MembersReport from "./pages/ReportManagement";
import TrainerReport from "./pages/TrainerReport";
import "./App.css";
import "./styles/Dashboard.css";

const useHeaderTitle = () => {
  const { pathname } = useLocation();
  const parts = pathname.split("/").filter(Boolean);
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

  return (
    <div className="app-container">
      <Sidebar homeHref="/" variant="admin" mainPath="/" />
      <div className="main-content">
        <Header title={title} />

        <Routes>
          <Route path="/" element={<Dashboard />} />

          {/* ✅ 메뉴 기반 라우팅 자동 생성 */}
          {Object.entries(menus).map(([sectionKey, section]) =>
            Object.entries(section.subs).map(([subKey, sub]) => {
              const routeElements = {
                "/members/user": <MembersUser />,
                "/members/report": <MembersReport />,
                "/members/trainer-report": <TrainerReport />,
                "/posts/notice": <PostsNotice />,
                "/posts/submenu2": <PostFreeBoard />,
                "/posts/submenu3": <PostSuccessBoard />,
                "/posts/submenu4": <PostQnaBoard />,
                "/feeds/send-guideline": <SendGuideline />,
              };
              const element = routeElements[sub.path] ?? (
                <PagePlaceholder title={`${section.name} - ${sub.label}`} />
              );

              return (
                <Route key={`${sectionKey}-${subKey}`} path={sub.path} element={element} />
              );
            })
          )}
        </Routes>
      </div>
    </div>
  );
}

export default App;
