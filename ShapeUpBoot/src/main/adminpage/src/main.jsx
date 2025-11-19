import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import AdminApp from "./admin/App.jsx";
import StadiumApp from "./stadium/StadiumApp.jsx";
import favicon from "./common/images/favicon.png";

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
        <Route path="/stadium/*" element={<StadiumApp />} />
        <Route path="/*" element={<AdminApp />} />
      </Routes>
    </BrowserRouter>
  </StrictMode>
);
