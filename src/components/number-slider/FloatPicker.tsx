import React, {useState} from 'react';
import WheelPicker from '../wheely';
import styleSheet from "../../styles";
import {useTheme} from "react-native-paper";
import {View} from "react-native";


export default function FloatPicker({
                                        curValue = 0,
                                        maxValue = 50,
                                        minValue = -50,
                                        decimals = 0,
                                        onChange = null
                                    }) {
    const theme = useTheme()

    const style = {
        selectedIndicatorStyle: [
            styleSheet.numberPicker.selectedIndicator,
            {borderRadius: 0, backgroundColor: theme.colors.onSecondary}
        ],

        itemTextStyle: [{color: theme.colors.secondary, fontWeight: "bold", fontSize: 24}],

    }

    const containerStyle = [
        styleSheet.numberPicker.container,
        {
            backgroundColor: theme.colors.secondaryContainer,
            marginTop: 10
        }
    ]

    const containerStyleInt = [containerStyle, {borderTopLeftRadius: 24, borderBottomLeftRadius: 24}]
    const containerStyleFloat = [containerStyle, {borderTopRightRadius: 24, borderBottomRightRadius: 24}]
    const itemStyleInt = [{marginLeft: "auto", marginRight: 0, paddingRight: 5}]
    const itemStyleFloat = [{marginLeft: 0, marginRight: "auto", paddingLeft: 5}]

    const floatDivider = 10 ** decimals
    const floatFormat = (value: number): string => `.${value}`;

    const floatRange: number[] = [...Array(floatDivider).keys()]
    const intRange: number[] = []
    for (let i = Math.floor(minValue); i <= Math.floor(maxValue); i++) {
        intRange.push(i)
    }
    const floatRangeStrings: string[] = floatRange.map(floatFormat)

    // const [value, setValue] = useState(initialValue);

    const [int, setInt] = useState(Math.floor(curValue))
    const [float, setFloat] = useState(Math.floor((curValue - int) * floatDivider))

    const onValueChange = (value: number) => {
        if (onChange) onChange(value);
    }

    const onIntChange = (index: number): void => {
        setInt(intRange[index]);
        onValueChange(float / floatDivider + int);
    }

    const onFloatChange = (index: number): void => {
        setFloat(floatRange[index]);
        onValueChange(float / floatDivider + int);
    }

    return (
        <View style={{display: "flex", flexDirection: "row", justifyContent: 'center'}}>
            <WheelPicker
                {...style}
                containerStyle={containerStyleInt}
                itemStyle={itemStyleInt}
                selectedIndex={intRange.indexOf(int)}
                options={intRange.map(item => `${item}`)}
                onChange={onIntChange}
            />
            <WheelPicker
                {...style}
                containerStyle={containerStyleFloat}
                itemStyle={itemStyleFloat}
                selectedIndex={floatRange.indexOf(float)}
                options={floatRangeStrings}
                onChange={onFloatChange}
            />
        </View>
    );
}