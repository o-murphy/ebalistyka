import {Text, SegmentedButtons} from "react-native-paper";
import {Col, Grid, Row} from "react-native-paper-grid";
import React, {useState} from "react";
import InputCard from "../input-card/InputCard";
import styleSheet from "../../styles/stylesheet";
import SimpleModal from "../simple-modal/SimpleModal";
import MeasurePicker from "../measure-picker/MeasurePicker";


export default function WeaponCard() {

    const fields = [
        {
            key: "diameter",
            label: "Diameter",
            "suffix": "in",
            inputProps: {
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
                initialValue: 11,
                maxValue: 20,
                minValue: -20,
                maxLength: 8,
                maxDecimals: 2,
            }
        },
    ]

    const twistStates = [{value: 'Right', label: 'Right'}, {value: 'Left', label: 'Left'}]

    const [twistDir, setTwistDir] = useState("Right");

    return (

        <InputCard title={"Weapon"}>
            <Grid style={styleSheet.grid.grid}>
                {
                    fields.map(field => {
                        return (
                            <Row style={styleSheet.grid.row} key={field.key}>
                                <Col size={6}>
                                    <Text>{field.label}</Text>
                                </Col>
                                <Col size={4}>
                                    <SimpleModal title={`${field.label}, ${field.suffix}`}
                                                  text={`${field.inputProps.initialValue} ${field.suffix}`}
                                    >
                                        <MeasurePicker {...field.inputProps} />
                                    </SimpleModal>
                                </Col>
                            </Row>)
                    })
                }

                <Row style={styleSheet.grid.row}>
                    <Col size={6}>
                        <Text>Twist direction</Text>
                    </Col>
                    <Col size={4}>
                        <SimpleModal title={"Twist"} text={twistDir}>
                            <SegmentedButtons buttons={twistStates} value={twistDir} onValueChange={setTwistDir}/>
                        </SimpleModal>
                    </Col>
                </Row>


            </Grid>
        </InputCard>

    )
}