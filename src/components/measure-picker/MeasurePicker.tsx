import React, {useState} from 'react';
import {NumberFormatBase} from 'react-number-format';
import {TextInput} from "react-native-paper";


export type MeasurePickerProps = {
    initialValue: number,
    maxValue: number,
    minValue: number,
    maxLength: number,
    maxDecimals: number,
}


const MeasurePicker = ({
                           initialValue = 0,
                           maxValue = 3000,
                           minValue = 1,
                           maxLength = 8,
                           maxDecimals = 2,

                       }: MeasurePickerProps) => {

    let _initialValue = initialValue.toFixed(maxDecimals)
    const [rawValue, setRawValue] = useState(initialValue)

    const rightToLeftFormatter = (value: string) => {

        if (!Number(value)) return (minValue).toFixed(maxDecimals)

        let amount: string = '';
        let _value: number;

        if (amount.length > maxDecimals) {
            _value = parseInt(value);
        } else {
            _value = (parseInt(value) / Math.pow(10, maxDecimals));
        }

        _value = _value < minValue ? minValue : _value > maxValue ? maxValue : _value

        amount = _value.toFixed(maxDecimals)

        return `${amount}`;
    };


    const onValueChange = (value): void => {
        _initialValue = rawValue.toFixed(maxDecimals)
        setRawValue(parseFloat(value.formattedValue))
    }

    return (
        <NumberFormatBase
            value={_initialValue}
            maxLength={maxLength}
            style={{textAlign: "right"}}
            format={rightToLeftFormatter}
            dense={true}
            customInput={TextInput}
            onValueChange={onValueChange}
        />

    );
};

export default MeasurePicker;

