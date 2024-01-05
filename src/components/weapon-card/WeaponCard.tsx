import {Text, SegmentedButtons} from "react-native-paper";
import {Col, Grid, Row} from "react-native-paper-grid";
import React, {useState} from "react";
import InputCard from "../input-card/InputCard";
import styleSheet from "../../styles/stylesheet";
import SimpleModal from "../simple-modal/SimpleModal";
import MeasurePicker from "../measure-picker/MeasurePicker";
import IntPicker from "../int-picker/IntPicker";
import FloatPicker from "../float-picker/FloatPicker";


export default function WeaponCard() {

    const fields = [
        {
            key: "diameter",
            label: "Diameter",
            "suffix": "in",
            inputProps: {
                mode: "float",
                initialValue: 0.308,
                maxValue: 22,
                minValue: 0.001,
                maxLength: 8,
                maxDecimals: 3,
            }
        },
        {
            key: "twist",
            label: "Twist",
            "suffix": "in",
            inputProps: {
                mode: "int",
                initialValue: 11,
                maxValue: 20,
                minValue: -20,
                maxLength: 8,
                maxDecimals: 2,
            }
        },
    ]

    const twistStates = [{value: 'Right', label: 'Right'}, {value: 'Left', label: 'Left'}]

    const [curTwistDir, setCurTwistDir] = useState("Right");
    const [twistDir, setTwistDir] = useState(curTwistDir);



    const acceptTwistDir = (): void => {
        setCurTwistDir(twistDir)
    }

    const createField = field => {

        const [curValue, setCurValue] = useState(field.inputProps.initialValue);
        const [value, setValue] = useState(curValue)

        const onAccept = () => {
            // console.log(value)
            setCurValue(value)
        }

        return (
            <Row style={styleSheet.grid.row} key={field.key}>
                <Col size={6}>
                    <Text>{field.label}</Text>
                </Col>
                <Col size={4}>
                    <SimpleModal title={`${field.label}, ${field.suffix}`}
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

        <InputCard title={"Weapon"}>
            <Grid style={styleSheet.grid.grid}>

                {fields.map(createField)}

                <Row style={styleSheet.grid.row}>
                    <Col size={6}>
                        <Text>Twist direction</Text>
                    </Col>
                    <Col size={4}>
                        <SimpleModal title={"Twist"} text={curTwistDir} onAccept={acceptTwistDir}>
                            <SegmentedButtons buttons={twistStates} value={twistDir} onValueChange={setTwistDir}/>
                        </SimpleModal>
                    </Col>
                </Row>


            </Grid>
        </InputCard>

    )
}