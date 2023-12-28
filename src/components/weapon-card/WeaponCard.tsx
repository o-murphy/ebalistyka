import {Text, TextInput, useTheme} from "react-native-paper";
import {Col, Grid, Row} from "react-native-paper-grid";
import MeasurePicker from "../measure-picker/MeasurePicker";
import React, {useState} from "react";
import DropDown from "react-native-paper-dropdown";
import InputCard from "../input-card/InputCard";
import styleSheet from "../../styles/stylesheet";

export default function WeaponCard() {

    const theme = useTheme();

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

    const [showDropDown, setShowDropDown] = useState(false);
    const [twistDir, setTwistDir] = useState("Right");
    const twistDirs = [
        {
            label: "Right",
            value: "Right",
        },
        {
            label: "Left",
            value: "Left",
        },
    ];

    return (

        <InputCard title={"Weapon"}>
            <Grid style={styleSheet.grid.grid}>
                {
                    fields.map(field => {
                        return (
                            <Row style={styleSheet.grid.row} key={field.key}>
                                <Col size={5}>
                                    <Text>{field.label}</Text>
                                </Col>
                                <Col size={4}>
                                    <MeasurePicker {...field.inputProps} />
                                </Col>
                                <Col size={1}>
                                    <Text>{field.suffix}</Text>
                                </Col>
                            </Row>)
                    })
                }

                <Row style={styleSheet.grid.row}>
                    <Col size={5}>
                        <Text>Twist direction</Text>
                    </Col>
                    <Col size={4}>
                        <DropDown
                            // label={" "}
                            mode={"flat"}
                            visible={showDropDown}
                            showDropDown={() => setShowDropDown(true)}
                            onDismiss={() => setShowDropDown(false)}
                            value={twistDir}
                            setValue={setTwistDir}
                            list={twistDirs}

                            inputProps={{
                                style: {marginVertical: 8},
                                dense: true,
                                right: <TextInput.Icon icon="chevron-down" onPress={() => setShowDropDown(true)}/>
                            }}

                        />
                    </Col>
                    <Col size={1}></Col>
                </Row>


            </Grid>
        </InputCard>

    )
}