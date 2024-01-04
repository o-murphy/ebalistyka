import React from "react";
import {List, RadioButton} from "react-native-paper";

type RadioItem = {
    label: string
    key: any
    value: any
}


type RadioProps = {
    value: any
    setValue: Function|any
    items: RadioItem[]
}


export default function RadioGroup({value, setValue, items}: RadioProps) {

    return (
        <List.Section>
            <RadioButton.Group onValueChange={setValue} value={value}>
                {items.map(item =>
                        <RadioButton.Item key={item.key} label={item.label} value={item.value}/>
                )}
            </RadioButton.Group>
        </List.Section>
    );

}