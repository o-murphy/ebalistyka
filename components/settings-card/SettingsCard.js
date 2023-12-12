import { Card, Button, Text } from "react-native-paper"
import LanguagePicker from "../language-picker/LanguagePicker"
import UnitPicker from "../unit-picker/UnitPicker"


export default function SettingsCard() {


    return (
        <Card mode="elevated" elevation={1} style={{ margin: 10, padding: 0 }}>
            <Card.Title title="Settings"
            />
            <Card.Content style={{ margin: 10, padding: 10 }}>
                <Text style={{ marginVertical: 10 }} variant="bodyMedium">General</Text>
                <LanguagePicker style={{ flex: 1, marginBottom: 10 }} />

                <Text style={{ marginVertical: 10 }} variant="bodyMedium">Units of measurement</Text>
                <UnitPicker label="Distance" list={[{ label: "Meter", value: "m", },]} />
                <UnitPicker label="Velocity" list={[{ label: "MPS", value: "mps", },]} />
                <UnitPicker label="Angular" list={[{ label: "MIL", value: "MIL", },]} />
                <UnitPicker label="Weight" list={[{ label: "Grain", value: "grain", },]} />
                <UnitPicker label="Temperature" list={[{ label: "Celsius", value: "C", },]} />
                <UnitPicker label="Pressure" list={[{ label: "PSI", value: "psi", },]} />
                <UnitPicker label="Energy" list={[{ label: "Joule", value: "J", },]} />

            </Card.Content>
        </Card>
    )

}