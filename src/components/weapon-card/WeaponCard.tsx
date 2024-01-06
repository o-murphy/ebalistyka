import {Text, SegmentedButtons} from "react-native-paper";
import {Col, Grid, Row} from "react-native-paper-grid";
import React, {useState} from "react";
import InputCard from "../input-card/InputCard";
import styleSheet from "../../styles/stylesheet";
import SimpleModal from "../simple-modal/SimpleModal";
import MeasureSliderModal from "../measure-slider-modal/MeasureSliderModal";


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
                decimals: 3,
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
                decimals: 2,
            }
        },
    ]

    const twistStates = [
        {value: 'Right', label: 'Right', icon: "rotate-right"},
        {value: 'Left', label: 'Left', icon: "rotate-left"}
    ]

    const [curTwistDir, setCurTwistDir] = useState("Right");
    const [twistDir, setTwistDir] = useState(curTwistDir);

    const acceptTwistDir = (): void => {
        setCurTwistDir(twistDir)
    }

    return (

        <InputCard title={"Weapon"}>
            <Grid style={styleSheet.grid.grid}>

                {fields.map(field => <MeasureSliderModal key={field.key} field={field}/>)}

                <Row style={styleSheet.grid.row}>
                    <Col size={8}>
                        <Text>Twist direction</Text>
                    </Col>
                    <Col size={8}>
                        <SimpleModal title={"Twist"} icon={curTwistDir === "Right" ? "rotate-left" : "rotate-right"}
                                     text={curTwistDir} onAccept={acceptTwistDir}>
                            <SegmentedButtons buttons={twistStates} value={twistDir} onValueChange={setTwistDir}/>
                        </SimpleModal>
                    </Col>
                </Row>

            </Grid>
        </InputCard>

    )
}