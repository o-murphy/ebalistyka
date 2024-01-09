import {Grid} from "react-native-paper-grid";
import React from "react";
import InputCard from "./InputCard";
import styleSheet from "../../styles";
import {Unit, UnitProps} from "js-ballistics";
import MeasureSliderModal from "../measure-slider-modal/MeasureSliderModal";


export default function AtmoCard() {

    const fields = [
        {
            key: "temp",
            label: "Temperature",
            suffix: UnitProps[Unit.Celsius].symbol,
            icon: "thermometer",
            mode: "int",
            initialValue: 15,
            maxValue: 50,
            minValue: -50,
            decimals: 0
        },
        {
            key: "pressure",
            label: "Pressure",
            suffix: UnitProps[Unit.MmHg].symbol,
            icon: "speedometer",
            mode: "int",
            initialValue: 760,
            maxValue: 1000,
            minValue: 700,
            decimals: 0
        },
        {
            key: "humidity",
            label: "Humidity",
            suffix: "%",
            icon: "water",
            mode: "int",
            initialValue: 78,
            maxValue: 100,
            minValue: 0,
            decimals: 0
        },
        {
            key: "altitude",
            label: "Altitude",
            suffix: UnitProps[Unit.Meter].symbol,
            icon: "ruler",
            mode: "int",
            initialValue: 150,
            maxValue: 3000,
            minValue: 0,
            decimals: 0,
        },
    ]

    return (
        <InputCard title={"Current atmosphere"}>
            <Grid style={styleSheet.grid.grid}>
                {fields.map(field => <MeasureSliderModal key={field.key} field={field}/>)}
            </Grid>
        </InputCard>
    )
}