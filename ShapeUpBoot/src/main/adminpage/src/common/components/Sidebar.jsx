import React, { useState } from "react";
import { NavLink, useNavigate } from "react-router-dom";
import { FaHome, FaSignOutAlt, FaChevronDown } from "react-icons/fa";
import defaultMenus from "../config/menuConfig";
import "../styles/Sidebar.css";

const Sidebar = ({ menus = defaultMenus, homePath = "/" }) => {
  const [open, setOpen] = useState({});
  const navigate = useNavigate();

  const toggle = (id, hasSub) => {
    if (!hasSub) {
      navigate(homePath);
      return;
    }
    setOpen(prev => ({ ...prev, [id]: !prev[id] }));
  };

  return (
    <aside className="sidebar">
      <div className="logo">
        <span className="logo-text">ShapeUp ADMIN</span>
      </div>

      <ul className="menu">
        <li>
          <button
            type="button"
            className="menu-toggle"
            onClick={() => navigate(homePath)}
          >
            <span className="menu-label">메인 페이지</span>
          </button>
        </li>

        {Object.entries(menus).map(([id, menu]) => (
          <li key={id} className={menu.subs ? "has-sub" : ""}>
            <button
              type="button"
              className="menu-toggle"
              onClick={() => toggle(id, !!menu.subs)}
              aria-expanded={!!open[id]}
            >
              <span className="menu-icon">{menu.icon}</span>
              <span className="menu-label">{menu.name}</span>
              {menu.subs && (
                <FaChevronDown className={"chevron" + (open[id] ? " open" : "")} />
              )}
            </button>

            {menu.subs && (
              <div className={"submenu" + (open[id] ? " open" : "")}>
                {Object.entries(menu.subs).map(([subId, sub]) => (
                  <NavLink key={subId} to={sub.path} className="submenu-link">
                    {sub.label}
                  </NavLink>
                ))}
              </div>
            )}
          </li>
        ))}
      </ul>

      <div className="quick-actions">
        <button
          className="icon-btn"
          aria-label="Home"
          onClick={() => navigate(homePath)}
        >
          <FaHome />
        </button>
        <button className="icon-btn" aria-label="Logout">
          <FaSignOutAlt />
        </button>
      </div>

      <div className="server-status">
        <p>서버 상태</p>
        <button className="status-btn">정상</button>
      </div>
    </aside>
  );
};

export default Sidebar;
