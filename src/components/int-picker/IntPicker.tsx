import React, {useState} from 'react';
import WheelPicker from 'react-native-wheely';
import styleSheet from "../../styles/stylesheet";
import {useTheme} from "react-native-paper";
import type {MeasurePickerProps} from "../measure-picker/MeasurePicker";


export default function IntPicker({
                                      initialValue = 0,
                                      maxValue = 50,
                                      minValue = -50,
                                      maxLength = 8,
                                      maxDecimals = 0,
                                  }: MeasurePickerProps) {
    const theme = useTheme()
    console.log(1 / Math.pow(10, maxDecimals))
    const range = []
    for (let i = minValue; i <= maxValue; i++) {
        range.push(i)
    }
    console.log(range)
    console.log(range.indexOf(initialValue))

    // const [selectedIndex, setSelectedIndex] = useState(0);
    const [value, setValue] = useState(initialValue);

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
                // maxWidth: 100,
                marginTop: 10
            }
        ],
        itemTextStyle: [{color: theme.colors.secondary, fontWeight: "bold"}],
        itemStyle: [{}]
    }

    return (
        <WheelPicker
            {...style}
            selectedIndex={range.indexOf(value)}
            options={range}
            onChange={(index) => setValue(range[index])}

            // selectedIndex={selectedIndex}
            // onChange={(index) => setSelectedIndex(index)}
        />
    );
}