import React, {useState} from "react";
import {Col, Row} from "react-native-paper-grid";
import styleSheet from "../../styles";
import {Text} from "react-native-paper";
import SimpleDialog from "../dialogs/SimpleDialog";
import {IntPicker, FloatPicker} from "../number-picker";


export interface MeasureField {
    field: {
        key: any
        label: string
        suffix: string
        icon: string
        mode: "int" | "float"
        initialValue: number
        maxValue: number
        minValue: number
        decimals: number
    }
}


export default function MeasureSliderModal({field}: MeasureField) {
    const [curValue, setCurValue] = useState(field.initialValue);
    const [value, setValue] = useState(curValue)

    const onAccept = () => {
        setCurValue(value)
    }

    const onDecline = () => {
        setValue(value)
    }

    const pickerProps = {
        ...field,
        curValue: curValue,
        onChange: setValue
    }

    const picker =  field.mode === "int"
        ? <IntPicker {...pickerProps}/>
        : <FloatPicker {...pickerProps}/>

    return (
        <Row style={styleSheet.grid.row}>
            <Col size={8}>
                <Text style={{fontSize: 16}}>{field.label}</Text>
            </Col>
            <Col size={8}>
                <SimpleDialog icon={field.icon} label={`${field.label}, ${field.suffix}`}
                              text={`${curValue.toFixed(field.decimals)} ${field.suffix}`}
                              onAccept={onAccept}
                              onDecline={onDecline}>
                    {picker}
                </SimpleDialog>
            </Col>
        </Row>)
}