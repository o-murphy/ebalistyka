import React, { useState } from "react";
import CustomDropDown from "../custom-drop-down/CustomDropDown";

export default function UnitPicker({ props }) {
    const {label, list, def} = props
    const [showDropDown, setShowDropDown] = useState(false);
    const [unit, setUnit] = useState(def ? def : "");

    return(
        <CustomDropDown
        label={label}
        mode={"outlined"}
        visible={showDropDown}
        showDropDown={() => setShowDropDown(true)}
        onDismiss={() => setShowDropDown(false)}
        value={unit}
        setValue={setUnit}
        list={list ? list : []}
        inputStyle={{
          marginVertical: 10
        }}
        />
    );
}
