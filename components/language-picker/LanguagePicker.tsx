import React, { useState } from "react";
import { TextInput } from "react-native-paper";
import DropDown from "react-native-paper-dropdown";

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
        mode={"flat"}
        visible={showDropDown}
        showDropDown={() => setShowDropDown(true)}
        onDismiss={() => setShowDropDown(false)}
        value={language}
        setValue={setLanguage}
        list={languageList}

        inputProps = {{
          style: {marginVertical: 8},
          dense: true,
          right: <TextInput.Icon icon="chevron-down" onPress={() => setShowDropDown(true)}/>
        }}

      />
    );

}