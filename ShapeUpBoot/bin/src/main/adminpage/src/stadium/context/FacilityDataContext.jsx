import React, { createContext, useContext, useMemo, useState } from "react";
import {
  buildEmptySlots,
  defaultTimeSlots,
  initialMembers,
  initialSchedules,
} from "../data/facilityData";

const FacilityDataContext = createContext(null);

export const FacilityDataProvider = ({ children }) => {
  const [members, setMembers] = useState(initialMembers);
  const [schedules, setSchedules] = useState(initialSchedules);
  const [timeSlots, setTimeSlots] = useState(defaultTimeSlots);

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
