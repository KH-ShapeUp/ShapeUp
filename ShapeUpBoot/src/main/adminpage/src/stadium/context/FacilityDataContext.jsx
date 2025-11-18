import React, { createContext, useContext, useEffect, useMemo, useState } from "react";
import {
  buildEmptySlots,
  defaultTimeSlots,
  initialMembers,
  initialSchedules,
} from "../data/facilityData";
import {
  STADIUM_FACILITY_MEMBERS_KEY,
  STADIUM_FACILITY_SCHEDULES_KEY,
  STADIUM_TIME_SLOTS_KEY,
} from "../../common/utils/storageKeys";

const isBrowser = typeof window !== "undefined";

const loadState = (key, fallback) => {
  if (!isBrowser) return fallback;
  try {
    const raw = window.localStorage.getItem(key);
    if (!raw) {
      window.localStorage.setItem(key, JSON.stringify(fallback));
      return fallback;
    }
    const parsed = JSON.parse(raw);
    return parsed ?? fallback;
  } catch (err) {
    console.warn(`Failed to load ${key}`, err);
    return fallback;
  }
};

const persistState = (key, value) => {
  if (!isBrowser) return;
  try {
    window.localStorage.setItem(key, JSON.stringify(value));
  } catch (err) {
    console.warn(`Failed to save ${key}`, err);
  }
};

const FacilityDataContext = createContext(null);

export const FacilityDataProvider = ({ children }) => {
  const [members, setMembers] = useState(() =>
    loadState(STADIUM_FACILITY_MEMBERS_KEY, initialMembers)
  );
  const [schedules, setSchedules] = useState(() =>
    loadState(STADIUM_FACILITY_SCHEDULES_KEY, initialSchedules)
  );
  const [timeSlots, setTimeSlots] = useState(() =>
    loadState(STADIUM_TIME_SLOTS_KEY, defaultTimeSlots)
  );

  useEffect(() => {
    persistState(STADIUM_FACILITY_MEMBERS_KEY, members);
  }, [members]);

  useEffect(() => {
    persistState(STADIUM_FACILITY_SCHEDULES_KEY, schedules);
  }, [schedules]);

  useEffect(() => {
    persistState(STADIUM_TIME_SLOTS_KEY, timeSlots);
  }, [timeSlots]);

  const value = useMemo(
    () => ({
      members,
      setMembers,
      schedules,
      setSchedules,
      timeSlots,
      setTimeSlots,
      facilities: Object.keys(schedules),
      buildEmptySlots: () => buildEmptySlots(timeSlots),
    }),
    [members, schedules, timeSlots]
  );

  return (
    <FacilityDataContext.Provider value={value}>
      {children}
    </FacilityDataContext.Provider>
  );
};

export const useFacilityData = () => {
  const ctx = useContext(FacilityDataContext);
  if (!ctx) {
    throw new Error("useFacilityData must be used within FacilityDataProvider");
  }
  return ctx;
};
