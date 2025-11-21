import { StrictMode, useEffect, useState } from "react";
import { createRoot } from "react-dom/client";
import { BrowserRouter, Routes, Route, useNavigate } from "react-router-dom";
import AdminApp from "./admin/App.jsx";
import StadiumApp from "./stadium/StadiumApp.jsx";
import favicon from "./common/images/favicon.png";

const EntryGate = () => {
  const navigate = useNavigate();
  const [checking, setChecking] = useState(true);

  useEffect(() => {
    const check = async () => {
      try {
        const res = await fetch("/api/session/user-type", { credentials: "include" });
        if (!res.ok) {
          alert("잘못된 접근입니다.");
          window.location.href = "http://localhost:8080";
          return;
        }
        const data = await res.json();
        if (data.userType === "SYSTEM_MANAGER") {
          navigate("/admin", { replace: true });
          return;
        }
        if (data.userType === "STADIUM_MANAGER") {
          navigate("/stadium", { replace: true });
          return;
        }
        alert("잘못된 접근입니다.");
        window.location.href = "http://localhost:8080";
      } catch (e) {
        alert("잘못된 접근입니다.");
        window.location.href = "http://localhost:8080";
      } finally {
        setChecking(false);
      }
    };
    check();
  }, [navigate]);

  if (checking) return null;
  return null;
};

if (typeof document !== "undefined") {
  const existing = document.querySelector("link[rel='icon']");
  const ensureLink = existing ?? (() => {
      const link = document.createElement("link");
      link.rel = "icon";
      document.head.appendChild(link);
      return link;
    })();
  ensureLink.type = "image/png";
  ensureLink.href = favicon;
  ensureLink.sizes = "128x128";
}

createRoot(document.getElementById("root")).render(
  <StrictMode>
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<EntryGate />} />
        <Route path="/stadium/*" element={<StadiumApp />} />
        <Route path="/admin/*" element={<AdminApp />} />
      </Routes>
    </BrowserRouter>
  </StrictMode>
);
