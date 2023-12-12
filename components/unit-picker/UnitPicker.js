import React, { useState } from "react";
import CustomDropDown from "../custom-drop-down/CustomDropDown";

export default function UnitPicker({ label, list }) {
    const [showDropDown, setShowDropDown] = useState(false);
    
    const unitList = list ? list : [
        {
            label: "Meter",
            value: "m",
        },  
        {
          label: "Inch",
          value: "in",
        },
      ];

    const [unit, setUnit] = useState(unitList[0].value);  // FIXME: temp placeholder


    return(
        <CustomDropDown
        label={label}
        mode={"outlined"}
        visible={showDropDown}
        showDropDown={() => setShowDropDown(true)}
        onDismiss={() => setShowDropDown(false)}
        value={unit}
        setValue={setUnit}
        list={unitList}
        inputStyle={{
          marginVertical: 10
        }}
        />
    );

}