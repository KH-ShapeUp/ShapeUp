import React, { useEffect, useMemo, useRef, useState } from "react";
import "../../common/styles/CommonLayout.css";
import "../styles/FacilityCheck.css";
import { useFacilityData } from "../context/FacilityDataContext";

const FacilityCheck = () => {
  const {
    members,
    setMembers,
    schedules,
    setSchedules,
    facilities,
    buildEmptySlots,
  } = useFacilityData();
  const [selectedDate, setSelectedDate] = useState("2025-12-12");
  const [selectedFacility, setSelectedFacility] = useState("시설 1");
  const [modal, setModal] = useState({ open: false, member: null, result: "" });
  const closeTimerRef = useRef(null);
  const [sort, setSort] = useState({ key: "id", dir: "asc" });
  const [memberFilterFacility, setMemberFilterFacility] = useState("전체");
  const [searchText, setSearchText] = useState("");

  useEffect(() => {
    return () => {
      if (closeTimerRef.current) {
        clearTimeout(closeTimerRef.current);
      }
    };
  }, []);

  const memberMap = useMemo(() => {
    return members.reduce((acc, member) => {
      acc[member.id] = member;
      return acc;
    }, {});
  }, [members]);

  const filteredMembers = useMemo(() => {
    const term = searchText.trim().toLowerCase();
    return members
      .filter((m) => memberFilterFacility === "전체" || m.facility === memberFilterFacility)
      .filter((m) => {
        if (!term) return true;
        const fields = [
          String(m.id),
          m.user,
          m.userId,
          m.facility,
          formatDisplayDate(m.date),
          m.date,
          m.time,
          m.status,
        ];
        return fields.some((field) => (field ?? "").toLowerCase().includes(term));
      });
  }, [members, memberFilterFacility, searchText]);

  const sortedMembers = useMemo(() => {
    const collator = new Intl.Collator("ko");
    const getVal = (member) => {
      switch (sort.key) {
        case "id":
          return member.id;
        case "user":
          return member.user;
        case "facility":
          return member.facility;
        case "date":
          return member.date;
        case "time":
          return member.time;
        case "status":
          return member.status;
        default:
          return member.id;
      }
    };

    return [...filteredMembers].sort((a, b) => {
      const va = getVal(a);
      const vb = getVal(b);
      let cmp = 0;
      if (sort.key === "id") cmp = va - vb;
      else if (sort.key === "date") cmp = new Date(va).getTime() - new Date(vb).getTime();
      else cmp = collator.compare(String(va ?? ""), String(vb ?? ""));
      return sort.dir === "asc" ? cmp : -cmp;
    });
  }, [filteredMembers, sort]);

  const reservations = useMemo(() => {
    const daySlots = schedules[selectedFacility]?.[selectedDate] ?? buildEmptySlots();
    return daySlots.map((slot) => ({
      ...slot,
      member: slot.memberId ? memberMap[slot.memberId] : null,
    }));
  }, [selectedFacility, selectedDate, schedules, memberMap]);

  const formatDisplayDate = (value) => value.replace(/-/g, ".");

  useEffect(() => {
    if (!schedules[selectedFacility] && facilities.length) {
      setSelectedFacility(facilities[0]);
    }
  }, [facilities, schedules, selectedFacility]);

  const shiftDate = (direction) => {
    const base = new Date(selectedDate);
    if (Number.isNaN(base.getTime())) return;
    base.setDate(base.getDate() + direction);
    const next = base.toISOString().slice(0, 10);
    setSelectedDate(next);
  };

  const openModal = (member) => setModal({ open: true, member, result: "" });
  const closeModal = () => setModal({ open: false, member: null, result: "" });
  const toggleSort = (key) => {
    setSort((prev) =>
      prev.key === key ? { key, dir: prev.dir === "asc" ? "desc" : "asc" } : { key, dir: "asc" }
    );
  };
  const sortMark = (key) => (sort.key === key ? (sort.dir === "asc" ? " ▲" : " ▼") : "");

  const updateScheduleSlot = (member, type) => {
    setSchedules((prev) => {
      const facilitySlots = prev[member.facility];
      if (!facilitySlots) return prev;
      const dateSlots = facilitySlots[member.date];
      if (!dateSlots) return prev;

      const updatedDateSlots = dateSlots.map((slot) =>
        slot.time === member.time
          ? { ...slot, memberId: type === "reject" ? null : member.id }
          : slot
      );

      return {
        ...prev,
        [member.facility]: {
          ...facilitySlots,
          [member.date]: updatedDateSlots,
        },
      };
    });
  };

  const handleModalAction = (type) => {
    if (!modal.member) return;
    const status = type === "approve" ? "예약 확정" : "예약 거부";
    const message = type === "approve" ? "예약이 확정되었습니다." : "예약이 거부되었습니다.";

    setMembers((prev) =>
      prev.map((m) => (m.id === modal.member.id ? { ...m, status } : m))
    );
    updateScheduleSlot(modal.member, type);

    setModal((prev) => ({
      ...prev,
      member: { ...prev.member, status },
      result: message,
    }));

    if (closeTimerRef.current) clearTimeout(closeTimerRef.current);
    closeTimerRef.current = setTimeout(() => {
      closeModal();
    }, 1000);
  };

  return (
    <div className="facility-container">
      <div className="member-list">
        <div className="list-header">
          <h3>회원 리스트</h3>
          <div className="search-area">
            <select value={memberFilterFacility} onChange={(e) => setMemberFilterFacility(e.target.value)}>
              <option value="전체">전체</option>
              {facilities.map((f) => (
                <option key={f} value={f}>
                  {f}
                </option>
              ))}
            </select>
            <input
              type="text"
              placeholder="검색어 입력"
              value={searchText}
              onChange={(e) => setSearchText(e.target.value)}
            />
          </div>
        </div>

        <table className="member-table">
          <thead>
            <tr>
              <th onClick={() => toggleSort("id")} className="sortable">번호{sortMark("id")}</th>
              <th onClick={() => toggleSort("user")} className="sortable">예약자{sortMark("user")}</th>
              <th onClick={() => toggleSort("facility")} className="sortable">예약 시설{sortMark("facility")}</th>
              <th onClick={() => toggleSort("date")} className="sortable">예약일{sortMark("date")}</th>
              <th onClick={() => toggleSort("time")} className="sortable">시간대{sortMark("time")}</th>
              <th onClick={() => toggleSort("status")} className="sortable">상태{sortMark("status")}</th>
            </tr>
          </thead>
          <tbody>
            {sortedMembers.map((m) => (
              <tr
                key={m.id}
                className="clickable-row"
                onClick={() => openModal(m)}
              >
                <td>{m.id}</td>
                <td>{m.user}</td>
                <td>{m.facility}</td>
                <td>{formatDisplayDate(m.date)}</td>
                <td>{m.time}</td>
                <td>{m.status}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <div className="reservation-section">
        <div className="res-header">
          <h3>시설 예약 확인</h3>
          <div className="filter-bar">
            <select value={selectedFacility} onChange={(e) => setSelectedFacility(e.target.value)}>
              {facilities.map((f) => (
                <option key={f} value={f}>
                  {f}
                </option>
              ))}
            </select>
            <div className="date-picker">
              <button type="button" onClick={() => shiftDate(-1)} aria-label="하루 전">
                ‹
              </button>
              <input
                type="date"
                value={selectedDate}
                onChange={(e) => setSelectedDate(e.target.value)}
              />
              <button type="button" onClick={() => shiftDate(1)} aria-label="하루 후">
                ›
              </button>
            </div>
          </div>
        </div>

        <div className="reservation-list">
          {reservations.length ? (
            reservations.map((slot, idx) => {
              const hasReservation = slot.member && slot.member.status !== "예약 거부";
              const isPending = hasReservation && /대기/.test(slot.member.status);

              return (
                <div
                key={`${selectedFacility}-${selectedDate}-${idx}`}
                className={`reservation-card ${hasReservation ? "booked" : "empty"} ${isPending ? "pending" : ""}`}
              >
                <div className="res-time">{slot.time.replace("~", " ~ ")}</div>
                {hasReservation ? (
                  <div className="res-info">
                    <p>예약자: {slot.member.user}</p>
                    {isPending ? (
                      <p className="pending-text">💰 입금 확인 대기 중</p>
                    ) : (
                      <p className="confirm-text">✅ 예약이 확정되었습니다.</p>
                    )}
                    <div className="res-actions">
                      <button type="button">취소</button>
                      <button type="button">채팅</button>
                    </div>
                  </div>
                ) : (
                  <p className="no-booking">해당 시간대에 예약이 없습니다.</p>
                )}
              </div>
              );
            })
          ) : (
            <div className="reservation-placeholder">
              선택한 날짜에는 예약 정보가 없습니다.
            </div>
          )}
        </div>
      </div>

      {modal.open && modal.member && (
        <div className="modal-overlay" role="dialog" aria-modal="true" onClick={closeModal}>
          <div className="modal-content" onClick={(e) => e.stopPropagation()}>
            <button className="close-btn" onClick={closeModal} aria-label="닫기">
              ×
            </button>
            <h3>송금 / 예약 확인</h3>
            <p>예약자: {modal.member.user}</p>
            <p>아이디: {modal.member.userId}</p>
            <p>예약 시설: {modal.member.facility}</p>
            <p>예약일: {formatDisplayDate(modal.member.date)}</p>
            <p>시간대: {modal.member.time}</p>
            <p>입금 금액: {modal.member.price.toLocaleString()}원</p>
            <p>현 상태: {modal.member.status}</p>

            {modal.result ? (
              <p className="modal-feedback">{modal.result}</p>
            ) : (
              <div className="modal-actions">
                <button className="approve" onClick={() => handleModalAction("approve")}>
                  송금 확인
                </button>
                <button className="reject" onClick={() => handleModalAction("reject")}>
                  예약 거부
                </button>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
};

export default FacilityCheck;
