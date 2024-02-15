import {Grid} from "react-native-paper-grid";
import React from "react";
import InputCard from "./InputCard";
import styleSheet from "../../styles";
import {Unit, UnitProps} from "js-ballistics";
import MeasureSliderModal from "../measure-slider-modal/MeasureSliderModal";
import {useTranslate} from "../../translations/UseTranslate";


export default function AtmoCard() {

    const me = AtmoCard.name
    const translator = useTranslate()
    const tr = (str) => translator(me, str)

    const fields = [
        {
            key: "temp",
            label: tr("Temperature"),
            suffix: UnitProps[Unit.Celsius].symbol,
            icon: "thermometer",
            mode: "int" as const,
            initialValue: 15,
            maxValue: 50,
            minValue: -50,
            decimals: 0
        },
        {
            key: "pressure",
            label: tr("Pressure"),
            suffix: UnitProps[Unit.MmHg].symbol,
            icon: "speedometer",
            mode: "int" as const,
            initialValue: 760,
            maxValue: 1000,
            minValue: 700,
            decimals: 0
        },
        {
            key: "humidity",
            label: tr("Humidity"),
            suffix: "%",
            icon: "water",
            mode: "int" as const,
            initialValue: 78,
            maxValue: 100,
            minValue: 0,
            decimals: 0
        },
        {
            key: "altitude",
            label: tr("Altitude"),
            suffix: UnitProps[Unit.Meter].symbol,
            icon: "ruler",
            mode: "int" as const,
            initialValue: 150,
            maxValue: 3000,
            minValue: 0,
            decimals: 0,
        },
    ]

    return (
        <InputCard title={tr("Current atmosphere")}>
            <Grid style={styleSheet.grid.grid}>
                {fields.map(field => <MeasureSliderModal key={field.key} field={field}/>)}
            </Grid>
        </InputCard>
    )
}