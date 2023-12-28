import {Card, Text} from "react-native-paper"
import LanguagePicker from "../language-picker/LanguagePicker"
import UnitPicker from "../unit-picker/UnitPicker"

import {
    Unit,
    UnitProps,
    Measure,
} from "js-ballistics"


const get_unit_list = (measure: Object) =>
    Object.keys(measure).map((key: string): {label: string, value: Unit} => {
    return {label: UnitProps[measure[key]].name, value: measure[key]}
})

const init_unit_list = [
    {
        label: "Distance",
        list: get_unit_list(Measure.Distance),
        def: Unit.Meter
    },
    {
        label: "Velocity",
        list: get_unit_list(Measure.Velocity),
        def: Unit.MPS
    },
    {
        label: "Angular",
        list: get_unit_list(Measure.Angular),
        def: Unit.MIL
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
        <Card mode="elevated" elevation={1} style={{margin: 10, padding: 10}}>
            <Card.Title title="Settings"/>

            <Card.Content style={{marginHorizontal: 10, paddingHorizontal: 10}}>

                <Text variant="titleMedium" style={{marginBottom: 10}}>General</Text>
                {/* @ts-ignore */}
                <LanguagePicker style={{flex: 1, marginBottom: 10}}/>

                {/* <Text style={{ marginVertical: 10 }} variant="bodyMedium">Units of measurement</Text> */}

                <Text variant="titleMedium" style={{marginVertical: 10}}>Units of measurement</Text>

                {init_unit_list.map((element) => <UnitPicker props={element}/>)}

            </Card.Content>
        </Card>
    )

}