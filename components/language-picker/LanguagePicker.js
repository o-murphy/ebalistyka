import React, { useState } from "react";
import DropDown from "react-native-paper-dropdown"

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
        <DropDown 
        label={"Language"}
        mode={"outlined"}
        visible={showDropDown}
        showDropDown={() => setShowDropDown(true)}
        onDismiss={() => setShowDropDown(false)}
        value={language}
        setValue={setLanguage}
        list={languageList}
        />
    );

}