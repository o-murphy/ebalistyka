import React from 'react';
import WheelPicker from '../wheely';
import styleSheet from "../../styles";
import {useTheme} from "react-native-paper";
import {View} from "react-native";
import type {NumberPickerProps} from "./NumberPickerProps";


export default function IntPicker({...props}: NumberPickerProps) {
    const {maxValue, minValue, onChange, curValue} = props

    const theme = useTheme()

    const range = []
    for (let i = minValue; i <= maxValue; i++) {
        range.push(i)
    }

    const onValueChange = (index: number) => {
        if (onChange) onChange(range[index]);
    }

    const style: any = {
        selectedIndicatorStyle: {
            ...styleSheet.numberPicker.selectedIndicator,
            borderRadius: 0,
            backgroundColor: theme.colors.onSecondary
        },
        containerStyle: {
            ...styleSheet.numberPicker.container,
            backgroundColor: theme.colors.secondaryContainer,
            borderRadius: 24,
            marginTop: 10
        },
        itemTextStyle: {color: theme.colors.secondary, fontWeight: "bold", fontSize: 24},
    }

    return (
        <View style={{flexDirection: "row", justifyContent: 'center'}}>
            <WheelPicker
                {...style}
                selectedIndex={range.indexOf(curValue)}
                options={range}
                onChange={onValueChange}
            />
        </View>
    );
}