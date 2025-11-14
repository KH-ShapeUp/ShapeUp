// src/stadium/pages/FacilityEdit.jsx
import React, { useEffect, useMemo, useState } from "react";
import "../styles/FacilityEdit.css";
import { useFacilityData } from "../context/FacilityDataContext";

const FacilityEdit = () => {
  const { timeSlots, setTimeSlots, schedules, facilities } = useFacilityData();
  const [selectedFacility, setSelectedFacility] = useState(facilities[0] ?? "시설 1");

  useEffect(() => {
    if (!facilities.includes(selectedFacility) && facilities.length) {
      setSelectedFacility(facilities[0]);
    }
  }, [facilities, selectedFacility]);

  const addTimeSlot = () => setTimeSlots((prev) => [...prev, ""]);
  const removeTimeSlot = (idx) =>
    setTimeSlots((prev) => prev.filter((_, i) => i !== idx));
  const updateTime = (idx, value) => {
    setTimeSlots((prev) => prev.map((slot, i) => (i === idx ? value : slot)));
  };

  const facilityDates = useMemo(
    () => Object.keys(schedules[selectedFacility] || {}),
    [schedules, selectedFacility]
  );

  return (
    <div className="facility-edit-container">
      {/* 좌측 - 시설 등록 */}
      <div className="facility-card">
        <h3>시설 등록</h3>
        <div className="form-group">
          <label>시설명</label>
          <input type="text" placeholder="시설명을 입력하세요" />
        </div>
        <div className="form-group">
          <label>시설 위치</label>
          <input type="text" placeholder="시설 위치를 입력하세요" />
        </div>
        <div className="form-group">
          <label>시설 설명</label>
          <textarea placeholder="시설 설명을 입력하세요" />
        </div>
        <div className="btn-area">
          <button className="submit-btn">등록</button>
        </div>
      </div>

      {/* 우측 - 시설 수정 */}
      <div className="facility-card">
        <h3>시설 수정</h3>

        <div className="form-group">
          <label>수정할 시설</label>
          <select value={selectedFacility} onChange={(e) => setSelectedFacility(e.target.value)}>
            {facilities.map((facility) => (
              <option key={facility} value={facility}>
                {facility}
              </option>
            ))}
          </select>
        </div>

        <div className="form-group">
          <label>시설명</label>
          <input type="text" placeholder="선택 시설명을 입력하세요" />
        </div>

        <div className="form-group">
          <label>시설 위치</label>
          <input type="text" placeholder="선택 시설 위치를 입력하세요" />
        </div>

        <div className="form-group">
          <label>시설 설명</label>
          <textarea placeholder="선택 시설 설명을 입력하세요" />
        </div>

        <div className="btn-area">
          <button className="submit-btn">수정</button>
        </div>

        {/* 시간대 수정 */}
        <div className="time-edit-section">
          <div className="time-header">
            <h4>공통 시간대 수정</h4>
            <button className="add-btn" onClick={addTimeSlot}>＋</button>
          </div>
          <div className="time-list">
            {timeSlots.map((time, idx) => (
              <div key={`${time}-${idx}`} className="time-item">
                <input
                  type="text"
                  value={time}
                  onChange={(e) => updateTime(idx, e.target.value)}
                />
                <button
                  className="remove-btn"
                  onClick={() => removeTimeSlot(idx)}
                >
                  −
                </button>
              </div>
            ))}
          </div>
          <p className="time-helper">
            이 시간대 목록은 Facility Check 화면에서 빈 슬롯 생성 시 활용됩니다.
          </p>
        </div>

        <div className="date-preview-section">
          <h4>선택한 시설 예약 날짜</h4>
          {facilityDates.length ? (
            <ul>
              {facilityDates.map((date) => (
                <li key={date}>{date}</li>
              ))}
            </ul>
          ) : (
            <p className="time-helper">등록된 예약 정보가 없습니다.</p>
          )}
        </div>
      </div>
    </div>
  );
};

export default FacilityEdit;
