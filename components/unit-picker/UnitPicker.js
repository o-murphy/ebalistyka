import React, { useState } from "react";
import DropDown from "react-native-paper-dropdown"
import { View } from "react-native-web";
import { TextInput } from "react-native-paper";
import CustomDropDown from "../custom-drop-down/CustomDropDown";

export default function UnitPicker({ label }) {
    const [showDropDown, setShowDropDown] = useState(false);
    const [unit, setUnit] = useState("m");
    const unitList = [
        {
            label: "Meter",
            value: "m",
        },  
        {
          label: "Inch",
          value: "in",
        },
      ];


    return(
      <View>
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

        </View>
    );

}