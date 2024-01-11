import React, {useState} from 'react';
import WheelPicker from '../wheely';
import styleSheet from "../../styles";
import {useTheme} from "react-native-paper";
import {View} from "react-native";
import type {NumberPickerProps} from "./NumberPickerProps";


const IntegerWheelPicker = ({...props}: NumberPickerProps) => {
    const {curValue, minValue, maxValue, onChange, wheelProps} = props

    const intRange: number[] = []
    for (let i = Math.floor(minValue); i <= Math.floor(maxValue); i++) {
        intRange.push(i)
    }

    const onIndexChange = (index: number): void => {
        onChange(intRange[index]);
    }

    return (
        <WheelPicker
            {...wheelProps}
            selectedIndex={intRange.indexOf(curValue)}
            options={intRange.map(item => `${item}`)}
            onChange={onIndexChange}
        />
    )
}


const DecimalWheelPicker = ({...props}: NumberPickerProps) => {

    const {curValue, decimals, onChange, wheelProps} = props

    const decimalFormat = (value: number): string => (value % 1).toFixed(decimals).slice(1);
    const decimalStep = 1 / (10 ** decimals)
    const createDecimalOptions = (): string[] => {
        let list = []
        for (let i = 0; i < 1; i += decimalStep) {
            list.push(decimalFormat(i))
        }
        return list
    }

    const decimalsOptions: string[] = createDecimalOptions()

    const onDecimalChange = (index: number): void => {
        onChange(parseFloat(decimalsOptions[index]));
    }

    return (
        <WheelPicker
            {...wheelProps}
            selectedIndex={decimalsOptions.indexOf(decimalFormat(curValue))}
            options={decimalsOptions}
            onChange={onDecimalChange}
        />
    )
}


export default function FloatPicker({...props}: NumberPickerProps) {

    const {curValue, minValue, maxValue, decimals, onChange} = props

    const theme = useTheme()

    const style = {
        selectedIndicatorStyle: {
            ...styleSheet.numberPicker.selectedIndicator,
            borderRadius: 0, backgroundColor: theme.colors.onSecondary
        },
        itemTextStyle: {color: theme.colors.secondary, fontWeight: "bold", fontSize: 24},
        containerStyle: {
            ...styleSheet.numberPicker.container,
            backgroundColor: theme.colors.secondaryContainer,
            marginTop: 10
        }
    }

    const intWheelProps = {
        ...style,
        containerStyle: {...style.containerStyle, borderTopLeftRadius: 24, borderBottomLeftRadius: 24},
        itemStyle: {marginLeft: "auto", marginRight: 0, paddingRight: 5},
    }

    const decimalWheelProps = {
        ...style,
        containerStyle: {...style.containerStyle, borderTopRightRadius: 24, borderBottomRightRadius: 24},
        itemStyle: {marginLeft: 0, marginRight: "auto", paddingLeft: 5},
    }

    const [int, setInt] = useState(Math.floor(curValue))
    const [decimal, setDecimal] = useState(curValue % 1)
    const onValueChange = (value: number) => {
        onChange ? onChange(value) : null
    }

    const onIntChange = (value) => {
        setInt(value)
        onValueChange(value + decimal)
    }

    const onDecimalChange = (value) => {
        setDecimal(value)
        onValueChange(value + int)
    }

    return (
        <View style={{flexDirection: "row", justifyContent: 'center'}}>
            <IntegerWheelPicker
                wheelProps={intWheelProps}
                {...{...props, curValue: int}}
                onChange={onIntChange}
            />

            <DecimalWheelPicker
                wheelProps={decimalWheelProps}
                {...{...props, curValue: decimal}}
                onChange={onDecimalChange}
            />
        </View>
    );
}