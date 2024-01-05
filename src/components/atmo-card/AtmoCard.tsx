import {Text} from "react-native-paper";
import {Col, Grid, Row} from "react-native-paper-grid";
import React, {useState} from "react";
import InputCard from "../input-card/InputCard";
import styleSheet from "../../styles/stylesheet";
import SimpleModal from "../simple-modal/SimpleModal";
import IntPicker from "../int-picker/IntPicker";
import FloatPicker from "../float-picker/FloatPicker";
import {Unit, UnitProps} from "js-ballistics";


export default function AtmoCard() {

    const fields = [
        {
            key: "temp",
            label: "Temperature",
            suffix: UnitProps[Unit.Celsius].symbol,
            icon: "thermometer",
            inputProps: {
                mode: "int",
                initialValue: 15,
                maxValue: 50,
                minValue: -50,
                maxLength: 4,
                maxDecimals: 1
            }
        },
        {
            key: "pressure",
            label: "Pressure",
            suffix: UnitProps[Unit.MmHg].symbol,
            icon: "speedometer",
            inputProps: {
                mode: "int",
                initialValue: 760,
                maxValue: 1000,
                minValue: 700,
                maxLength: 6,
                maxDecimals: 0
            }
        },
        {
            key: "humidity",
            label: "Humidity",
            suffix: "%",
            icon: "water",
            inputProps: {
                mode: "int",
                initialValue: 78,
                maxValue: 100,
                minValue: 0,
                maxLength: 3,
                maxDecimals: 0
            }
        },
        {
            key: "altitude",
            label: "Altitude",
            suffix: UnitProps[Unit.Meter].symbol,
            icon: "ruler",
            inputProps: {
                mode: "int",
                initialValue: 150,
                maxValue: 3000,
                minValue: 0,
                maxLength: 8,
                maxDecimals: 0,
            }
        },
    ]

    const createField = (field) => {

        const [curValue, setCurValue] = useState(field.inputProps.initialValue);
        const [value, setValue] = useState(curValue)

        const onAccept = () => {
            // console.log(value)
            setCurValue(value)
        }

        return (
            <Row style={styleSheet.grid.row} key={field.key}>
                <Col size={8}>
                    <Text>{field.label}</Text>
                </Col>
                <Col size={8}>
                    <SimpleModal icon={field.icon} title={`${field.label}, ${field.suffix}`}
                                 text={`${curValue} ${field.suffix}`}
                                 onAccept={onAccept}
                    >
                        {field.inputProps.mode === "int"
                            ? <IntPicker  {...field.inputProps} initialValue={curValue} onChange={setValue}/>
                            : <FloatPicker  {...field.inputProps} initialValue={curValue} onChange={setValue}/>}
                    </SimpleModal>
                </Col>
            </Row>)
    }

    return (

        <InputCard title={"Current atmosphere"}>
            <Grid style={styleSheet.grid.grid}>
                {
                    fields.map(createField)
                }
            </Grid>
        </InputCard>
    )
}