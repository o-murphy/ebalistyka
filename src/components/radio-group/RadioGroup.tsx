import React, {useState} from "react";
import {List, RadioButton} from "react-native-paper";

type RadioItem = {
    label: string
    key: any
    value: any
}


type RadioProps = {
    initialValue: any
    onChange: Function|any
    items: RadioItem[]
}


export default function RadioGroup({initialValue, onChange, items}: RadioProps) {

    const [value, setValue] = useState(initialValue);

    const onValueChange = (value: number) => {
        setValue(value);
        if (onChange) onChange(value);
    }

    return (
        <List.Section>
            <RadioButton.Group onValueChange={onValueChange} value={value}>
                {items.map(item =>
                        <RadioButton.Item key={item.key} label={item.label} value={item.value}/>
                )}
            </RadioButton.Group>
        </List.Section>
    );

}