import React from "react";
import { Routes, Route, useLocation } from "react-router-dom";
import Sidebar from "../common/components/Sidebar";
import Header from "../common/components/Header";
import PagePlaceholder from "../common/components/PagePlaceholder";

import stadiumMenus from "../common/config/stadiumMenuConfig";
import FacilityCheck from "./pages/FacilityCheck";
import FacilityEdit from "./pages/FacilityEdit";
import Dashboard from "./pages/Dashboard";
import StadiumMaintenance from "./pages/StadiumMaintenance";
import StadiumNotifications from "./pages/StadiumNotifications";
import StadiumSuggestion from "./pages/StadiumSuggestion";
import FacilityReview from "./pages/FacilityReview";
import StadiumMemo from "./pages/StadiumMemo";
import StadiumMail from "./pages/StadiumMail";
import "../stadium/styles/StadiumLayout.css";
import { FacilityDataProvider } from "./context/FacilityDataContext";

const useHeaderTitle = () => {
  const { pathname } = useLocation();
  const parts = pathname.split("/").filter(Boolean);
  if (parts.length < 2) return "시설 관리자 메인";

  const [, section, submenu] = parts;
  const menu = stadiumMenus[section];
  if (!menu) return "시설 관리자 메인";

  if (submenu && menu.subs && menu.subs[submenu]) {
    return `${menu.name} - ${menu.subs[submenu].label}`;
  }
  return menu.name;
};

function StadiumApp() {
  const title = useHeaderTitle();

  const routeElements = {
    "/stadium": <Dashboard />,
    "/stadium/facility/check": <FacilityCheck />,
    "/stadium/facility/edit": <FacilityEdit />,
    "/stadium/facility/manage": <StadiumSuggestion />,
    "/stadium/facility/review": <FacilityReview />,
    "/stadium/alerts/maintenance": <StadiumMaintenance />,
    "/stadium/alerts/notifications": <StadiumNotifications />,
    "/stadium/alerts/memo": <StadiumMemo />,
    "/stadium/alerts/mail": <StadiumMail />,
  };

  return (
    <FacilityDataProvider>
      <div className="app-container">
      <Sidebar menus={stadiumMenus} homePath="/stadium" variant="stadium" mainPath="/stadium" />
        <div className="main-content">
          <Header title={title} />
          <Routes>
            {/* stadium 메인 접속 시 대시보드 */}
            <Route index element={<Dashboard />} />

            {/* 메뉴 기반 라우팅 */}
            {Object.entries(stadiumMenus).map(([sectionKey, section]) =>
              Object.entries(section.subs).map(([subKey, sub]) => {
                const element = routeElements[sub.path] ?? (
                  <PagePlaceholder title={`${section.name} - ${sub.label}`} />
                );
                return (
                  <Route
                    key={`${sectionKey}-${subKey}`}
                    path={sub.path.replace("/stadium/", "")}
                    element={element}
                  />
                );
              })
            )}
          </Routes>
        </div>
      </div>
    </FacilityDataProvider>
  );
}

export default StadiumApp;
