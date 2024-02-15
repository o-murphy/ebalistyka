import {Text, SegmentedButtons, TextInput, useTheme} from "react-native-paper";
import {Col, Grid, Row} from "react-native-paper-grid";
import React, {useState} from "react";
import InputCard from "./InputCard";
import styleSheet from "../../styles";
import {SimpleDialog} from "../dialogs";
import MeasureSliderModal from "../measure-slider-modal/MeasureSliderModal";
import {Unit, UnitProps} from "js-ballistics";
import {useTranslate} from "../../translations/UseTranslate";


export default function ProjectileCard() {

    const me = ProjectileCard.name
    const translator = useTranslate()
    const tr = (str) => translator(me, str)

    const theme = useTheme()

    const fields = [
        {
            key: "mv",
            label: tr("Muzzle velocity"),
            suffix: UnitProps[Unit.MPS].symbol,
            icon: "speedometer",
            mode: "int" as const,
            initialValue: 805,
            maxValue: 2000,
            minValue: 10,
            decimals: 0,
        },
        {
            key: "powder_temp",
            label: tr("Powder temperature"),
            suffix: UnitProps[Unit.Celsius].symbol,
            icon: "thermometer",
            mode: "int" as const,
            initialValue: 15,
            maxValue: 50,
            minValue: -50,
            decimals: 0,
        },
        {
            key: "powder_sens",
            label: tr("Temperature coefficient"),
            suffix: "/15°C",
            icon: "percent",
            mode: "float" as const,
            initialValue: 1,
            maxValue: 5,
            minValue: 0,
            decimals: 2,
        },
    ]


    const [curName, setCurName] = React.useState("My projectile");
    const [name, setName] = React.useState(curName);

    const acceptName = () => {
        setCurName(name)
    }

    const declineName = () => {
        setName(curName)
    }

    return (

        <InputCard title={tr("Projectile")}>

            <SimpleDialog label={tr("Name")} icon={"card-bulleted-outline"}
                          text={tr(curName)}
                          onAccept={acceptName}
                          onDecline={declineName}
            >
                <TextInput value={name} onChangeText={setName} />
            </SimpleDialog>

            <Grid style={styleSheet.grid.grid}>

                {fields.map(field => <MeasureSliderModal key={field.key} field={field}/>)}

            </Grid>
        </InputCard>

    )
}