import React, { useEffect, useMemo, useRef, useState } from "react";
import { createPortal } from "react-dom";
import "../styles/CustomSelect.css";

const normalizeOption = (option) =>
  typeof option === "object" ? option : { label: option, value: option };

const CustomSelect = ({
  value,
  onChange,
  options = [],
  placeholder = "Select option...",
  disabled = false,
  className = "",
  size = "md",
}) => {
  const list = useMemo(() => options.map(normalizeOption), [options]);
  const selected = list.find((opt) => opt.value === value) ?? null;
  const [open, setOpen] = useState(false);
  const [closing, setClosing] = useState(false);
  const containerRef = useRef(null);
  const closeTimerRef = useRef(null);
  const [dropdownPos, setDropdownPos] = useState({ top: 0, left: 0, width: 0 });
  const portalRoot = typeof document !== "undefined" ? document.body : null;

  const clearCloseTimer = () => {
    if (closeTimerRef.current) {
      clearTimeout(closeTimerRef.current);
      closeTimerRef.current = null;
    }
  };

  const startClosing = () => {
    clearCloseTimer();
    setClosing(true);
    closeTimerRef.current = setTimeout(() => {
      setOpen(false);
      setClosing(false);
      closeTimerRef.current = null;
    }, 180);
  };

  const toggleDropdown = () => {
    if (disabled) return;
    if (open && !closing) {
      startClosing();
    } else {
      clearCloseTimer();
      setClosing(false);
      setOpen(true);
    }
  };

  const updateDropdownPosition = () => {
    if (!open || !containerRef.current || typeof window === "undefined") return;
    const trigger = containerRef.current.querySelector(".custom-select__trigger");
    if (!trigger) return;
    const rect = trigger.getBoundingClientRect();
    setDropdownPos({
      top: rect.bottom + 6,
      left: rect.left,
      width: rect.width,
    });
  };

  useEffect(() => {
    const handleClick = (e) => {
      if (containerRef.current && !containerRef.current.contains(e.target)) {
        if (open) startClosing();
      }
    };
    document.addEventListener("mousedown", handleClick);
    return () => document.removeEventListener("mousedown", handleClick);
  }, [open]);

  useEffect(() => () => clearCloseTimer(), []);

  useEffect(() => {
    if (!open) return;
    updateDropdownPosition();
    if (typeof window === "undefined") return;
    const handler = () => updateDropdownPosition();
    window.addEventListener("resize", handler);
    window.addEventListener("scroll", handler, true);
    return () => {
      window.removeEventListener("resize", handler);
      window.removeEventListener("scroll", handler, true);
    };
  }, [open]);

  const handleSelect = (option) => {
    if (disabled) return;
    onChange?.(option.value);
    startClosing();
  };

  return (
    <div
      ref={containerRef}
      className={`custom-select custom-select--${size} ${disabled ? "disabled" : ""} ${
        open ? "open" : ""
      } ${closing ? "closing" : ""} ${className}`}
    >
      <button
        type="button"
        className="custom-select__trigger"
        onClick={toggleDropdown}
        aria-haspopup="listbox"
        aria-expanded={open && !closing}
      >
        <span>{selected?.label ?? placeholder}</span>
        <svg width="10" height="6" viewBox="0 0 10 6" aria-hidden="true">
          <path d="M1 1l4 4 4-4" fill="none" stroke="currentColor" strokeWidth="1.5" />
        </svg>
      </button>
      {open &&
        (portalRoot
          ? createPortal(
              <ul
                className={`custom-select__list ${closing ? "closing" : "opening"}`}
                role="listbox"
                style={{
                  top: dropdownPos.top,
                  left: dropdownPos.left,
                  width: dropdownPos.width,
                  position: "fixed",
                }}
              >
                {list.map((option) => (
                  <li
                    key={option.value}
                    role="option"
                    aria-selected={option.value === selected?.value}
                    className={option.value === selected?.value ? "selected" : ""}
                    onClick={() => handleSelect(option)}
                  >
                    {option.label}
                  </li>
                ))}
                {!list.length && <li className="empty">옵션이 없습니다.</li>}
              </ul>,
              portalRoot
            )
          : (
              <ul
                className={`custom-select__list ${closing ? "closing" : "opening"}`}
                role="listbox"
              >
                {list.map((option) => (
                  <li
                    key={option.value}
                    role="option"
                    aria-selected={option.value === selected?.value}
                    className={option.value === selected?.value ? "selected" : ""}
                    onClick={() => handleSelect(option)}
                  >
                    {option.label}
                  </li>
                ))}
                {!list.length && <li className="empty">옵션이 없습니다.</li>}
              </ul>
            ))}
    </div>
  );
};

export default CustomSelect;
