import React from "react";
import "../styles/PagePlaceholder.css";
const PagePlaceholder = ({ title = "페이지" }) => (
  <div className="page-placeholder">
    <h2>{title}</h2>
    <p>구현중입니다</p>
  </div>
);
export default PagePlaceholder;
