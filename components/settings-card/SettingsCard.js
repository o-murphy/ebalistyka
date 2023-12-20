import { Card, Text } from "react-native-paper"
import LanguagePicker from "../language-picker/LanguagePicker"
import UnitPicker from "../unit-picker/UnitPicker"

import { Unit, UnitProps, Measure } from "ts-ballistics"


const get_unit_list = (unit) => Object.keys(unit).map((key) => { return { label: UnitProps[unit[key]].name, value: unit[key] } })


const init_unit_list = [
    {
        label: "Distance",
        list: get_unit_list(Measure.Distance),
        def: Distance.Meter
    },
    {
        label: "Velocity",
        list: get_unit_list(Measure.Velocity),
        def: Unit.MPS
    },
    {
        label: "Angular",
        list: get_unit_list(Measure.Angular),
        def: Unit.Mil
    },
    {
        label: "Weight",
        list: get_unit_list(Measure.Weight),
        def: Unit.Grain
    },
    {
        label: "Temperature",
        list: get_unit_list(Measure.Temperature),
        def: Unit.Celsius
    },
    {
        label: "Pressure",
        list: get_unit_list(Measure.Pressure),
        def: Unit.PSI
    },
    {
        label: "Energy",
        list: get_unit_list(Measure.Energy),
        def: Unit.Joule
    },
]


export default function SettingsCard() {


    return (
        <Card mode="elevated" elevation={1} style={{ margin: 10, padding: 0 }}>
            <Card.Title title="Settings" />

            <Card.Content style={{ marginHorizontal: 10, paddingHorizontal: 10 }}>

                <Text variant="titleMedium" style={{ marginBottom: 10 }}>General</Text>

                <LanguagePicker style={{ flex: 1, marginBottom: 10 }} />

                {/* <Text style={{ marginVertical: 10 }} variant="bodyMedium">Units of measurement</Text> */}

                <Text variant="titleMedium" style={{ marginVertical: 10 }}>Units of measurement</Text>

                {init_unit_list.map((element) => <UnitPicker props={element} />)}

            </Card.Content>
        </Card>
    )

}