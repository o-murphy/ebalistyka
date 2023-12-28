import React, { useState } from "react";
import { TextInput } from "react-native-paper";
import DropDown from "react-native-paper-dropdown";

export default function UnitPicker({ props }) {
    const {label, list, def} = props
    const [showDropDown, setShowDropDown] = useState(false);
    const [unit, setUnit] = useState(def ? def : "");

    return(
      <DropDown
        // label={label}
        mode={"flat"}
        visible={showDropDown}
        showDropDown={() => setShowDropDown(true)}
        onDismiss={() => setShowDropDown(false)}
        value={unit}
        setValue={setUnit}
        list={list ? list : []}

        inputProps = {{
          style: {marginVertical: 8},
          dense: true,
          right: <TextInput.Icon icon="chevron-down" onPress={() => setShowDropDown(true)}/>
        }}

      />
    );
}
