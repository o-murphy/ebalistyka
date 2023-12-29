import React, { useState } from "react";
import {Checkbox, List, TextInput} from "react-native-paper";
import DropDown from "react-native-paper-dropdown";

export default function UnitPicker({ field, setUnit }) {

    return (
        <List.Section>
            {field.list.map(item => <Checkbox.Item key={field.key}
                label={item.label}
                status={item.value === field.def ? "checked" : null}
                onPress={() => setUnit(field.label, item.value)}
            />)}
        </List.Section>
    );
}
