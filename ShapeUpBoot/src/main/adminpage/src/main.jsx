import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import { BrowserRouter, Routes, Route } from "react-router-dom";
import AdminApp from "./admin/App.jsx";
import StadiumApp from "./stadium/StadiumApp.jsx";

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

