import React from "react";
import {List, Checkbox} from "react-native-paper";

export default function LanguagePicker({language, setLanguage, languageList}) {

    return (
        <List.Section>
            {languageList.map(item => <Checkbox.Item
                label={item.label}
                status={item.value === language ? "checked" : null}
                onPress={() => setLanguage(item.value)}
            />)}
        </List.Section>
    );

}