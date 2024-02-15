import {Text, SegmentedButtons, TextInput, useTheme} from "react-native-paper";
import {Col, Grid, Row} from "react-native-paper-grid";
import React, {useState} from "react";
import InputCard from "./InputCard";
import styleSheet from "../../styles";
import {SimpleDialog} from "../dialogs";
import MeasureSliderModal from "../measure-slider-modal/MeasureSliderModal";
import {Unit, UnitProps} from "js-ballistics";
import {useTranslate} from "../../translations/UseTranslate";


export default function WeaponCard() {

    const me = WeaponCard.name
    const translator = useTranslate()
    const tr = (str) => translator(me, str)

    const theme = useTheme()

    const fields = [
        {
            key: "diameter",
            label: tr("Diameter"),
            suffix: UnitProps[Unit.Inch].symbol,
            icon: "diameter-variant",
            mode: "float" as const,
            initialValue: 0.308,
            maxValue: 22,
            minValue: 0.001,
            decimals: 3,
        },
        {
            key: "sight_height",
            label: tr("Sight height"),
            suffix: UnitProps[Unit.Inch].symbol,
            icon: "crosshairs",
            mode: "float" as const,
            initialValue: 3,
            maxValue: 5,
            minValue: 0,
            decimals: 1,
        },
        {
            key: "twist",
            label: tr("Twist"),
            suffix: UnitProps[Unit.Inch].symbol,
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
            label: tr('Right'),
            icon: "rotate-right",
            showSelectedCheck: true,
            checkedColor: theme.colors.primary
        },
        {
            value: 'Left',
            label: tr('Left'),
            icon: "rotate-left",
            showSelectedCheck: true,
            checkedColor: theme.colors.primary
        }
    ]

    const [curTwistDir, setCurTwistDir] = useState("Right");
    const [twistDir, setTwistDir] = useState(curTwistDir);

    const [curName, setCurName] = React.useState("My rifle");
    const [name, setName] = React.useState(curName);

    const acceptTwistDir = (): void => {
        setCurTwistDir(twistDir)
    }

    const declineTwistDir = (): void => {
        setTwistDir(curTwistDir)
    }

    const acceptName = () => {
        setCurName(name)
    }

    const declineName = () => {
        setName(curName)
    }

    return (

        <InputCard title={tr("Weapon")}>

            <SimpleDialog label={tr("Name")} icon={"card-bulleted-outline"}
                          text={tr(curName)}
                          onAccept={acceptName}
                          onDecline={declineName}
            >
                <TextInput value={name} onChangeText={setName} />
            </SimpleDialog>

            <Grid style={styleSheet.grid.grid}>

                {fields.map(field => <MeasureSliderModal key={field.key} field={field}/>)}

                <Row style={styleSheet.grid.row}>
                    <Col size={8}>
                        <Text style={{fontSize: 16}}>{tr("Twist direction")}</Text>
                    </Col>
                    <Col size={8}>
                        <SimpleDialog label={tr("Twist direction")} icon={curTwistDir === "Right" ? "rotate-right" : "rotate-left"}
                                      text={tr(curTwistDir)} onAccept={acceptTwistDir} onDecline={declineTwistDir}>
                            <SegmentedButtons
                                buttons={twistStates} value={twistDir} onValueChange={setTwistDir}/>
                        </SimpleDialog>
                    </Col>
                </Row>

            </Grid>
        </InputCard>

    )
}