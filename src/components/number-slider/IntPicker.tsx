import React from 'react';
import WheelPicker from '../wheely';
import styleSheet from "../../styles";
import {useTheme} from "react-native-paper";
import {View} from "react-native";


export default function IntPicker({
                                      maxValue = 50,
                                      minValue = -50,
                                      onChange = null,
                                      curValue = null
                                  }) {
    const theme = useTheme()
    const range = []
    for (let i = minValue; i <= maxValue; i++) {
        range.push(i)
    }

    const onValueChange = (index: number) => {
        if (onChange) onChange(range[index]);
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
        itemTextStyle: [{color: theme.colors.secondary, fontWeight: "bold", fontSize: 24}],
        itemStyle: [{}]
    }

    return (
        <View style={{display: "flex", flexDirection: "row", justifyContent: 'center'}}>
            <WheelPicker
                selectedIndex={range.indexOf(curValue)}
                options={range}
                onChange={onValueChange}
                {...style}
            />

        </View>
    );
}