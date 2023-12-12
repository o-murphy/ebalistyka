import React, { useState } from "react";
import CustomDropDown from "../custom-drop-down/CustomDropDown";

export default function LanguagePicker() {
    const [showDropDown, setShowDropDown] = useState(false);
    const [language, setLanguage] = useState("EN");
    const languageList = [
        {
            label: "English",
            value: "EN",
        },  
        {
          label: "Ukrainian",
          value: "UA",
        },
      ];


    return(
        <CustomDropDown 
        label={"Language"}
        mode={"outlined"}
        visible={showDropDown}
        showDropDown={() => setShowDropDown(true)}
        onDismiss={() => setShowDropDown(false)}
        value={language}
        setValue={setLanguage}
        list={languageList}
        inputStyle={{
          marginVertical: 10
        }}
        />
    );

}