import React, {useState} from 'react';
import WheelPicker from '../wheely';
import styleSheet from "../../styles/stylesheet";
import {useTheme} from "react-native-paper";
import type {MeasurePickerProps} from "../measure-picker/MeasurePicker";
import {View} from "react-native";


interface IntPickerProps extends MeasurePickerProps {
    onChange: (value: number) => void
}


export default function IntPicker({
                                      initialValue = 0,
                                      maxValue = 50,
                                      minValue = -50,
                                      onChange = null
                                  }: IntPickerProps) {
    const theme = useTheme()
    const range = []
    for (let i = minValue; i <= maxValue; i++) {
        range.push(i)
    }

    // const [selectedIndex, setSelectedIndex] = useState(0);
    const [value, setValue] = useState(initialValue);

    const onValueChange = (index: number) => {
        setValue(range[index]);
        if (onChange) onChange(value);
    }

    const style = {
        selectedIndicatorStyle: [
            styleSheet.numberPicker.selectedIndicator,
            {borderRadius: 0, backgroundColor: theme.colors.onSecondary}
        ],
        containerStyle: [
            styleSheet.numberPicker.container,
            {
                backgroundColor: theme.colors.secondaryContainer,
                borderRadius: 24,
                marginTop: 10
            }
        ],
        itemTextStyle: [{color: theme.colors.secondary, fontWeight: "bold"}],
        itemStyle: [{}]
    }

    return (
        <View style={{display: "flex", flexDirection: "row", flex: 1, justifyContent: 'center'}}>
            <WheelPicker
                selectedIndex={range.indexOf(value)}
                options={range}
                onChange={onValueChange}
                {...style}
            />

        </View>
    );
}