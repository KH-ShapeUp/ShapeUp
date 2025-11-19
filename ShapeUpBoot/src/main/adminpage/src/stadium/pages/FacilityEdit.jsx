// src/stadium/pages/FacilityEdit.jsx
import React, { useEffect, useMemo, useState } from "react";
import "../styles/FacilityEdit.css";
import { useFacilityData } from "../context/FacilityDataContext";
import CustomSelect from "../../common/components/CustomSelect";

const FacilityEdit = () => {
  const { timeSlots, setTimeSlots, schedules, facilities } = useFacilityData();
  const [selectedFacility, setSelectedFacility] = useState(facilities[0] ?? "시설 1");
  const [draftSlots, setDraftSlots] = useState(timeSlots);
  const [saveStatus, setSaveStatus] = useState("");
  const facilityOptions = useMemo(
    () => (facilities.length ? facilities : ["시설 1", "시설 2", "시설 3"]),
    [facilities]
  );

  useEffect(() => {
    if (!facilities.includes(selectedFacility) && facilities.length) {
      setSelectedFacility(facilities[0]);
    }
  }, [facilities, selectedFacility]);

  useEffect(() => {
    setDraftSlots(timeSlots);
  }, [timeSlots]);

  const addTimeSlot = () => setDraftSlots((prev) => [...prev, ""]);
  const removeTimeSlot = (idx) =>
    setDraftSlots((prev) => prev.filter((_, i) => i !== idx));
  const updateTime = (idx, value) => {
    setDraftSlots((prev) => prev.map((slot, i) => (i === idx ? value : slot)));
  };

  const saveTimeSlots = () => {
    const sanitized = draftSlots.map((slot) => slot.trim()).filter(Boolean);
    if (!sanitized.length) {
      setSaveStatus("시간대를 한 개 이상 입력하세요.");
      return;
    }
    const invalid = sanitized.find((slot) => !/^\d{2}:\d{2}~\d{2}:\d{2}$/.test(slot));
    if (invalid) {
      setSaveStatus("시간대를 24시간 형식(HH:MM~HH:MM)으로 입력하세요.");
      return;
    }
    const uniqueSorted = Array.from(new Set(sanitized)).sort((a, b) => a.localeCompare(b));
    setTimeSlots(uniqueSorted);
    setSaveStatus("공통 시간대가 저장되었습니다.");
    setTimeout(() => setSaveStatus(""), 1500);
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
          <CustomSelect
            value={selectedFacility}
            options={facilityOptions}
            onChange={setSelectedFacility}
            size="sm"
          />
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
            {draftSlots.map((time, idx) => (
              <div key={idx} className="time-item">
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
          <button type="button" className="submit-btn save-btn" onClick={saveTimeSlots}>
            공통 시간대 저장
          </button>
          {saveStatus && <p className="save-status">{saveStatus}</p>}
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
