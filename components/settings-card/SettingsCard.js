import { Card, Text } from "react-native-paper"
import LanguagePicker from "../language-picker/LanguagePicker"
import UnitPicker from "../unit-picker/UnitPicker"

import { Angular, Distance, Energy, Pressure, Temperature, Unit, UnitPropsDict, Velocity, Weight } from "js-ballistics"

// console.log(Distance)
// console.log(Object.keys(Distance).forEach(element => {
//     console.log(Distance[element])
// }));


const get_unit_list = (unit) => Object.keys(unit).map((key) => { return { label: UnitPropsDict[unit[key]].name, value: unit[key] } })


const init_unit_list = [
    {
        label: "Distance",
        list: get_unit_list(Distance),
        def: Distance.Meter
    },
    {
        label: "Velocity",
        list: get_unit_list(Velocity),
        def: Velocity.MPS
    },
    {
        label: "Angular",
        list: get_unit_list(Angular),
        def: Angular.Mil
    },
    {
        label: "Weight",
        list: get_unit_list(Weight),
        def: Weight.Grain
    },
    {
        label: "Temperature",
        list: get_unit_list(Temperature),
        def: Temperature.Celsius
    },
    {
        label: "Pressure",
        list: get_unit_list(Pressure),
        def: Pressure.PSI
    },
    {
        label: "Energy",
        list: get_unit_list(Energy),
        def: Energy.Joule
    },
]


export default function SettingsCard() {


    return (
        <Card mode="elevated" elevation={1} style={{ margin: 10, padding: 0 }}>
            <Card.Title title="Settings"
            />
            <Card.Content style={{ margin: 10, padding: 10 }}>
                <Text style={{ marginVertical: 10 }} variant="bodyMedium">General</Text>
                <LanguagePicker style={{ flex: 1, marginBottom: 10 }} />

                <Text style={{ marginVertical: 10 }} variant="bodyMedium">Units of measurement</Text>

                {init_unit_list.map((element) => <UnitPicker props={element} />)}

            </Card.Content>
        </Card>
    )

}