import {Text, SegmentedButtons, TextInput, useTheme} from "react-native-paper";
import {Col, Grid, Row} from "react-native-paper-grid";
import React, {useState} from "react";
import InputCard from "./InputCard";
import styleSheet from "../../styles";
import SimpleDialog from "../simple-modal/SimpleDialog";
import MeasureSliderModal from "../measure-slider-modal/MeasureSliderModal";


export default function WeaponCard() {

    const theme = useTheme()

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
        {
            value: 'Right',
            label: 'Right',
            icon: "rotate-right",
            showSelectedCheck: true,
            checkedColor: theme.colors.primary
        },
        {value: 'Left', label: 'Left', icon: "rotate-left", showSelectedCheck: true, checkedColor: theme.colors.primary}
    ]

    const [curTwistDir, setCurTwistDir] = useState("Right");
    const [twistDir, setTwistDir] = useState(curTwistDir);

    const [curName, setCurName] = React.useState("My rifle");
    const [name, setName] = React.useState(curName);

    const acceptTwistDir = (): void => {
        setCurTwistDir(twistDir)
    }

    const acceptName = () => {
        setCurName(name)
    }

    const declineName = () => {
        setName(curName)
    }

    return (

        <InputCard title={"Weapon"}>

            <SimpleDialog title={"Name"} icon={"card-bulleted-outline"}
                          text={curName}
                          onAccept={acceptName}
                          onDecline={declineName}
            >
                <TextInput value={name} onChangeText={setName} />
            </SimpleDialog>

            <Grid style={styleSheet.grid.grid}>

                {fields.map(field => <MeasureSliderModal key={field.key} field={field}/>)}

                <Row style={styleSheet.grid.row}>
                    <Col size={8}>
                        <Text style={{fontSize: 16}}>Twist direction</Text>
                    </Col>
                    <Col size={8}>
                        <SimpleDialog title={"Twist"} icon={curTwistDir === "Right" ? "rotate-right" : "rotate-left"}
                                      text={curTwistDir} onAccept={acceptTwistDir}>
                            <SegmentedButtons
                                buttons={twistStates} value={twistDir} onValueChange={setTwistDir}/>
                        </SimpleDialog>
                    </Col>
                </Row>

            </Grid>
        </InputCard>

    )
}