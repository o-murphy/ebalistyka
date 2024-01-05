import React, {useState} from "react";
import {Col, Row} from "react-native-paper-grid";
import styleSheet from "../../styles/stylesheet";
import {Text} from "react-native-paper";
import SimpleModal from "../simple-modal/SimpleModal";
import IntPicker from "../int-picker/IntPicker";
import FloatPicker from "../float-picker/FloatPicker";


export interface MeasureField {
    field: {
        key: any
        label: string
        suffix: string
        icon: string
        inputProps: {
            mode: "int" | "float"
            initialValue: number
            maxValue: number
            minValue: number
            decimals: number
        }
    }
}


export default function MeasureSliderModal({field}: MeasureField) {
    const [curValue, setCurValue] = useState(field.inputProps.initialValue);
    const [value, setValue] = useState(curValue)

    const onAccept = () => {
        setCurValue(value)
    }

    const onDecline = () => {
        setValue(value)
    }

    return (
        <Row style={styleSheet.grid.row}>
            <Col size={8}>
                <Text>{field.label}</Text>
            </Col>
            <Col size={8}>
                <SimpleModal icon={field.icon} title={`${field.label}, ${field.suffix}`}
                             text={`${curValue} ${field.suffix}`}
                             onAccept={onAccept}
                             onDecline={onDecline}>
                    {
                        field.inputProps.mode === "int"
                            ? <IntPicker  {...field.inputProps} curValue={curValue} onChange={setValue}/>
                            : <FloatPicker  {...field.inputProps} curValue={curValue} onChange={setValue}/>
                    }
                </SimpleModal>
            </Col>
        </Row>)
}