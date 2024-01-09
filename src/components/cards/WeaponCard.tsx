import {Text, SegmentedButtons, TextInput, useTheme} from "react-native-paper";
import {Col, Grid, Row} from "react-native-paper-grid";
import React, {useState} from "react";
import InputCard from "./InputCard";
import styleSheet from "../../styles";
import {SimpleDialog} from "../dialogs";
import MeasureSliderModal from "../measure-slider-modal/MeasureSliderModal";


export default function WeaponCard() {

    const theme = useTheme()

    const fields = [
        {
            key: "diameter",
            label: "Diameter",
            suffix: "in",
            icon: "diameter-variant",
            mode: "float" as const,
            initialValue: 0.308,
            maxValue: 22,
            minValue: 0.001,
            decimals: 3,
        },
        {
            key: "twist",
            label: "Twist",
            suffix: "in",
            icon: "screw-flat-top",
            mode: "float" as const,
            initialValue: 11,
            maxValue: 20,
            minValue: -20,
            decimals: 2,
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

            <SimpleDialog label={"Name"} icon={"card-bulleted-outline"}
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
                        <SimpleDialog label={"Twist"} icon={curTwistDir === "Right" ? "rotate-right" : "rotate-left"}
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